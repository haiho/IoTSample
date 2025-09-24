import SwiftUI

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard

    // MARK: - Keys
    private enum Keys {
        static let username = "username"
        static let authToken = "auth_token"
    }

    // MARK: - Properties

    var username: String? {
        get { defaults.string(forKey: Keys.username) }
        set { defaults.set(newValue, forKey: Keys.username) }
    }

    var authToken: String? {
        get { defaults.string(forKey: Keys.authToken) }
        set {
            if let token = newValue {
                defaults.set(token, forKey: Keys.authToken)
            } else {
                defaults.removeObject(forKey: Keys.authToken)
            }
        }
    }

    /// Computed: Xác định người dùng đã đăng nhập chưa
    var isLoggedIn: Bool {
        return authToken != nil && !(authToken?.isEmpty ?? true)
    }

    // MARK: - Helpers

    func clearAll() {
        defaults.removeObject(forKey: Keys.username)
        defaults.removeObject(forKey: Keys.authToken)
    }
}

