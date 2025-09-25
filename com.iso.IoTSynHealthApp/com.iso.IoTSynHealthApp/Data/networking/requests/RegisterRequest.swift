//
//  RegisterRequest.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 25/9/25.
//

struct RegisterRequest: APIRequest {
    let email: String
    let password: String
    let env: String
    let firstName: String
    let lastName: String
    let auth: String
    let countryCode: String
    let isoCode: String
    let qa: String
    let ppKhs: String
    let siteID: String
    let extendedAttributes1: String
    let extendedAttributes2: String
    let timezone: String
    let timezoneLabel: String

    enum CodingKeys: String, CodingKey {
        case env, auth, qa, timezone
        case email = "account"
        case password = "pwd"
        case firstName = "first_name"
        case lastName = "last_name"
        case countryCode = "country_code"
        case isoCode = "iso_code"
        case ppKhs = "pp_khs"
        case siteID = "come_from_site_id"
        case extendedAttributes1 = "extended_attributes[security_question1]"
        case extendedAttributes2 = "extended_attributes[security_question2]"
        case timezoneLabel = "timezone_label"
    }
}
