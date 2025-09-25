//
//  CustomTextField.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 25/07/2025.
//

import SwiftUI

struct CustomTextFieldWithLabel: View {
    var label: LocalizedStringKey
    var placeholder: LocalizedStringKey
    @Binding var text: String
    var icon: String? = nil  // SF Symbol
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default

    @State private var isSecureVisible: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
                .font(.fontTextNormal)

            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(.gray)
                }

                if isSecure && !isSecureVisible {
                    SecureField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .textInputAutocapitalization(.never)
                        .font(.fontTextNormal)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .textInputAutocapitalization(.never)
                        .font(.fontTextNormal)
                }

                if isSecure {
                    Button(action: {
                        isSecureVisible.toggle()
                    }) {
                        Image(systemName: isSecureVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
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
}

#Preview {
    CustomTextFieldWithLabel(
        label: "lbl_password",
        placeholder: "Password",
        text: .constant("dummy"),
        icon: "lock",
        isSecure: true
    )
}
