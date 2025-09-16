//
//  ActivityCardDetail.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 16/9/25.
//
import SwiftUI

struct ActivityCardDetail: View {
    @EnvironmentObject var navManager: MainNavigationManager
    @State var email: String = ""

    var body: some View {
        CenteredScrollVStack {
            CustomText("Please enter yuor email address")
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
    ActivityCardDetail()
}
