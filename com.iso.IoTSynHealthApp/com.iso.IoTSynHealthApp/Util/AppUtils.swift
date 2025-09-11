//
//  AppUtils.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 15/8/25.
//

import SwiftUICore

//1. MARK : Background
struct OverlayBackground: View {
    var body: some View {
        Color.overlayBackground
            .ignoresSafeArea()
    }
}

//2. MARK : Color
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

struct AppPadding {
    static let horizontal: CGFloat = 16
    static let vertical: CGFloat = 20
    static let screenTop: CGFloat = 24
    static let screenBottom: CGFloat = 32

    static let fieldSpacing: CGFloat = 20
    static let sectionSpacing: CGFloat = 40
    static let withProgress: CGFloat = 18

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
    static var fontTextNormalBold: Font {
        .system(size: 16).bold()
    }
    static var fontTextNormal10: Font {
        .system(size: 10)
    }
    static var fontLabelBtn: Font {
        .system(size: 18)
            .bold()
    }
    static var fontTitle: Font {
        .system(size: 18)
            .bold()
    }
    //    static var fontTextNormal: Font {
    //        .custom("YourFontName-Regular", size: 16)
    //    }

}

// MARK: string
extension String {
    var localized: String {
        return NSLocalizedString(
            self,
            tableName: nil,
            bundle: .main,
            comment: ""
        )
    }

    func localizedFormat(_ args: CVarArg...) -> String {
        let localizedString = self.localized
        return String(format: localizedString, arguments: args)
    }
}
