# IoTSample
// Token set/get by - UserDefaultsManager
// Navigate from loginview and MainView by AppSession
class AppSession: ObservableObject { 
    static let shared = AppSession()

    @AppStorage("isLoggedIn") private var isLoggedInStorage = false {
        didSet {
            self.isLoggedIn = isLoggedInStorage
        }
    }

    @Published var isLoggedIn: Bool = false

    private init() {
        self.isLoggedIn = isLoggedInStorage
    }

    func login() {
        isLoggedInStorage = true
    }

    func logout() {
        isLoggedInStorage = false
    }
}
