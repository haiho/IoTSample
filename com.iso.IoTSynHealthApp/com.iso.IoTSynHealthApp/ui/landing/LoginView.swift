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

    @EnvironmentObject var navManager: AuthNavigationManager
    @EnvironmentObject var appSession: AppSession
    @EnvironmentObject var viewModel: LandingViewModel

    var body: some View {

        CenteredScrollVStack {
            CustomTextField(
                placeholder: "lbl_email",
                text: $email,
                icon: "envelope",
                keyboardType: .emailAddress
            )
            .padding(.bottom, 8)

            CustomTextField(
                placeholder: "lbl_password",
                text: $password,
                icon: "lock",
                isSecure: true
            )
            .padding(.bottom, 8)

            Spacer().frame(height: 16)

            CustomButton(title: "lbl_login") {
                Task {
               
                    let pw = sha256("Doctella@2020")
                    print(pw)
                    await viewModel.login(
                        email: "duyendm@doctella.com",
                        password: pw
                    )
                }
        
            }

            HStack {
                ClickableTextLink(
                    strText: "lbl_signup",
                    screen: .register
                )
                Spacer().frame(width: 20)

                ClickableTextLink(
                    strText: "lbl_forgot_pw",
                    screen: .forgotPW
                )
            }.padding(.top, 40)

        }
        .customNavigationBar(title: "title_login_screen")
        .appScreenPadding()

    }

}

#Preview {
    LoginView()
}
