//
//  CryptoHelper.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 19/9/25.
//

import CryptoKit
import Foundation

func sha256(_ input: String, salt: String? = nil) -> String {
    let dataToHash: String
    if let salt = salt {
        dataToHash = salt + input
    } else {
        dataToHash = input
    }
    let inputData = Data(dataToHash.utf8)
    let hashed = SHA256.hash(data: inputData)
    return hashed.map { String(format: "%02x", $0) }.joined()
}

func getSecureSalt(algorithm: String, password: String, saltInput: String)
    -> String
{
    var salt: String? = nil
    let loopCount = 2

    for _ in 0..<loopCount {
        if let currentSalt = salt {
            salt = sha256(currentSalt, salt: saltInput)
        } else {
            salt = sha256(password, salt: saltInput)
        }
    }
    return salt ?? ""
}

extension String {
    func sha256() -> String {
        let inputData = Data(self.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.map { String(format: "%02x", $0) }.joined()
    }
}
