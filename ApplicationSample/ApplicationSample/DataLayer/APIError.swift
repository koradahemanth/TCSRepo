//
//  APIError.swift
//  ApplicationSample
//
//  Created by Murali on 19/01/26.
//

import Foundation

enum APIError:Error,Equatable {
    case noData
    case invalidUrl
    case serverError(Int)
    case decodeFailure
    case networkError(String)
}
