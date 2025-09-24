//
//  LandingView.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 11/8/25.
//

import SwiftUI

struct LandingView: View {
    @StateObject var navManager = AuthNavigationManager()
    @StateObject var landingVM = LandingViewModel()

    var body: some View {
        NavigationStack(path: $navManager.path) {
            LoginView().navigationDestination(for: AuthScreen.self) { screen in
                switch screen {
                case .main:
                    MainView()
                case .login:
                    LoginView()
                case .forgotPW:
                    ForgotPasswordView()
                case .register:
                    RegisterScreen()
                }

            }
        }
        .environmentObject(navManager)
        .environmentObject(landingVM)
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()  // ✅ Preview từ gốc
    }
}
