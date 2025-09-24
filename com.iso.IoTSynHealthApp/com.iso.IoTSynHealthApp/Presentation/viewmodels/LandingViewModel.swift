//
//  LandingViewModel.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 19/9/25.
//
// app token : fdce1e74ed5125589d66c80bfc02162c
import SwiftUI

@MainActor
class LandingViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let loginUseCase: LoginUseCase

    init(loginUseCase: LoginUseCase = DefaultLoginUseCase()) {
        self.loginUseCase = loginUseCase
    }

    func login(email: String, password: String) async -> LoginResponse? {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await loginUseCase.execute(
                email: email,
                password: password
            )
            return response
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }

}
