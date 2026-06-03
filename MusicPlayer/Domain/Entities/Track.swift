//
//  Track.swift
//  MusicPlayer
//
//  Created by rankyranky on 01/06/26.
//

import Foundation

/// Domain entity representing a music track. Pure value type with no framework dependencies.
struct Track: Identifiable, Equatable {
    
    let id: Int
    let title: String
    let artist: String
    let album: String?
    let artworkURL: URL?
    let previewURL: URL?
    let duration: TimeInterval
}
