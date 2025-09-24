//
//  LoginUseCase.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 23/9/25.
//

protocol LoginUseCase {
    func execute(email: String, password: String) async throws -> LoginResponse?
}

final class DefaultLoginUseCase: LoginUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository = AuthRepositoryImpl()) {
        self.authRepository = authRepository
    }

    func execute(email: String, password: String) async throws -> LoginResponse? {
        try await authRepository.login(email: email, password: password)
    }
}
