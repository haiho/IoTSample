//
//  CustomTextField.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 25/07/2025.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: LocalizedStringKey
    @Binding var text: String
    var icon: String? = nil // SF Symbol
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default

    @State private var isSecureVisible: Bool = false

    var body: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(.gray)
            }

            if isSecure && !isSecureVisible {
                SecureField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .font(.fontTextNormal)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .font(.fontTextNormal)
            }

            // Toggle eye icon for password fields
            if isSecure {
                Button(action: {
                    isSecureVisible.toggle()
                }) {
                    Image(systemName: isSecureVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
//                        .font(.system(size: 20))
                }
            }
        }
        .appInputFieldSpacing()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
    }
}

#Preview {
    CustomTextField(
        placeholder: "Password",
        text: .constant("dummy"),
        icon: "lock",
        isSecure: true
    )
}
