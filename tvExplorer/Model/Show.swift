//
//  Series.swift
//  tvExplorer
//
//  Created by Alexandre Porto Alegre Fernandes on 12/05/23.
//

import Foundation
import UIKit

struct Show: Identifiable, Hashable {
    let id: Int
    let title: String
    let ongoing: Bool
    let image: UIImage
    let startYear: String
    let endYear: String
    let rating: Double?
    let genres: [String]
    let summary: String
    let externalUrl: String
    let aka: [String]?
    
    static var sampleShow = Show(
        id: 139,
        title: "Girls",
        ongoing: false,
        image: UIImage(named: "missing")!,
        startYear: "2012",
        endYear: "2017",
        rating: 6.6,
        genres: ["Drama", "Romance"],
        summary: "<p>This Emmy winning series is a comic look at the assorted humiliations and rare triumphs of a group of girls in their 20s.</p>",
        externalUrl: "https://www.tvmaze.com/shows/139/girls",
        aka: ["Fetele", "Csajok"]
    )
}

// MARK: - Show
struct ShowJSON: Codable {
    let id: Int
    let url: String
    let name: String
    let image: String
    let genres: [String]
    let runtime, averageRuntime: Int?
    let premiered, ended: String?
    let officialSite: String?
    let summary: String?
}
