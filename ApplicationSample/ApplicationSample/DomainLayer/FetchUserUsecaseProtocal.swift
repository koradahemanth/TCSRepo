//
//  FetchUserUsecaseProtocal.swift
//  ApplicationSample
//
//  Created by Murali on 19/01/26.
//

import Foundation

protocol FetchUserUsecaseProtocal {
    
    func execute() async throws -> [User]
}
