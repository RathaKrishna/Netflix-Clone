//
//  TVShows.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 25/05/22.
//

import Foundation

struct TrendingTVResponse: Codable {
    let results: [TV]
}

struct TV: Codable {
    let id: Int
    let backdrop_path: String?
    let first_air_date: String?
    let media_type: String?
    let name: String?
    let origin_country: [String]
    let original_name: String?
    let overview: String?
    let poster_path: String?
    let vote_average: Double
    let vote_count: Int
}
