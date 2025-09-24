//
//  AuthRepository.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 23/9/25.
//

// Domain/Repositories/AuthRepository.swift
protocol AuthRepository {
    func login(email: String, password: String) async throws -> LoginResponse?
}
