//
//  TrackDTOMappingTests.swift
//  MusicPlayerTests
//
//  Created by rankyranky on 02/06/26.
//

import Testing
import Foundation
@testable import MusicPlayer

@MainActor
struct TrackDTOMappingTests {

    // MARK: - Full DTO Mapping

    @Test func toDomain_mapsAllFields() {
        let dto = TrackDTO(
            trackId: 123,
            trackName: "Yellow",
            artistName: "Coldplay",
            collectionName: "Parachutes",
            artworkUrl100: "https://example.com/100x100bb.jpg",
            previewUrl: "https://example.com/preview.m4a",
            trackTimeMillis: 270000
        )

        let track = dto.toDomain()

        #expect(track.id == 123)
        #expect(track.title == "Yellow")
        #expect(track.artist == "Coldplay")
        #expect(track.album == "Parachutes")
        #expect(track.previewURL?.absoluteString == "https://example.com/preview.m4a")
        #expect(track.duration == 270.0)
    }

    // MARK: - Artwork URL Rewrite

    @Test func toDomain_rewritesArtworkTo300px() {
        let dto = TrackDTO(
            trackId: 1,
            trackName: "Song",
            artistName: "Artist",
            collectionName: nil,
            artworkUrl100: "https://is1-ssl.mzstatic.com/image/thumb/Music/100x100bb.jpg",
            previewUrl: nil,
            trackTimeMillis: nil
        )

        let track = dto.toDomain()

        #expect(track.artworkURL?.absoluteString.contains("300x300bb") == true)
        #expect(track.artworkURL?.absoluteString.contains("100x100bb") == false)
    }

    // MARK: - Optional Fields

    @Test func toDomain_handlesNilCollectionName() {
        let dto = TrackDTO(
            trackId: 1,
            trackName: "Song",
            artistName: "Artist",
            collectionName: nil,
            artworkUrl100: nil,
            previewUrl: nil,
            trackTimeMillis: nil
        )

        let track = dto.toDomain()

        #expect(track.album == nil)
        #expect(track.artworkURL == nil)
        #expect(track.previewURL == nil)
    }

    // MARK: - Duration Conversion

    @Test func toDomain_convertsMillisToSeconds() {
        let dto = TrackDTO(
            trackId: 1,
            trackName: "Song",
            artistName: "Artist",
            collectionName: nil,
            artworkUrl100: nil,
            previewUrl: nil,
            trackTimeMillis: 215000
        )

        let track = dto.toDomain()

        #expect(track.duration == 215.0)
    }

    @Test func toDomain_handlesNilDuration() {
        let dto = TrackDTO(
            trackId: 1,
            trackName: "Song",
            artistName: "Artist",
            collectionName: nil,
            artworkUrl100: nil,
            previewUrl: nil,
            trackTimeMillis: nil
        )

        let track = dto.toDomain()

        #expect(track.duration == 0.0)
    }

    // MARK: - JSON Decoding

    @Test func decodesFromJSON() throws {
        let json = """
        {
            "resultCount": 1,
            "results": [
                {
                    "trackId": 456,
                    "trackName": "Fix You",
                    "artistName": "Coldplay",
                    "collectionName": "X&Y",
                    "artworkUrl100": "https://example.com/100x100bb.jpg",
                    "previewUrl": "https://example.com/preview.m4a",
                    "trackTimeMillis": 295000
                }
            ]
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(SearchResponseDTO.self, from: json)

        #expect(response.resultCount == 1)
        #expect(response.results.count == 1)
        #expect(response.results[0].trackName == "Fix You")
    }
}
