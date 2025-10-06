//
//  LoginResponse.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 19/9/25.
//

class RegisterResponse: BaseAPIResponse {
    let token: String

    enum CodingKeys: String, CodingKey {
        case token
    }

    required init(from decoder: Decoder) throws {
        // Decode token riêng
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.token = try container.decode(String.self, forKey: .token)

        // Gọi decoder cho lớp cha
        try super.init(from: decoder)
    }
}
