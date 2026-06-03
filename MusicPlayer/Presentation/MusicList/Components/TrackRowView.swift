//
//  TrackRowView.swift
//  MusicPlayer
//
//  Created by rankyranky on 02/06/26.
//

import SwiftUI

/// Displays a single track row with artwork, title, artist, album, and playability indicator.
struct TrackRowView: View {
    let track: Track

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: track.artworkURL) { image in
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
            .frame(width: 56, height: 56)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(track.title)
                    .font(.body)
                    .lineLimit(1)

                Text(track.artist)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                if let album = track.album {
                    Text(album)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                }
            }

            Spacer()

            if track.previewURL != nil {
                Image(systemName: "play.circle")
                    .font(.title2)
                    .foregroundStyle(.blue)
            } else {
                Text("No Preview")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
        .opacity(track.previewURL != nil ? 1.0 : 0.5)
    }
}

#Preview("With Preview URL") {
    TrackRowView(track: Track(
        id: 1,
        title: "Yellow",
        artist: "Coldplay",
        album: "Parachutes",
        artworkURL: nil,
        previewURL: URL(string: "https://example.com/preview.m4a"),
        duration: 270.0
    ))
    .padding()
}

#Preview("No Preview URL") {
    TrackRowView(track: Track(
        id: 2,
        title: "Unavailable Song",
        artist: "Unknown Artist",
        album: nil,
        artworkURL: nil,
        previewURL: nil,
        duration: 180.0
    ))
    .padding()
}
