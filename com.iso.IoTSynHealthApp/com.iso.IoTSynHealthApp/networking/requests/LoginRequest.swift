//
//  LoginRequest.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 19/9/25.
//
import SwiftUI

struct LoginRequest: NonAuthorizedAPIRequest {
    let token: String
    let reqTime: Int64 
    let email: String
    let password: String
  

    enum CodingKeys: String, CodingKey {
        case token
        case reqTime = "req_time"
        case email = "account"
        case password = "pwd"
    
    }
}
