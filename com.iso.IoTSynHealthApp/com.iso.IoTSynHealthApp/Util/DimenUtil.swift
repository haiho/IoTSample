//
//  DimenUtil.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 14/8/25.
//
import SwiftUI

struct AppPadding {
    static let horizontal: CGFloat = 16
    static let vertical: CGFloat = 20
    static let screenTop: CGFloat = 24
    static let screenBottom: CGFloat = 32

    static let fieldSpacing: CGFloat = 20
    static let sectionSpacing: CGFloat = 40
    
    static let sp12: CGFloat = 12
}

extension View {
    func appHorizontalPadding() -> some View {
        self.padding(.horizontal, 16)
    }

    func appScreenPadding() -> some View {
        self
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 16)
    }
    func appInputFieldSpacing() -> some View {
        self.padding(AppPadding.sp12)
    }
    func appFieldSpacing() -> some View {
        self.padding(.bottom, 16)
    }
}
