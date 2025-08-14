//
//  ForgotPasswordView.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 13/8/25.
//

import SwiftUI

struct RegisterScreen: View {
    @EnvironmentObject var navManager: NavigationManager

    var body: some View {
        CenteredScrollVStack {
            Image("test_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.top,100)
            Spacer()
            Image(systemName: "house")
            Text("RegisterScreen")
        }.customNavigationBar(
            title: "lbl_signup",
            backAction: {
                navManager.pop()
            }
        )
    }
}

#Preview {
    RegisterScreen()
}
