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
    let gender: String?
    let birthdate: String?
    let country: String?
    let countryCode: String


    enum CodingKeys: String, CodingKey {
        case token, email, gender, birthdate, country 
        case id = "_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case isActivated = "is_activated"
        case countryCode = "country_code"
    }
}
