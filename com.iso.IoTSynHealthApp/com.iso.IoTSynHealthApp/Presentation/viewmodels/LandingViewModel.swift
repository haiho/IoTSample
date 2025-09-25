//
//  LandingViewModel.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 19/9/25.
//

import SwiftUI

@MainActor
class LandingViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let loginUseCase: AuthUseCase

    init(loginUseCase: AuthUseCase = DefaultLoginUseCase()) {
        self.loginUseCase = loginUseCase
    }

    func login(email: String, password: String) async -> LoginResponse? {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await loginUseCase.login(
                email: email,
                password: password
            )
            return response
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }

    func register(
        email: String,
        password: String,
        firstName: String,
        lastName: String
    ) async -> RegisterResponse? {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await loginUseCase.register(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName
            )
            return response
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }

}
