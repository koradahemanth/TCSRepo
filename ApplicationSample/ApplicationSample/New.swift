//
//@main
//struct ApplicationSampleApp: App {
//    
//   private let networkService:NetworlServiceProtocal
//   private let userREspository:UserRepositoryProtocal
//   private let useCase:FetchUserUsecaseProtocal
//   private let appDependancy:AppDependency
//    
//    init(){
//        let networkService = NetworkService()
//        let useRepository = UserRepository(networkSerivice: networkService)
//        let usecaseRepo = FetchUserUseCase(userRepository: useRepository)
//        
//        self.networkService = networkService
//        self.userREspository = useRepository
//        self.useCase = usecaseRepo
//        
//        self.appDependancy = AppDependency(networkService: self.networkService, userRepositroy: self.userREspository, fecthUserUseCase: self.useCase)
//    }
//    
//    var body: some Scene {
//        WindowGroup {
//            ContentView(userViewModel: self.appDependancy.makeVM())
//        }
//    }
//}
//
//struct ContentView: View {
//    
//    @State private var viewmodelInstance:UserViewModel
//    
//    init(userViewModel: UserViewModel) {
//        self.viewmodelInstance = userViewModel
//    }
//    
//    var body: some View {
//        VStack {
//            switch(viewmodelInstance.loadingstatus) {
//            case .idle:
//                Text("User data will be loading")
//            case .loading:
//                Text("data loading")
//            case .loaded(let users):
//                VStack {
//                    List(users) { user in
//                        Text(user.name)
//                    }
//                }
//            case .error(let errorMessage):
//                Text("Failed with the error: \(errorMessage)")
//            }
//        }
//    }
//}
//
//
//import Foundation
//
//class AppDependency {
//    
//    let networkService: NetworlServiceProtocal
//    let userRepositroy: UserRepositoryProtocal
//    let fetchUserUseCase: FetchUserUsecaseProtocal
//    
//    init(networkService: NetworlServiceProtocal, userRepositroy: UserRepositoryProtocal, fecthUserUseCase: FetchUserUsecaseProtocal) {
//        self.networkService = networkService
//        self.userRepositroy = userRepositroy
//        self.fetchUserUseCase = fecthUserUseCase
//    }
//    
//    @MainActor func makeVM() -> UserViewModel{
//        return UserViewModel(fetchUsecase: self.fetchUserUseCase)
//    }
//}
//
//
//
//protocol UserRepositoryProtocal{
//    func fetchUsers() async throws  -> [User]
//}
//
//struct User:Codable,Identifiable {
//    var name:String
//    var id:String
//    var email:String
//}
//
//class FetchUserUseCase:FetchUserUsecaseProtocal {
//    
//    let userRepository:UserRepository
//    init(userRepository:UserRepository){
//        self.userRepository = userRepository
//    }
//    
//    func execute() async throws -> [User] {
//        return try await userRepository.fetchUsers()
//    }
//}
//
//protocol FetchUserUsecaseProtocal {
//    
//    func execute() async throws -> [User]
//}
//
//@Observable @MainActor
//final class UserViewModel: UserViewmodelProtocal{
//   
//    var users:[User] = []
//    var loadingstatus:LoadingState = .idle
//    let fetchUseCase: FetchUserUsecaseProtocal
//    init(fetchUsecase:FetchUserUsecaseProtocal) {
//        self.fetchUseCase = fetchUsecase
//    }
//    
//    func loadUsers() async  {
//        loadingstatus = .loading
//        do {
//            self.users  =  try await self.fetchUseCase.execute()
//             loadingstatus = .loaded(self.users)
//        }
//        catch {
//            loadingstatus = .error("Failed to load from the server")
//        }
//    }
//}
//
//protocol UserViewmodelProtocal {
//    
//    func loadUsers() async
//}
//
//
//
//enum EndPoint {
//    static let baseURL = "https://jsonplaceholder.typicode.com"
//    case users
//    
//    var url:URL? {
//        return URL(string: EndPoint.baseURL + self.path)
//    }
//    
//    private var path: String {
//        switch self {
//        case .users:
//            return "/users"
//        }
//    }
//}
//
//enum APIError:Error,Equatable {
//    case noData
//    case invalidUrl
//    case serverError(Int)
//    case decodeFailure
//    case networkError(String)
//}
//
//protocol NetworlServiceProtocal {
//    func fetchData<T:Decodable>(endpoint:URL) async throws -> T
//}
//
//class NetworkService:NetworlServiceProtocal {
//    
//    let session:URLSession
//    
//    init(session:URLSession = .shared){
//        self.session = session
//    }
//    
//    func fetchData<T:Decodable>(endpoint:URL)  async throws -> T {
//        
//       let (data,response) = try await session.data(from: endpoint)
//        
//        guard let rress = response as? HTTPURLResponse else { throw APIError.noData}
//        guard  (200...299).contains(rress.statusCode) else {throw APIError.serverError(rress.statusCode)}
//        
//        do {
//            let decoder = try JSONDecoder().decode(T.self, from: data)
//            return decoder
//        } catch {
//            throw APIError.decodeFailure
//        }
//    }
//}
//
//class UserRepository:UserRepositoryProtocal {
//    
//    private let networkService:NetworkService
//    init(networkSerivice:NetworkService) {
//        self.networkService = networkSerivice
//    }
//    
//    func fetchUsers() async throws -> [User]{
//        
//        guard let url = EndPoint.users.url else { throw APIError.invalidUrl }
//        
//        return try await self.networkService.fetchData(endpoint: url)
//            
//            
//    }
//}
