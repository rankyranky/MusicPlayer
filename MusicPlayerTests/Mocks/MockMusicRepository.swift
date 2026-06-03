//
//  MockMusicRepository.swift
//  MusicPlayerTests
//
//  Created by rankyranky on 02/06/26.
//

import Foundation
@testable import MusicPlayer

final class MockMusicRepository: MusicRepository {
    var tracksToReturn: [Track] = []
    var errorToThrow: Error?
    var searchCallCount = 0
    var lastSearchTerm: String?

    func searchTracks(term: String) async throws -> [Track] {
        searchCallCount += 1
        lastSearchTerm = term

        if let error = errorToThrow {
            throw error
        }
        return tracksToReturn
    }
}
