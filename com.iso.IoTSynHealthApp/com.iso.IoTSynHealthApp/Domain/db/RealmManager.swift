//
//  RealManager.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 24/9/25.
//
import RealmSwift

final class RealmManager {
    static let shared = RealmManager()  // Singleton
    private init() {}  // Không cho tạo từ ngoài

    //    let a = RealmManager.shared      // OK
    //    let b = RealmManager()           // ❌ Lỗi: 'init' is inaccessible

    func saveLoginUser(_ response: LoginResponse?) {
        guard let userData = response?.data else {
            print("saveLoginUser: Không có dữ liệu user từ response.")
            return
        }

        do {
            let realm = try Realm()
            let user = LoginUser(from: userData)

            try realm.write {
                realm.add(user, update: .modified)
            }
        } catch {
            print(
                "saveLoginUser: Lỗi khi lưu user vào Realm - \(error.localizedDescription)"
            )
        }
    }

    func getCurrentUser() -> LoginUser? {
        let realm = try! Realm()
        return realm.objects(LoginUser.self).first
    }

    func logout() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(LoginUser.self))
        }
    }
}
