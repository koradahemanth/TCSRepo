//
//  Loadingstate.swift
//  ApplicationSample
//
//  Created by Murali on 19/01/26.
//

import Foundation

enum LoadingState {
    case idle
    case loading
    case loaded([User])
    case error(String)
}
