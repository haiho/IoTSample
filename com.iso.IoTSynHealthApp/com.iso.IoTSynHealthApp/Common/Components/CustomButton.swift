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

private struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                configuration.isPressed ? Color.blue.opacity(0.7) : Color.blue
            )
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK:  click on textview
struct ClickableTextLink: View {
    let strText: LocalizedStringKey
    let screen: Screen
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        Button(action: {
            navigationManager.push(screen)
        }) {
            Text(strText)
                .font(.footnote)
                .font(.system(size: 20))
                .foregroundColor(.blue)
                .underline()
        }

    }
}
