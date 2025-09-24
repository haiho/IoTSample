//
//  ForgotPasswordView.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 13/8/25.
//

import SwiftUI

struct RegisterScreen: View {
    @EnvironmentObject var navManager: AuthNavigationManager
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var re_password = ""

    var body: some View {
        BaseScrollVStrack {
            Image("test_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.bottom, 40)

            HStack {
                CustomTextFieldWithLabel(
                    label: "lbl_first_name",
                    placeholder: "lbl_password",
                    text: $firstName
                )
                Spacer().frame(width: 16)
                CustomTextFieldWithLabel(
                    label: "lbl_last_name",
                    placeholder: "lbl_last_name",
                    text: $lastName
                )
            }

            CustomTextFieldWithLabel(
                label: "lbl_email",
                placeholder: "lbl_email",
                text: $email
            )

            CustomTextFieldWithLabel(
                label: "lbl_password",
                placeholder: "lbl_password",
                text: $password,
                isSecure: true
            )

            CustomTextFieldWithLabel(
                label: "str_confirm_pw",
                placeholder: "str_confirm_pw",
                text: $re_password,
                isSecure: true
            ).padding(.bottom, 30)

            CustomButton(title: "btn_send") {
            }

        }.customNavigationBar(
            title: "lbl_signup",
            backAction: {
                navManager.pop()
            }
        ).appScreenPadding()
    }
}

#Preview {
    RegisterScreen()
}
