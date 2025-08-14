//
//  ColorUtil.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 12/8/25.
//

import SwiftUICore

extension Color {
    struct Background {
        static let primary = Color("primaryBackground")
        static let overlay = Color.black.opacity(0.2)
    }

    struct Accent {
        static let blue = Color(red: 0.2, green: 0.4, blue: 1.0)
    }
    static let primaryBackground = Color("primaryBackground")  // từ Asset
    static let accentBlue = Color(red: 0.2, green: 0.4, blue: 1.0)
    static let overlayBackground = Color.black.opacity(0.2)
}
