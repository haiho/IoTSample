//
//  StringUtil.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 24/9/25.
//
import SwiftUI

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPredicate.evaluate(with: email)
}

//Password must be at least 8 characters and include at least one uppercase letter, one lowercase letter, one number, and one special character.

func isValidPassword(_ password: String) -> Bool {
    let passwordRegEx = #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"#
    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
    return passwordPredicate.evaluate(with: password)
}
