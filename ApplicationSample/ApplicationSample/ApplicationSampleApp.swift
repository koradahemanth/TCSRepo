//
//  ApplicationSampleApp.swift
//  ApplicationSample
//
//  Created by Murali on 19/01/26.
//

import SwiftUI

@main
struct ApplicationSampleApp: App {
    
   private let networkService:NetworlServiceProtocal
   private let userREspository:UserRepositoryProtocal
   private let useCase:FetchUserUsecaseProtocal
   private let appDependancy:AppDependency
    
    init(){
        let networkService = NetworkService()
        let useRepository = UserRepository(networkSerivice: networkService)
        let usecaseRepo = FetchUserUseCase(userRepository: useRepository)
        
        self.networkService = networkService
        self.userREspository = useRepository
        self.useCase = usecaseRepo
        
        self.appDependancy = AppDependency(networkService: self.networkService, userRepositroy: self.userREspository, fecthUserUseCase: self.useCase)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(userViewModel: self.appDependancy.makeVM())
        }
    }
}
