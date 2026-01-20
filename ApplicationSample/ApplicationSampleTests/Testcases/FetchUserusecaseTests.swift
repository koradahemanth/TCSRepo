//
//  FetchUserusecaseTests.swift
//  ApplicationSampleTests
//
//  Created by Murali on 20/01/26.
//

import Foundation

import XCTest
@testable import ApplicationSample

final class FetchUserUseCaseTests: XCTestCase {

    func test_execute_returnsUsers() async throws {
        // Given
        let mockRepo = MockUserRepository()
        mockRepo.users = [
            User(name: "Alice", id: 1, email: "alice@test.com")
        ]

        let useCase = FetchUserUseCase(userRepository: mockRepo)

        // When
        let users = try await useCase.execute()

        // Then
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.name, "Alice")
    }
}
