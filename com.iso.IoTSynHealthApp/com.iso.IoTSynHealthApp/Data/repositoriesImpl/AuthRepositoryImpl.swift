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
        let response = try await apiService.request(
            path: "/signin",
            method: .POST,
            body: request,
            responseModel: BaseAPIResponse<LoginResponse>.self
        )
        return response.data
    }
}
