//
//  CustomText.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 13/8/25.
//
import SwiftUI

struct CustomText: View {
    private let text: Text

    init(_ content: String, isLocalized: Bool = false) {
        if isLocalized {
            self.text = Text(LocalizedStringKey(content))
        } else {
            self.text = Text(content)
        }
    }

    var body: some View {
        text
            .font(.fontTextNormal)
            .foregroundColor(.primary)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)  // căn lề cho text full with và bên trái
    }
}
