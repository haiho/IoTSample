//
//  CustomTextField.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 25/07/2025.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
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
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
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
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
        .padding(.horizontal)
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
