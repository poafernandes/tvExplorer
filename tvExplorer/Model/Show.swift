//
//  Series.swift
//  tvExplorer
//
//  Created by Alexandre Porto Alegre Fernandes on 12/05/23.
//

import Foundation

struct Show: Identifiable {
    let id = UUID()
    let title: String
    let ongoing: Bool
    let image: String
    let startYear: Int
    let endYear: Int?
    let rating: Float?
    let genres: [String]
    let summary: String
    let externalUrl: String
    let aka: [String]?
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

let exampleShow = Show(
    title: "Girls",
    ongoing: false,
    image: "78286",
    startYear: 2012,
    endYear: 2017,
    rating: 6.6,
    genres: ["Drama", "Romance"],
    summary: "<p>This Emmy winning series is a comic look at the assorted humiliations and rare triumphs of a group of girls in their 20s.</p>",
    externalUrl: "https://www.tvmaze.com/shows/139/girls",
    aka: ["Fetele", "Csajok"]
)
