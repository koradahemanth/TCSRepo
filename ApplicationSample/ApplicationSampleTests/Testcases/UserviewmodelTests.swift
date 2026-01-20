//
//  UserviewmodelTests.swift
//  ApplicationSampleTests
//
//  Created by Murali on 20/01/26.
//

import Foundation

import XCTest
@testable import ApplicationSample

final class UserViewModelTests: XCTestCase {
    @MainActor
    func test_loadUsers_success() async {
        // Given
        let mockRepo = MockUserRepository()
        mockRepo.users = [
            User(name: "Bob", id: 1, email: "bob@test.com")
        ]

        let useCase = FetchUserUseCase(userRepository: mockRepo)
        let viewModel = UserViewModel(fetchUsecase: useCase)

        // When
        await viewModel.loadUsers()

        // Then
        XCTAssertEqual(viewModel.users.count, 1)
    }
    
    
    @MainActor
    func test_loadUsers_failure() async {
        // Given
        let mockRepo = MockUserRepository()
        mockRepo.shouldFail = true

        let useCase = FetchUserUseCase(userRepository: mockRepo)
        let viewModel = UserViewModel(fetchUsecase: useCase)

        // When
        await viewModel.loadUsers()

        // Then
       // XCTAssertEqual(viewModel.loadingState, .error)
    }
}

