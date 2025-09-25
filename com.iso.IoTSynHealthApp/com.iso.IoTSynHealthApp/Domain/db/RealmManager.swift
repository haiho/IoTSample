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

    func saveLoginUser(_ response: LoginResponse) {
        let realm = try! Realm()
        let user = LoginUser(from: response)

        try! realm.write {
            realm.add(user, update: .modified)  // Cập nhật nếu đã tồn tại
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
