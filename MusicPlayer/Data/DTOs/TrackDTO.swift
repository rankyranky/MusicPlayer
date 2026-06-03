//
//  TrackDTO.swift
//  MusicPlayer
//
//  Created by rankyranky on 02/06/26.
//


import Foundation

/// Top-level response wrapper matching the iTunes Search API JSON structure.
struct SearchResponseDTO: Decodable {
    let resultCount: Int
    let results: [TrackDTO]
}

/// Codable mirror of the iTunes JSON track object. Maps to the `Track` domain entity via `toDomain()`.
struct TrackDTO: Decodable {
    let trackId: Int
    let trackName: String
    let artistName: String
    let collectionName: String?
    let artworkUrl100: String?
    let previewUrl: String?
    let trackTimeMillis: Int?

    func toDomain() -> Track {
        let artworkURL: URL? = artworkUrl100
            .map { $0.replacingOccurrences(of: "100x100bb", with: "300x300bb") }
            .flatMap { URL(string: $0) }

        return Track(
            id: trackId,
            title: trackName,
            artist: artistName,
            album: collectionName,
            artworkURL: artworkURL,
            previewURL: previewUrl.flatMap { URL(string: $0) },
            duration: TimeInterval(trackTimeMillis ?? 0) / 1000.0
        )
    }
}
