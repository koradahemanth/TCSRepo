//
//  Mocknetworkservice.swift
//  ApplicationSampleTests
//
//  Created by Murali on 20/01/26.
//

import Foundation

@testable import ApplicationSample

final class MockNetworkService: NetworlServiceProtocal {

    var shouldThrowError = false
    var mockData: Data?

    func fetchData<T: Decodable>(endpoint: URL) async throws -> T {
        if shouldThrowError {
            throw APIError.serverError(500)
        }

        guard let data = mockData else {
            throw APIError.noData
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
