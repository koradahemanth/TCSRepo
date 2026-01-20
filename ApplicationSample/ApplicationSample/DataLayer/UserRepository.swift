//
//  UserRepository.swift
//  ApplicationSample
//
//  Created by Murali on 19/01/26.
//

import Foundation

class UserRepository:UserRepositoryProtocal {
    
    private let networkService:NetworlServiceProtocal
    init(networkSerivice:NetworlServiceProtocal) {
        self.networkService = networkSerivice
    }
    
    func fetchUsers() async throws -> [User]{
        
        guard let url = EndPoint.users.url else { throw APIError.invalidUrl }
        
        return try await self.networkService.fetchData(endpoint: url)
            
            
    }
}
