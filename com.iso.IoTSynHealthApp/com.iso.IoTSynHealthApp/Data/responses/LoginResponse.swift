//
//  LoginResponse.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 19/9/25.
//

struct LoginResponse: Decodable {
    let token: String
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let isActivated: Bool

    enum CodingKeys: String, CodingKey {
        case token, email
        case id = "_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case isActivated = "is_activated"
    }
}

