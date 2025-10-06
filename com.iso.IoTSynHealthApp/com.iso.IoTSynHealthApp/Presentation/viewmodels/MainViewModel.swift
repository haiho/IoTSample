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

    @Published var user: UserInfo?
    @Published var hdsSettings: [HDSSetting] = []
    
    var lastSynHDS: Date? = nil

    init() {
        fetchUser()
        fetchHDSSettings()
    }

    func fetchUser() {
        do {
            let realm = try Realm()
            user = realm.objects(UserInfo.self).first
            lastSynHDS = user?.lastSynHDSDate

            print("Realm user: \(String(describing: user))")
        } catch {
            print("Realm error: \(error)")
            user = nil
        }
    }
    
    func fetchHDSSettings() {
         do {
             let realm = try Realm()
             let results = realm.objects(HDSSetting.self)
             hdsSettings = Array(results)
             
             print("Fetched HDSSettings: \(hdsSettings)")
         } catch {
             print("Realm error (HDSSetting): \(error)")
             hdsSettings = []
         }
     }
}
