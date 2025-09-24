//
//  IoTSynHealthAppApp.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 25/07/2025.
//

import SwiftUI

@main
struct IoTSynHealthApp: App {
    @StateObject private var appSession = AppSession.shared

    //  MARK:  @EnvironmentObject var appSession: AppSession // ❌
    //    @EnvironmentObject không thể dùng trực tiếp trong struct App (tức là trong MyApp: App struct) vì:
    //
    //    @EnvironmentObject chỉ hoạt động trong SwiftUI view hierarchy.
    //
    //    App không phải là một View, nó là một entry point của app, nên không thể tự động nhận EnvironmentObject.

    var body: some Scene {
        WindowGroup {
            RootView().environmentObject(appSession)
        }
    }
}
