//
//  NetworkServiceProtocal.swift
//  ApplicationSample
//
//  Created by Murali on 19/01/26.
//

import Foundation

protocol NetworlServiceProtocal {
    func fetchData<T:Decodable>(endpoint:URL) async throws -> T
}
