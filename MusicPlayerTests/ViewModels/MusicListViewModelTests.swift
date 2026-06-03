//
//  MusicListViewModelTests.swift
//  MusicPlayerTests
//
//  Created by rankyranky on 02/06/26.
//

import Testing
import Foundation
@testable import MusicPlayer

@MainActor
struct MusicListViewModelTests {

    private func makeSUT(repository: MockMusicRepository = MockMusicRepository()) -> (MusicListViewModel, MockMusicRepository) {
        let viewModel = MusicListViewModel(repository: repository)
        return (viewModel, repository)
    }

    private func makeTracks(count: Int) -> [Track] {
        (0..<count).map { i in
            Track(
                id: i,
                title: "Track \(i)",
                artist: "Artist \(i)",
                album: "Album \(i)",
                artworkURL: URL(string: "https://example.com/art\(i).jpg"),
                previewURL: URL(string: "https://example.com/preview\(i).m4a"),
                duration: 30.0
            )
        }
    }

    // MARK: - Search Success

    @Test func searchWithResults_setsLoadedState() async {
        let (sut, mock) = makeSUT()
        mock.tracksToReturn = makeTracks(count: 3)
        sut.query = "Coldplay"

        await sut.search()

        guard case .loaded(let tracks) = sut.state else {
            Issue.record("Expected .loaded state, got \(sut.state)")
            return
        }
        #expect(tracks.count == 3)
        #expect(mock.lastSearchTerm == "Coldplay")
    }

    // MARK: - Search Empty

    @Test func searchWithNoResults_setsEmptyState() async {
        let (sut, mock) = makeSUT()
        mock.tracksToReturn = []
        sut.query = "xyznonexistent"

        await sut.search()

        guard case .empty = sut.state else {
            Issue.record("Expected .empty state, got \(sut.state)")
            return
        }
    }

    // MARK: - Search Failure

    @Test func searchWithError_setsFailedState() async {
        let (sut, mock) = makeSUT()
        mock.errorToThrow = APIError.unknown
        sut.query = "test"

        await sut.search()

        guard case .failed = sut.state else {
            Issue.record("Expected .failed state, got \(sut.state)")
            return
        }
    }

    // MARK: - Empty Query

    @Test func searchWithEmptyQuery_doesNotCallRepository() async {
        let (sut, mock) = makeSUT()
        sut.query = "   "

        await sut.search()

        #expect(mock.searchCallCount == 0)
        guard case .idle = sut.state else {
            Issue.record("Expected .idle state, got \(sut.state)")
            return
        }
    }

    // MARK: - Track Selection

    @Test func selectTrack_setsCurrentTrack() {
        let (sut, _) = makeSUT()
        let track = makeTracks(count: 1)[0]

        sut.selectTrack(track)

        #expect(sut.currentTrack == track)
    }

    @Test func selectTrackWithNoPreview_doesNotSetCurrentTrack() {
        let (sut, _) = makeSUT()
        let track = Track(
            id: 1,
            title: "No Preview",
            artist: "Artist",
            album: nil,
            artworkURL: nil,
            previewURL: nil,
            duration: 30.0
        )

        sut.selectTrack(track)

        #expect(sut.currentTrack == nil)
    }
}
