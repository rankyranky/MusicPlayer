//
//  MockAPIClient.swift
//  MusicPlayerTests
//
//  Created by rankyranky on 02/06/26.
//

import Foundation
@testable import MusicPlayer

final class MockAPIClient: APIClient {
    var dataToReturn: Any?
    var errorToThrow: Error?

    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        if let error = errorToThrow {
            throw error
        }
        guard let data = dataToReturn as? T else {
            throw APIError.unknown
        }
        return data
    }
}
