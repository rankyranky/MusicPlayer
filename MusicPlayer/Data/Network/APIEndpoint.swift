//
//  APIEndpoint.swift
//  MusicPlayer
//
//  Created by rankyranky on 02/06/26.
//


import Foundation

/// Represents an API endpoint with path and query parameters. Builds the full URL for iTunes Search API requests.
struct APIEndpoint {
    let path: String
    let queryItems: [URLQueryItem]

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }

    static func searchMusic(term: String, limit: Int = 25) -> APIEndpoint {
        APIEndpoint(
            path: "/search",
            queryItems: [
                URLQueryItem(name: "term", value: term),
                URLQueryItem(name: "media", value: "music"),
                URLQueryItem(name: "entity", value: "song"),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
        )
    }
}
