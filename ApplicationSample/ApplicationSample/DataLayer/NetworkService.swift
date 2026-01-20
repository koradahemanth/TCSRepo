//
//  NetworkService.swift
//  ApplicationSample
//
//  Created by Murali on 19/01/26.
//

import Foundation

class NetworkService:NetworlServiceProtocal {
    
    let session:URLSession
    
    init(session:URLSession = .shared){
        self.session = session
    }
    
    func fetchData<T:Decodable>(endpoint:URL)  async throws -> T {
        
       let (data,response) = try await session.data(from: endpoint)
        
        guard let rress = response as? HTTPURLResponse else { throw APIError.noData}
        guard  (200...299).contains(rress.statusCode) else {throw APIError.serverError(rress.statusCode)}
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw APIError.decodeFailure
        }
    }
}


