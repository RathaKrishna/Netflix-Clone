//
//  YoutubeModel.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 31/05/22.
//

import Foundation

struct YoutubeResponse: Codable {
    let etag: String
    let items: [YoutubeItem]
    let kind: String
    let nextPageToken: String
    let regionCode: String
}

struct YoutubeItem: Codable {
    let etag: String
    let id: ItemId
    let kind: String
    
}

struct ItemId: Codable {
    let kind: String
    let videoId: String
}
