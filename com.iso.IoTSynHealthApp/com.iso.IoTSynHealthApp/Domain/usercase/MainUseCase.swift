//
//  MainUseCase.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 26/9/25.
//

protocol MainUseCase {
    func syncHDSsampleFromIoTdevices(data: String) async throws
        -> BaseAPIResponse<GeneralResponse>
}
final class DefaultMainUseCase: MainUseCase {
    private let healthRepository: HealthRepository

    init(healthRepository: HealthRepository = HealthRepositoryImpl()) {
        self.healthRepository = healthRepository
    }

    func syncHDSsampleFromIoTdevices(data: String) async throws
        -> BaseAPIResponse<GeneralResponse>
    {
        try await healthRepository.syncHDSsampleFromIoTdevices(data: data)
    }

}
