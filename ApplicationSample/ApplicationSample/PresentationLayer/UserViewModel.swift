//
//  UserViewModel.swift
//  ApplicationSample
//
//  Created by Murali on 19/01/26.
//

import Foundation

@Observable @MainActor
final class UserViewModel: UserViewmodelProtocal{
   
    var users:[User] = []
    var loadingstatus:LoadingState = .idle
    let fetchUseCase: FetchUserUsecaseProtocal
    init(fetchUsecase:FetchUserUsecaseProtocal) {
        self.fetchUseCase = fetchUsecase
    }
    
    func loadUsers() async  {
        loadingstatus = .loading
        do {
            self.users  =  try await self.fetchUseCase.execute()
             loadingstatus = .loaded(self.users)
        }
        catch {
            loadingstatus = .error("Failed to load from the server")
        }
    }
}
