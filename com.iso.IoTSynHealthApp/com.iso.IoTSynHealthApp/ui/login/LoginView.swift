//
//  File.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 25/07/2025.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var navManager: NavigationManager

    var body: some View {
        NavigationView {
            ZStack {
                // Nền màn hình
                OverlayBackground()

                VStack(spacing: 16) {
                    CustomTextField(
                        placeholder: "lbl_email",
                        text: $email,
                        icon: "envelope",
                        keyboardType: .emailAddress
                    ).padding(.bottom, 8)

                    CustomTextField(
                        placeholder: "lbl_password",
                        text: $password,
                        icon: "lock",
                        isSecure: true
                    ).padding(.bottom, 8)

                    Spacer().frame(height: 16)

                    CustomButton(title: "lbl_login") {
                        // Xử lý login
                        navManager.resetToRoot()
                        navManager.push(.main)
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 16)

                    CustomButton(title: "lbl_register") {
                        // Xử lý login
                        navManager.resetToRoot()
                        navManager.push(.main)
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .padding(.top, 8)
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("title_login_screen")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.black)

                }
            }

        }
    }
}

#Preview {
    LoginView()
}
