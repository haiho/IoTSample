//
//  HealthRepositoryImpl.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 26/9/25.
//
import SwiftUI

final class HealthRepositoryImpl: HealthRepository {

    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func syncHDSsampleFromIoTdevices(data: String) async throws -> BaseAPIResponse<GeneralResponse> {
        let request = SyncHDSRequest(data: data)
        let result: BaseAPIResponse<GeneralResponse> = try await APIService().request(
            path: "/syncHDSsampleFromIoTdevices",
            method: .POST,
            body: request,
            responseModel: GeneralResponse.self
        )
        return result
    }
}
