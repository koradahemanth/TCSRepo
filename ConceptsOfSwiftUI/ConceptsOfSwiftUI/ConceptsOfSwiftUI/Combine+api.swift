//
//  Combine+api.swift
//  ConceptsOfSwiftUI
//
//  Created by Murali on 16/01/26.
//

import Foundation

//Step 1: API Service
struct User: Decodable {
    let id: Int
    let name: String
}

protocol UserServiceProtocol {
    func fetchUser() -> AnyPublisher<User, Error>
}


final class UserService: UserServiceProtocol {

    func fetchUser() -> AnyPublisher<User, Error> {
        let url = URL(string: "https://api.example.com/user")!

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: User.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

final class ProfileViewModel {

    @Published private(set) var user: User?
    @Published private(set) var errorMessage: String?

    private let service: UserServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(service: UserServiceProtocol) {
        self.service = service
    }

    func loadUser() {
        service.fetchUser()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure = completion {
                        self?.errorMessage = "Failed to load user"
                    }
                },
                receiveValue: { [weak self] user in
                    self?.user = user
                }
            )
            .store(in: &cancellables)
    }
}


//Viewmodel binding.
viewModel.$user
    .compactMap { $0 }
    .sink { [weak self] user in
        self?.nameLabel.text = user.name
    }
    .store(in: &cancellables)


