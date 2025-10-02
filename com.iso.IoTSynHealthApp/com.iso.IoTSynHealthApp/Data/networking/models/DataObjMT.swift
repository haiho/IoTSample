import SwiftUI

struct DataObjMT: Codable {
    var type: String?
    var serial: String?
    var firmware: String?
    var value: String?
    var timestamp: String?
    var sourceName: String?

    enum CodingKeys: String, CodingKey {
        case type
        case serial
        case firmware
        case value
        case timestamp
        case sourceName = "source_name"
    }

    init(
        type: String?,
        value: String?,
        timestamp: Date?,
        sourceName: String? = "Iphone",
        serial: String? = "--",
        firmware: String? = "--"
    ) {
        // ✅ Gửi đúng định dạng ISO 8601
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // gửi UTC
        
        self.timestamp = timestamp != nil ? formatter.string(from: timestamp!) : nil

        self.type = type
        self.value = value
        self.serial = serial
        self.firmware = firmware
        self.sourceName = sourceName
    }
}
