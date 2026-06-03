//
//  MusicListView.swift
//  MusicPlayer
//
//  Created by rankyranky on 02/06/26.
//

import SwiftUI

/// Main screen that displays search bar, track list, and player bar. Switches UI based on `ViewState`.
struct MusicListView: View {
    @StateObject var viewModel: MusicListViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBarView(text: $viewModel.query) {
                    Task {
                        await viewModel.search()
                    }
                }
                .padding(.vertical, 8)

                contentView
            }
            .navigationTitle("Music Player")
            .safeAreaInset(edge: .bottom) {
                if let track = viewModel.currentTrack {
                    PlayerBarView(
                        playerService: viewModel.playerService,
                        currentTrack: track,
                        onPrevious: { viewModel.playPrevious() },
                        onNext: { viewModel.playNext() }
                    )
                }
            }
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .idle:
            ContentUnavailableView(
                "Search for Music",
                systemImage: "music.magnifyingglass",
                description: Text("Find your favorite songs from iTunes")
            )

        case .loading:
            Spacer()
            ProgressView("Searching...")
            Spacer()

        case .loaded(let tracks):
            List(tracks) { track in
                TrackRowView(track: track)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.selectTrack(track)
                    }
            }
            .listStyle(.plain)

        case .empty:
            ContentUnavailableView(
                "No Results",
                systemImage: "magnifyingglass",
                description: Text("Try a different search term")
            )

        case .failed(let message):
            ContentUnavailableView(
                "Something Went Wrong",
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )
        }
    }
}

#Preview {
    let container = DIContainer()
    MusicListView(viewModel: container.makeMusicListViewModel())
}
