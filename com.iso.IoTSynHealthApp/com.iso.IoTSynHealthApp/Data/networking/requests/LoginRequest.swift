//
//  LoginRequest.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 19/9/25.
//
import SwiftUI

struct LoginRequest: APIRequest {
    let email: String
    let password: String

    enum CodingKeys: String, CodingKey {
        case email = "account"
        case password = "pwd"
    }
}
