//
//  APIClient.swift
//  MusicPlayer
//
//  Created by rankyranky on 02/06/26.
//


import Foundation
import Alamofire

/// Abstraction for performing network requests. Allows mocking in tests.
protocol APIClient {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
}

/// Concrete API client that uses Alamofire for HTTP networking and JSON decoding.
final class DefaultAPIClient: APIClient {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }

        do {
            return try await AF.request(url)
                .serializingDecodable(T.self)
                .value
        } catch let error as AFError {
            throw APIError.networkError(error)
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch {
            throw APIError.unknown
        }
    }
}
