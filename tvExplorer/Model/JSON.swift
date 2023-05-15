//
//  JSONModel.swift
//  tvExplorer
//
//  Created by Alexandre Porto Alegre Fernandes on 13/05/23.
//

import Foundation

typealias JsonSearchResponse = [JsonShowSearch]
typealias JsonShowsResponse = [JsonShow]
typealias JsonAliases = [JsonAlias]

struct JsonShowSearch: Codable {
    let score: Float?
    let show: JsonShow?
    
    enum CodingKeys: String, CodingKey {
        case score = "score"
        case show = "show"
    }
}

struct JsonShow: Codable, Equatable {
    static func == (lhs: JsonShow, rhs: JsonShow) -> Bool {
        lhs.id == rhs.id &&
        lhs.url == rhs.url &&
        lhs.name == rhs.name &&
        lhs.type == rhs.type &&
        lhs.language == rhs.language &&
        lhs.genres == rhs.genres &&
        lhs.status == rhs.status &&
        lhs.runtime == rhs.runtime &&
        lhs.averageRuntime == rhs.averageRuntime &&
        lhs.premiered == rhs.premiered &&
        lhs.ended == rhs.ended &&
        lhs.officialSite == rhs.officialSite &&
        lhs.weight == rhs.weight &&
        lhs.updated == rhs.updated
    }
    
    let id: Int
    let url: String
    let name: String
    let type: String
    let language: String
    let genres: [String]
    let status: String
    let runtime, averageRuntime: Int?
    let premiered, ended: String?
    let officialSite: String?
    let schedule: Schedule
    let rating: JsonRating
    let weight: Int
    let network, webChannel: Network?
    let dvdCountry: Country?
    let externals: Externals
    let image: JsonImage
    let summary: String?
    let updated: Int
    let links: Links
    
    enum CodingKeys: String, CodingKey {
        case id, url, name, type, language, genres, status, runtime, averageRuntime, premiered, ended, officialSite, schedule, rating, weight, network, webChannel, dvdCountry, externals, image, summary, updated
        case links = "_links"
    }

}

struct JsonImage: Codable {
    let medium, original: String
}

struct JsonRating: Codable {
    let average: Double?
}

struct JsonAlias: Codable {
    let name: String?
    let country: Country?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case country = "country"
    }
}

// MARK: - Network
struct Network: Codable {
    let id: Int
    let name: String
    let country: Country?
    let officialSite: String?
}

// MARK: - Schedule
struct Schedule: Codable {
    let time: String
    let days: [String]
}

// MARK: - Country
struct Country: Codable {
    let name, code, timezone: String
}

// MARK: - Externals
struct Externals: Codable {
    let tvrage, thetvdb: Int?
    let imdb: String?
}

// MARK: - Links
struct Links: Codable {
    let linksSelf: Nextepisode
    let previousepisode, nextepisode: Nextepisode?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case previousepisode, nextepisode
    }
}

// MARK: - Nextepisode
struct Nextepisode: Codable {
    let href: String
}
