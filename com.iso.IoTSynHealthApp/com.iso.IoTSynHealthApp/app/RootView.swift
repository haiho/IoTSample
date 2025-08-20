//
//  ContentView.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 25/07/2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appSession: AppSession

    var body: some View {
        if appSession.isLoggedIn {
            ContentView()
        } else {
            SplashScreenView()
        }
    }
}
