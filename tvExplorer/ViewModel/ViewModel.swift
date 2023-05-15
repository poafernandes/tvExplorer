//
//  ShowViewModal.swift
//  tvExplorer
//
//  Created by Alexandre Porto Alegre Fernandes on 13/05/23.
//

import Foundation
import SwiftUI

final class ViewModel: ObservableObject {
    
    @Published var showList = [Show]()
    @Published var searchText = "" {
        didSet {
            searchDone = false
        }
    }
    @Published var fetchingShows = false
    
    private var showListJson: JsonShowsResponse = []
    
    private var totalSections: Int {
        let sections = ceil(Double(showListJson.count / sectionSize))
        return Int(sections)
    }
    
    private var apiPage: Int = 0
    private var currentSection = 1
    private var threshold = 15
    private let sectionSize = 30
    private var running = false
    private var searchDone = false
    
    var networkService: ShowsNetworkService
    
    init(networkService: ShowsNetworkService) {
        self.networkService = networkService
    }
    
    fileprivate func fetchShows(page: Int) async throws -> JsonShowsResponse {
        return try await networkService.searchShows(page: apiPage)
    }
    
    fileprivate func fetchQueriedShows(query: String) async throws -> JsonShowsResponse {
        return try await networkService.searchShowQuery(query: query)
    }
    
    fileprivate func convertJsonShow(section: JsonShowsResponse) async throws -> [Show] {
        let convertedResult = try await section.asyncMap{ show in

            let image = try await networkService.obtainRemoteImage(url: show.image.medium)
            let aliases = try await networkService.searchShowAliases(id: String(show.id))
            
            
            return Show(id: show.id ,
                        title: show.name ,
                        ongoing: show.status.lowercased() == "ended" ? false : true,
                        image: image,
                        startYear: show.premiered?.obtainYearFromString() ?? "N/A",
                        endYear: show.ended?.obtainYearFromString() ?? "N/A",
                        rating: show.rating.average,
                        genres: show.genres,
                        summary: show.summary?.stripTags ?? "No description available",
                        externalUrl: show.url ,
                        aka: aliases)
        }
        
        return convertedResult
    }
    
    fileprivate func loadMoreContent(currentShow: Show) {
        if fetchingShows != true {
            fetchingShows = true

            if currentSection >= totalSections {
                Task(priority: .background) {
                    apiPage += 1
                    showListJson = try await fetchShows(page: apiPage)
                    let section = Array(showListJson.prefix(30))
                    let convertedResult = try await convertJsonShow(section: section)
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.fetchingShows = false
                        self?.showList.append(contentsOf: convertedResult)
                    }
                }
                return
            } else {
                guard let lastShowFormatted = showList.last, let startingIndex = showListJson.firstIndex(where: { show in
                    show.id == lastShowFormatted.id
                }) else {
                    return
                }
                
                let endingIndex = startingIndex + sectionSize
                let section = Array(showListJson[startingIndex+1...endingIndex])
                currentSection += 1
                
                Task(priority: .background) {
                    let convertedResult = try await convertJsonShow(section: section)
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.showList.append(contentsOf: convertedResult)
                        self?.fetchingShows = false
                    }
                    #if DEBUG
                        print("Finished acquiring more")
                    #endif
                }
            }
        }
    }
    
    func fetchShowsContent(currentShow: Show?) -> Void{
        if searchText.isEmpty || searchDone {
            if let show = currentShow {
                //Se > threshold pegar mais da paginação interna
                if let currentShowIndex = showList.firstIndex(of: show),
                   currentShowIndex > showList.count - threshold {
                   loadMoreContent(currentShow: show)
                }
            } else {
                Task(priority: .background) { [weak self] in
                    DispatchQueue.main.async { [weak self] in
                        self?.fetchingShows = true
                    }
                    showListJson = try await fetchShows(page: apiPage)
                    let section = Array(showListJson.prefix(30))
                    let convertedResult = try await convertJsonShow(section: section)
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.fetchingShows = false
                        self?.showList = convertedResult
                    }
                }
            }
        } else {
            Task(priority: .background) { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.fetchingShows = true
                }
                showListJson = try await fetchQueriedShows(query: searchText)
                let section = Array(showListJson.prefix(30))
                let convertedResult = try await convertJsonShow(section: section)
                
                DispatchQueue.main.async { [weak self] in
                    self?.fetchingShows = false
                    self?.showList = convertedResult
                    self?.searchDone = true
                }
            }
        }
    }
}
