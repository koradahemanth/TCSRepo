//
//  UserRepositorytests.swift
//  ApplicationSampleTests
//
//  Created by Murali on 20/01/26.
//

import Foundation

import XCTest
@testable import ApplicationSample

final class UserRepositoryTests: XCTestCase {

    func test_fetchUsers_success() async throws {
        // Given
        let mockService = MockNetworkService()
        let repository = UserRepository(networkSerivice: mockService)

        let json = """
        [
            {
                "id": 1,
                "name": "John",
                "email": "john@test.com"
            }
        ]
        """
        mockService.mockData = Data(json.utf8)

        // When
        let users = try await repository.fetchUsers()

        // Then
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.name, "John")
    }

    func test_fetchUsers_failure() async {
        // Given
        let mockService = MockNetworkService()
        mockService.shouldThrowError = true
        let repository = UserRepository(networkSerivice: mockService)

        
        // When / Then
           do {
               _ = try await repository.fetchUsers()
               XCTFail("Expected fetchUsers() to throw an error")
           } catch {
               XCTAssertTrue(true) // Error was thrown as expected
           }
    }
}
