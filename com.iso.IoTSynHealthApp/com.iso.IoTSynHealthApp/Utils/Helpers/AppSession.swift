//
//  AppSession.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 20/8/25.
//
import SwiftUI
//
//class AppSession: ObservableObject {
//    static let shared = AppSession()
//
//    @AppStorage("isLoggedIn") private var isLoggedInStorage = false {
//        didSet {
//            self.isLoggedIn = isLoggedInStorage
//        }
//    }
//
//    @Published var isLoggedIn: Bool = false
//
//    private init() {
//        self.isLoggedIn = isLoggedInStorage
//    }
//
//    func login() {
//        isLoggedInStorage = true
//    }
//
//    func logout() {
//        isLoggedInStorage = false
//    }
//}

class AppSession: ObservableObject {
    static let shared = AppSession()

    @Published var isLoggedIn: Bool = false

    private init() {
        self.isLoggedIn = UserDefaultsManager.shared.isLoggedIn
    }

    func login(token: String) {
        UserDefaultsManager.shared.authToken = token
        isLoggedIn = true
    }

    func logout() {
        UserDefaultsManager.shared.clearAll()
        isLoggedIn = false
    }
}
