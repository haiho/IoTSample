//
//  HealthRepository.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 26/9/25.
//

protocol HealthRepository {
    func syncHDSsampleFromIoTdevices(data: String) async throws
        -> BaseAPIResponse
}
