//
//  ForgotPasswordView.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 13/8/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var navManager: NavigationManager
    var body: some View {
        CenteredScrollVStack {
            Text("ForgotPasswordView")
        }.customNavigationBar(
            title: "lbl_forgot_pw",
            backAction: {
                navManager.pop()
            }
        )
    }
}

#Preview {
    ForgotPasswordView()
}
