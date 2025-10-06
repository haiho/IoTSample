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
        saveUserInfo(response!.data!)
        saveHDSSettings(response!.hdsSettings)
    }

    func saveUserInfo(_ userData: UserLoginResponse) {
        do {
            let realm = try Realm()
            let user = UserInfo(from: userData)

            try realm.write {
                realm.add(user, update: .modified)
            }
        } catch {
            print(
                "saveLoginUser: Lỗi khi lưu user vào Realm - \(error.localizedDescription)"
            )
        }
    }

    func saveHDSSettings(_ settings: [HDSSetting]?) {
        guard let settings = settings, !settings.isEmpty else {
            print("saveHDSSettings: Không có dữ liệu HDSSetting")
            return
        }
        do {
            let realm = try Realm()

            try realm.write {
                // Xoá dữ liệu cũ (nếu cần cập nhật)
                realm.delete(realm.objects(HDSSetting.self))
                // Thêm mới
                realm.add(settings, update: .modified)
            }
        } catch {
            print(
                "saveHDSSettings: Lỗi khi lưu HDSSettings vào Realm - \(error.localizedDescription)"
            )
        }
    }

    func getCurrentUser() -> UserInfo? {
        let realm = try! Realm()
        return realm.objects(UserInfo.self).first
    }
    func getHDSSettings() -> [HDSSetting] {
        let realm = try! Realm()
        return Array(realm.objects(HDSSetting.self))
    }
    
    func logout() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(UserInfo.self))
        }
    }
}
