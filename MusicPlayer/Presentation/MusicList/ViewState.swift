//
//  ViewState.swift
//  MusicPlayer
//
//  Created by rankyranky on 02/06/26.
//

import Foundation

/// Generic state machine for UI screens. Covers idle, loading, loaded, empty, and error states.
enum ViewState<T> {
    case idle
    case loading
    case loaded(T)
    case empty
    case failed(String)
}
