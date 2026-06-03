//
//  MusicRepository.swift
//  MusicPlayer
//
//  Created by rankyranky on 01/06/26.
//

import Foundation

/// Defines the contract for fetching music tracks. Implemented by Data layer, consumed by Presentation layer.
protocol MusicRepository {
    func searchTracks(term: String) async throws -> [Track]
}
