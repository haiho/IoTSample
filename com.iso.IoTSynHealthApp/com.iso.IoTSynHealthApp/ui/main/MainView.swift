//
//  MainView.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 8/8/25.
//

import SwiftUI

struct MainView: View {
    @State private var showSideMenu = false
    @State private var selectedScreen: MenuScreen = .home
    @StateObject var navManager = MainNavigationManager()

    var body: some View {
        NavigationStack(path: $navManager.path) {
            ZStack {
                // Nội dung chính của màn hình
                Group {
                    switch selectedScreen {
                    case .home:
                        HomeView()
                    case .account:
                        SettingsView()
                    case .settings:
                        SettingsView()
                    }
                }
                .customNavigationBar(
                    title: titleForScreen(selectedScreen)
                )
                .navigationBarItems(
                    leading: Button(action: {
                        withAnimation {
                            self.showSideMenu.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                    }
                )
            }
            .navigationDestination(for: MainScreen.self) { route in
                switch route {
                case .carDetail(let activity):
                    ActivityCardDetail(activity: activity)
                }
            }
        }
        .environmentObject(navManager)
        .sideMenu(isShowing: $showSideMenu) {
            SideMenuContent(isShowing: $showSideMenu) { screen in
                self.selectedScreen = screen
            }
        }

    }

    private func titleForScreen(_ screen: MenuScreen) -> LocalizedStringKey {
        switch screen {
        case .home: return "title_home_screen"
        case .account: return "Tài khoản"
        case .settings: return "title_settings_screen"
        }
    }
}
