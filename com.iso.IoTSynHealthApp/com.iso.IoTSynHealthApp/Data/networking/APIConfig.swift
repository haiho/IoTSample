//
//  APIConfig.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 19/9/25.
//
import SwiftUI

struct APIConfig {
    static let baseURL = "https://vnmsnapi.ptvltd.com/api/mobile"
    static let secretKey = "fdce1e74ed5125589d66c80bfc02162c"
}

struct UserAgent {
    static func toString() -> String {
        let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "UnknownApp"
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
        let systemVersion = UIDevice.current.systemVersion
        let deviceModel = UIDevice.current.model
        let osName = UIDevice.current.systemName

        return "\(appName)/\(appVersion) (\(deviceModel); \(osName) \(systemVersion))"
    }
}
