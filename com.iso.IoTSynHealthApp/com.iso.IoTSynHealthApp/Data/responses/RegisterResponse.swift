//
//  LoginResponse.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 19/9/25.
//

struct RegisterResponse: Decodable {
    let token: String

    enum CodingKeys: String, CodingKey {
        case token
    }
}
