//
//  MusicRepositoryTests.swift
//  MusicPlayerTests
//
//  Created by rankyranky on 02/06/26.
//

import Testing
import Foundation
@testable import MusicPlayer

@MainActor
struct MusicRepositoryTests {

    // MARK: - Success

    @Test func searchTracks_returnsMappedTracks() async throws {
        let mockClient = MockAPIClient()
        let dto = SearchResponseDTO(
            resultCount: 2,
            results: [
                TrackDTO(
                    trackId: 1,
                    trackName: "Song A",
                    artistName: "Artist A",
                    collectionName: "Album A",
                    artworkUrl100: "https://example.com/100x100bb.jpg",
                    previewUrl: "https://example.com/a.m4a",
                    trackTimeMillis: 180000
                ),
                TrackDTO(
                    trackId: 2,
                    trackName: "Song B",
                    artistName: "Artist B",
                    collectionName: nil,
                    artworkUrl100: nil,
                    previewUrl: nil,
                    trackTimeMillis: 200000
                )
            ]
        )
        mockClient.dataToReturn = dto

        let repository = DefaultMusicRepository(apiClient: mockClient)
        let tracks = try await repository.searchTracks(term: "test")

        #expect(tracks.count == 2)
        #expect(tracks[0].title == "Song A")
        #expect(tracks[0].artist == "Artist A")
        #expect(tracks[1].album == nil)
        #expect(tracks[1].previewURL == nil)
    }

    // MARK: - API Error

    @Test func searchTracks_throwsOnAPIError() async {
        let mockClient = MockAPIClient()
        mockClient.errorToThrow = APIError.networkError(NSError(domain: "test", code: -1))

        let repository = DefaultMusicRepository(apiClient: mockClient)

        do {
            _ = try await repository.searchTracks(term: "test")
            Issue.record("Expected error to be thrown")
        } catch {
            #expect(error is APIError)
        }
    }

    // MARK: - Empty Results

    @Test func searchTracks_returnsEmptyForNoResults() async throws {
        let mockClient = MockAPIClient()
        mockClient.dataToReturn = SearchResponseDTO(resultCount: 0, results: [])

        let repository = DefaultMusicRepository(apiClient: mockClient)
        let tracks = try await repository.searchTracks(term: "xyznonexistent")

        #expect(tracks.isEmpty)
    }
}
