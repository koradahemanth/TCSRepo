//
//  ContentView.swift
//  ApplicationSample
//
//  Created by Murali on 19/01/26.
//

import SwiftUI

struct ContentView: View {
    
  @State private var viewmodelInstance:UserViewModel
    
    //@StateObject private var viewmodelInstance: UserViewModel

    init(userViewModel: UserViewModel) {
        self.viewmodelInstance = userViewModel
    }
    
//    init(userViewModel: UserViewModel) {
//        _viewmodelInstance = StateObject(wrappedValue: userViewModel)
//    }
    
    var body: some View {
        VStack {
            switch(viewmodelInstance.loadingstatus) {
            case .idle:
                Text("User data will be loading")
            case .loading:
                Text("data loading")
            case .loaded(let users):
                VStack {
                    List(users) { user in
                        Text(user.name)
                    }
                }
            case .error(let errorMessage):
                Text("Failed with the error: \(errorMessage)")
            }
        }
        .task {
            
        }
    }
}

//#Preview {
//    ContentView(userViewModel: <#UserViewModel#>)
//}
