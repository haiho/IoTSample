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

    func register(
        email: String,
        password: String,
        firstName: String,
        lastName: String
    ) async throws -> RegisterResponse? {
        
        let request = RegisterRequest(email: email, password: sha256(password), env: "QA", firstName: firstName, lastName: lastName,
                                      auth: "", countryCode: "84", isoCode: "VN", qa: "WHATWASYOURCHILDHOODNICKNAME?",
                                      ppKhs: "[{\"ref10\":\"1055acff771ddf081ecffef3a15dd591d40d10d796154fc687410d8a8438192a\",\"ref20\":[{\"ref21\":\"REF21.1\",\"ref22\":\"REF22.1\",\"ref23\":\"9a57e9769872ae94f6eed9e92a88ee88\",\"ref24\":\"422ce33c1401ccf98ce5c7b5e319cef7\",\"ref25\":\"oCvaT7f2QYTFKD2hH8d0UPiB  sciv83ob6cCD3rhJRXVuShFpFAe/0VbjUgLolUT0bsrSXhKlZMu9 7UQzNYGy9DWa/ypNzN23aBstmGX8=\"}],\"ref30\":[{\"ref31\":\"REF31.1\",\"ref32\":\"REF32.1\",\"ref33\":\"e39afe347f41431d7b19d3cf84a81b019c42d0c758d11680dc737631e5cf3ac2\",\"ref34\":\"f9bed26f8cdc6895ed52d1301b34a0f5\",\"ref35\":\"s4eb 1X9KG6beKDAN/rylkpbXTPdXnMt43FP2Gz7ihzCqRDitH/7vRm/NFq3vqt4koLwLlwjeIkqZpmX5IXMDD elyNnd0lURwlh6j VSZ4=\"},{\"ref31\":\"REF31.1\",\"ref32\":\"REF32.2\",\"ref33\":\"e0dd9a2df9540805444c34bb214b0938d4dd6d636c679333bdafba0a1d125f99\",\"ref34\":\"c7a88aceb94d86c7e5b397365dbf7a02\",\"ref35\":\"8yOhvcH7ZGHUGp4yioTx9VX3kz7nUxkCDpclVkuAZII20eRQ5jce5TyFBohJTRMcoOutxMEs7Am82li794HEtuyPgWXcnbkQNz11fmqFI0k=\"}]}]",
                                      siteID: APIConfig.siteId , extendedAttributes1: "What was your childhood nickname?", extendedAttributes2: "What is your favorite children's book?", timezone: "07:00", timezoneLabel: "(UTC 07:00) Bangkok, Hanoi, Jakarta")
        
        let result: RegisterResponse = try await APIService().request(
            path: "/signup",
            method: .POST,
            body: request,
            responseModel: RegisterResponse.self
        )
        return result
    }
}
