//
//  MockUserRepository.swift
//  ApplicationSampleTests
//
//  Created by Murali on 20/01/26.
//

import Foundation

@testable import ApplicationSample

final class MockUserRepository: UserRepositoryProtocal {

    var users: [User] = []
    var shouldFail = false

    func fetchUsers() async throws -> [User] {
        if shouldFail {
            throw APIError.noData
        }
        return users
    }
}

