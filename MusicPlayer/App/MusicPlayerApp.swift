//
//  MusicPlayerApp.swift
//  MusicPlayer
//
//  Created by rankyranky on 01/06/26.
//

import SwiftUI

/// App entry point. Creates the `DIContainer` and injects the root view with its dependencies.
@main
struct MusicPlayerApp: App {
    private let container = DIContainer()

    var body: some Scene {
        WindowGroup {
            MusicListView(viewModel: container.makeMusicListViewModel())
        }
    }
}
