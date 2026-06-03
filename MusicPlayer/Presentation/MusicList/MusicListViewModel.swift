//
//  MusicListViewModel.swift
//  MusicPlayer
//
//  Created by rankyranky on 02/06/26.
//

import SwiftUI
import Combine

/// ViewModel for the music search screen. Manages search state, track selection, and playback navigation.
@MainActor
final class MusicListViewModel: ObservableObject {
    @Published private(set) var state: ViewState<[Track]> = .idle
    @Published var query: String = ""
    @Published private(set) var currentTrack: Track?

    let playerService = PlayerService()
    private let repository: MusicRepository
    private var tracks: [Track] = []

    init(repository: MusicRepository) {
        self.repository = repository
    }

    func search() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        state = .loading

        do {
            let tracks = try await repository.searchTracks(term: trimmed)
            self.tracks = tracks
            state = tracks.isEmpty ? .empty : .loaded(tracks)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    func selectTrack(_ track: Track) {
        guard let url = track.previewURL else { return }
        currentTrack = track
        playerService.play(url: url)
    }

    func playNext() {
        guard let current = currentTrack,
              let index = tracks.firstIndex(where: { $0.id == current.id }),
              index + 1 < tracks.count else { return }
        selectTrack(tracks[index + 1])
    }

    func playPrevious() {
        guard let current = currentTrack,
              let index = tracks.firstIndex(where: { $0.id == current.id }),
              index - 1 >= 0 else { return }
        selectTrack(tracks[index - 1])
    }
}
