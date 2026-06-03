//
//  DIContainer.swift
//  MusicPlayer
//
//  Created by rankyranky on 02/06/26.
//

import Foundation

/// Composition root that wires all dependencies. Protocols are resolved here and injected via constructors.
final class DIContainer {
    lazy var apiClient: APIClient = DefaultAPIClient()
    lazy var musicRepository: MusicRepository = DefaultMusicRepository(apiClient: apiClient)

    func makeMusicListViewModel() -> MusicListViewModel {
        MusicListViewModel(repository: musicRepository)
    }
}
