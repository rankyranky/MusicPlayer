//
//  PlayerBarView.swift
//  MusicPlayer
//
//  Created by rankyranky on 02/06/26.
//

import SwiftUI

/// Bottom bar with track info, playback controls (prev/play-pause/next), and a seek slider with time labels.
struct PlayerBarView: View {
    @ObservedObject var playerService: PlayerService
    let currentTrack: Track
    var onPrevious: () -> Void
    var onNext: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Divider()

            HStack(spacing: 12) {
                AsyncImage(url: currentTrack.artworkURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.3)
                        .overlay(
                            Image(systemName: "music.note")
                                .foregroundStyle(.gray)
                        )
                }
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 6))

                VStack(alignment: .leading, spacing: 2) {
                    Text(currentTrack.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(1)

                    Text(currentTrack.artist)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                HStack(spacing: 20) {
                    Button { onPrevious() } label: {
                        Image(systemName: "backward.fill")
                            .font(.title3)
                    }

                    Button { playerService.togglePlayPause() } label: {
                        Image(systemName: playerService.isPlaying ? "pause.fill" : "play.fill")
                            .font(.title2)
                    }

                    Button { onNext() } label: {
                        Image(systemName: "forward.fill")
                            .font(.title3)
                    }
                }
                .foregroundStyle(.primary)
            }
            .padding(.horizontal)

            HStack(spacing: 8) {
                Text(formatTime(playerService.currentTime))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()

                Slider(
                    value: Binding(
                        get: { playerService.currentTime },
                        set: { playerService.seek(to: $0) }
                    ),
                    in: 0...max(playerService.duration, 1)
                )

                Text(formatTime(playerService.duration))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .background(.ultraThinMaterial)
    }

    private func formatTime(_ seconds: TimeInterval) -> String {
        guard seconds.isFinite && seconds >= 0 else { return "0:00" }
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%d:%02d", mins, secs)
    }
}

#Preview {
    PlayerBarView(
        playerService: PlayerService(),
        currentTrack: Track(
            id: 1,
            title: "Yellow",
            artist: "Coldplay",
            album: "Parachutes",
            artworkURL: nil,
            previewURL: URL(string: "https://example.com/preview.m4a"),
            duration: 30.0
        ),
        onPrevious: {},
        onNext: {}
    )
}
