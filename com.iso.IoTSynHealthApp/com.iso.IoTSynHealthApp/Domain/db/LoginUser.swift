//
//  LoginUser.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 24/9/25.
//

import RealmSwift

class LoginUser: Object {
    @Persisted(primaryKey: true) var id: String
    //    @Persisted var token: String
    @Persisted var email: String
    @Persisted var firstName: String
    @Persisted var lastName: String
    @Persisted var isActivated: Bool
    @Persisted var gender: String?
    @Persisted var birthdate: String?
    @Persisted var country: String?
    @Persisted var countryCode: String

    // Optional: convenience init to map from Decodable model
    convenience init(from response: LoginResponse) {
        self.init()
        self.id = response.id
        //        self.token = response.token
        self.email = response.email
        self.firstName = response.firstName
        self.lastName = response.lastName
        self.isActivated = response.isActivated
        self.gender = response.gender
        self.birthdate = response.birthdate
        self.country = response.country
        self.countryCode = response.countryCode
    
    }

    // MARK: - Computed Property
    var fullName: String {
        let parts: [String] = [firstName, lastName].filter { !$0.isEmpty }
        return parts.joined(separator: " ")
    }

}
