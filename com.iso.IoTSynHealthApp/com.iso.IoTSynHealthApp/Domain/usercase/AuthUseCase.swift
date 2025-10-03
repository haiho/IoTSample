//
//  LoginUseCase.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 23/9/25.
//

protocol AuthUseCase {
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

final class DefaultLoginUseCase: AuthUseCase {

    private let authRepository: AuthRepository

    init(authRepository: AuthRepository = AuthRepositoryImpl()) {
        self.authRepository = authRepository
    }

    func login(email: String, password: String) async throws -> BaseAPIResponse<
        LoginResponse
    > {
        try await authRepository.login(email: email, password: password)
    }

    func register(
        email: String,
        password: String,
        firstName: String,
        lastName: String
    ) async throws -> BaseAPIResponse<RegisterResponse> {
        try await authRepository.register(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName
        )
    }

}
