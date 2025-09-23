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

    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func login(email: String, password: String) async -> LoginResponse? {
        isLoading = true
        errorMessage = nil

        // Tạo body request đúng định dạng server yêu cầu
        let reqTimeStr = Int64(Date().timeIntervalSince1970 * 1000)
        let tokenRequestAPI = "fdce1e74ed5125589d66c80bfc02162c"
        let signMd5 = "\(reqTimeStr)\(tokenRequestAPI)"
        let tokenMd5 = signMd5.md5()
        let loginRequest = LoginRequest(
            token: tokenMd5,
            reqTime: reqTimeStr,
            email: email,
            password: sha256(password)
        )


        let endpoint = APIEndpoint(
            path: "/signin",
            method: .POST,
            body: loginRequest
        )

        do {
            let apiService = APIService()
            let response = try await apiService.request(endpoint, responseModel: BaseAPIResponse<LoginResponse>.self)
            if let loginData = response.data {
                print("✅ Đăng nhập thành công: \(loginData)")
                return response.data
            } else {
                print("⚠️ Không có dữ liệu trả về.")
                return nil
            }
        } catch {
            print("❌ Lỗi đăng nhập: \(error.localizedDescription)")
            return nil
        }
        
    }

}
