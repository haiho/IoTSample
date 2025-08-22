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

    static let btnSpacing: CGFloat = 40
    static let sp12: CGFloat = 12
}

extension View {
    
    func appHorizontalPadding() -> some View {
        self.padding(.horizontal, 16)
    }

    func appVerticalPadding() -> some View {
        self.padding(.vertical, 16)
    }

    func appScreenPadding() -> some View {
        self.padding(16)
    }
    func appInputFieldSpacing() -> some View {
        self.padding(AppPadding.sp12)
    }
    func appFieldSpacing() -> some View {
        self.padding(.bottom, 16)
    }
}

// MARK: for fontsize
extension Font {
    static var fontTextNormal: Font {
        .system(size: 16)
    }
    static var fontLabelBtn: Font {
        .system(size: 18)
        .bold()
    }
    static var fontTitle: Font {
        .system(size: 18)
        .bold()
    }

    //    func fontTextNormal() -> Font {
    //        .system(size: 16)
    //    }
}
