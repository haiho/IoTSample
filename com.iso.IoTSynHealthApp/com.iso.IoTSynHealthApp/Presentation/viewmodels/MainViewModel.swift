//
//  LandingViewModel.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 19/9/25.
//

import RealmSwift
import SwiftUI

@MainActor
class MainViewModel: ObservableObject {

    @Published var user: LoginUser?

    init() {
        fetchUser()
    }

    func fetchUser() {
        do {
            let realm = try Realm()
            user = realm.objects(LoginUser.self).first
            print("Realm user: \(user)")
        } catch {
            print("Realm error: \(error)")
            user = nil
        }
    }
}
