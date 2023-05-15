//
//  ShowsNetworkServiceTests.swift
//  tvExplorerTests
//
//  Created by Alexandre Porto Alegre Fernandes on 15/05/23.
//

import XCTest
@testable import tvExplorer


final class ShowsNetworkServiceTests: XCTestCase {

    var networkService: ShowsNetworkService!
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkService = ShowsNetworkService()

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        networkService = nil
    }

    func testSearchShowQuery() async throws {
        let response = try await networkService.searchShowQuery(query: "Girls")
        
        let mockedService = MockNetworkService()
        let mockResponse = try await mockedService.searchShowQuery(query: "Girls")
        
        XCTAssertEqual(response.count, mockResponse.count)
    }
    
    func testSearchShows() async throws {
        let response = try await networkService.searchShows(page: 0)
        
        let mockedService = MockNetworkService()
        let mockResponse = try await mockedService.searchShows(page: 0)
        
        XCTAssertEqual(response.count, mockResponse.count)
    }


    func testObtainRemoteImage() async throws {
        let networkService = ShowsNetworkService()
        let imageUrl = "https://static.tvmaze.com/uploads/images/medium_portrait/31/78286.jpg"

        // Obtain image from network service
        let remoteImage = try await networkService.obtainRemoteImage(url: imageUrl)
        
        // Obtain image from bundle
        guard let bundleImage = UIImage(named: "78286", in: Bundle(for: ShowsNetworkServiceTests.self), compatibleWith: nil) else {
            XCTFail("Failed to obtain image from bundle.")
            return
        }

        // Compare images
        XCTAssertEqual(remoteImage.pngData(), bundleImage.pngData(), "The obtained image is different from the image in the bundle.")
    }

}
