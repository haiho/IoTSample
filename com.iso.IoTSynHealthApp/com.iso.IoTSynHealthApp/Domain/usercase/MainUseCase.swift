//
//  MainUseCase.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 26/9/25.
//

protocol MainUseCase {
    func syncHDSsampleFromIoTdevices(data: String) async throws
        -> BaseAPIResponse
}
final class DefaultMainUseCase: MainUseCase {
    private let healthRepository: HealthRepository

    init(healthRepository: HealthRepository = HealthRepositoryImpl()) {
        self.healthRepository = healthRepository
    }

    func syncHDSsampleFromIoTdevices(data: String) async throws
        -> BaseAPIResponse
    {
        try await healthRepository.syncHDSsampleFromIoTdevices(data: data)
    }

}
