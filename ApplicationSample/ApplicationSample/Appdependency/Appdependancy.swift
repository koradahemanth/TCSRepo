//
//  Appdependancy.swift
//  ApplicationSample
//
//  Created by Murali on 19/01/26.
//

import Foundation

class AppDependency {
    
    let networkService: NetworlServiceProtocal
    let userRepositroy: UserRepositoryProtocal
    let fetchUserUseCase: FetchUserUsecaseProtocal
    
    init(networkService: NetworlServiceProtocal, userRepositroy: UserRepositoryProtocal, fecthUserUseCase: FetchUserUsecaseProtocal) {
        self.networkService = networkService
        self.userRepositroy = userRepositroy
        self.fetchUserUseCase = fecthUserUseCase
    }
    
    @MainActor func makeVM() -> UserViewModel{
        return UserViewModel(fetchUsecase: self.fetchUserUseCase)
    }
}
