//
//  AuthRepositoryImpl.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 23/9/25.
//

import SwiftUI

final class AuthRepositoryImpl: AuthRepository {
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func login(email: String, password: String) async throws -> LoginResponse? {
        let request = LoginRequest(email: email, password: sha256(password))
        let result: LoginResponse = try await APIService().request(
            path: "/signin",
            method: .POST,
            body: request,
            responseModel: LoginResponse.self
        )
        return result
    }
}
