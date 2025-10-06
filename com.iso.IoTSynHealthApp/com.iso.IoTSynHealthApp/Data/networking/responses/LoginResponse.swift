//
//  LoginResponse.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 19/9/25.
//
import SwiftUI

class LoginResponse: BaseAPIResponse {
    var data: UserLoginResponse?
    var hdsSettings: [HDSSetting]?

    enum CodingKeys: String, CodingKey {
        case data
        case hdsSettings = "hds_settings"
    }

    required init(from decoder: Decoder) throws {
        // Gán xong mới gọi super.init
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decodeIfPresent(UserLoginResponse.self, forKey: .data)
        self.hdsSettings = try container.decodeIfPresent([HDSSetting].self, forKey: .hdsSettings)

        try super.init(from: decoder)
    }
}
