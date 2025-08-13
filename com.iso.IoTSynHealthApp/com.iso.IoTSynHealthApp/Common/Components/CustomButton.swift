//
//  CustomButton.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 28/07/2025.
//

import SwiftUI

struct CustomButton: View {
    var title: LocalizedStringKey
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
        }.buttonStyle(PrimaryButtonStyle())
    }
}

