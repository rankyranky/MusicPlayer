//
//  SearchBarView.swift
//  MusicPlayer
//
//  Created by rankyranky on 02/06/26.
//

import SwiftUI

/// Search input field with clear button. Triggers search on submit or button tap.
struct SearchBarView: View {
    @Binding var text: String
    var onSearch: () -> Void

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)

                TextField("Search songs...", text: $text)
                    .textFieldStyle(.plain)
                    .autocorrectionDisabled()
                    .onSubmit {
                        onSearch()
                    }

                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(8)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Button("Search") {
                onSearch()
            }
            .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal)
    }
}

#Preview("Empty") {
    SearchBarView(text: .constant(""), onSearch: {})
}

#Preview("With Text") {
    SearchBarView(text: .constant("Coldplay"), onSearch: {})
}
