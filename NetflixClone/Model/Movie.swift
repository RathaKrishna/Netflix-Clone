//
//  Movie.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 25/05/22.
//

import Foundation

struct MoviesResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let overview: String
    let media_type: String?
    let title: String?
    let original_title: String?
    let poster_path: String?
    let backdrop_path: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
    
    
}
