//
//  SyncHDSRequest.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 26/9/25.
//

struct SyncHDSRequest: APIRequest {
    let data: String
    enum CodingKeys: String, CodingKey {
        case data
    }
}
