//
//  AuthRepository.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 23/9/25.
//

// Domain/Repositories/AuthRepository.swift
protocol AuthRepository {
    func login(email: String, password: String) async throws -> BaseAPIResponse<
        LoginResponse
    >
    func register(
        email: String,
        password: String,
        firstName: String,
        lastName: String
    ) async throws -> BaseAPIResponse<RegisterResponse>
}
