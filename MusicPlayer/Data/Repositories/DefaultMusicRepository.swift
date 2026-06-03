//
//  DefaultMusicRepository.swift
//  MusicPlayer
//
//  Created by rankyranky on 02/06/26.
//


import Foundation

/// Concrete implementation of `MusicRepository`. Fetches data via `APIClient` and maps DTOs to domain entities.
final class DefaultMusicRepository: MusicRepository {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func searchTracks(term: String) async throws -> [Track] {
        let response: SearchResponseDTO = try await apiClient.request(
            .searchMusic(term: term)
        )
        return response.results.map { $0.toDomain() }
    }
}
