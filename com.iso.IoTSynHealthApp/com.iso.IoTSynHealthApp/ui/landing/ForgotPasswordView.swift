//
//  ForgotPasswordView.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 13/8/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var navManager: NavigationManager
    @State var email: String = ""

    var body: some View {
        CenteredScrollVStack {
            CustomText("Please enter yuor email address").padding(.bottom, 20)
            CustomTextFieldWithLabel(
                label: "lbl_email",
                placeholder: "lbl_email",
                text: $email
            ).padding(.bottom, AppPadding.btnSpacing)

            CustomButton(title: "btn_send") {
            }

        }.customNavigationBar(
            title: "lbl_forgot_pw",
            backAction: {
                navManager.pop()
            }
        ).appScreenPadding()
    }
}

#Preview {
    ForgotPasswordView()
}
