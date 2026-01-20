//
//  FetchUserUseCase.swift
//  ApplicationSample
//
//  Created by Murali on 19/01/26.
//

import Foundation

class FetchUserUseCase:FetchUserUsecaseProtocal {
    
   private let userRepository:UserRepositoryProtocal
    
    init(userRepository:UserRepositoryProtocal){
        self.userRepository = userRepository
    }
    
    func execute() async throws -> [User] {
        return try await userRepository.fetchUsers()
    }
}

