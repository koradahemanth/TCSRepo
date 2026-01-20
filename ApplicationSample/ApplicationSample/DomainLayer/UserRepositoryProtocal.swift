//
//  UserRepositoryProtocal.swift
//  ApplicationSample
//
//  Created by Murali on 19/01/26.
//

import Foundation


protocol UserRepositoryProtocal{
    func fetchUsers() async throws  -> [User]
}
