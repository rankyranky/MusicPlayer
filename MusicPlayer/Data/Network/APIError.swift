//
//  APIError.swift
//  MusicPlayer
//
//  Created by rankyranky on 02/06/26.
//

import Foundation

/// Typed errors for network operations, wrapping Alamofire and decoding failures.
enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case unknown
}
