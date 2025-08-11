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
                Color.black
                    .opacity(0.2)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    CustomTextField(
                        placeholder: "Email",
                        text: $email,
                        icon: "envelope",
                        keyboardType: .emailAddress
                    )

                    CustomTextField(
                        placeholder: "Password",
                        text: $password,
                        icon: "lock",
                        isSecure: true
                    )

                    CustomButton(title: "Đăng nhập") {
                        //action
                        print("Email: \(email), Password: \(password)")
                    }

                    Button("Đăng nhập 2") {
                        // Xử lý login
                        navManager.resetToRoot()
                        navManager.push(.main)
                    }
                    .buttonStyle(PrimaryButtonStyle())

                    //                    ProgressView()
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Login screen")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.black)

                }
            }

            //            .navigationTitle("Login screen")// ko dùng cái này, vì ko căn giữa screen dc

        }
    }
}

#Preview {
    LoginView()
}
