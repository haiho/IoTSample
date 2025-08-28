//
//  CustomText.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 13/8/25.
//
import SwiftUI

struct CustomText: View {
    private let content: String
    private let isLocalized: Bool
    private var font: Font
    private var color: Color
    private var alignment: TextAlignment

    init(
        _ content: String,
        color: Color = .primary,
        font: Font = .fontTextNormal,
        alignment: TextAlignment = .leading,
        isLocalized: Bool = false
    ) {
        self.content = content
        self.color = color
        self.font = font
        self.alignment = alignment
        self.isLocalized = isLocalized
    }

    var body: some View {
        let text: Text =
            isLocalized ? Text(LocalizedStringKey(content)) : Text(content)

        return
            text
            .font(font)
            .foregroundColor(color)
            .multilineTextAlignment(alignment)
            .frame(maxWidth: .infinity, alignment: alignmentForFrame(alignment))
    }

    // MARK: - Helpers

    private func alignmentForFrame(_ textAlignment: TextAlignment) -> Alignment
    {
        switch textAlignment {
        case .leading:
            return .leading
        case .center:
            return .center
        case .trailing:
            return .trailing
        @unknown default:
            return .leading
        }
    }

    // MARK: - Fluent Modifiers

    func font(_ font: Font) -> CustomText {
        var copy = self
        copy.font = font
        return copy
    }

    func color(_ color: Color) -> CustomText {
        var copy = self
        copy.color = color
        return copy
    }

    func alignment(_ alignment: TextAlignment) -> CustomText {
        var copy = self
        copy.alignment = alignment
        return copy
    }
}

extension CustomText {
    var smallText10: CustomText {
        self.font(.fontTextNormal10)
    }

    var title: CustomText {
        self.font(.fontTitle)
    }

    var leadingAligned: CustomText {
        self.alignment(.leading)
    }

    var centerAligned: CustomText {
        self.alignment(.center)
    }

    var trailingAligned: CustomText {
        self.alignment(.trailing)
    }
}
