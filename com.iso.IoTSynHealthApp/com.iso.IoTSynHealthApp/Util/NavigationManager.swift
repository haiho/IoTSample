//
//  NavigationManager.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 8/8/25.
//

import SwiftUI

protocol AppScreen: Hashable {}  // Marker protocol

enum AuthScreen: AppScreen {
    case login, register, forgotPW
}

enum MainScreen: AppScreen {
    case carDetail(Activity)
    case viewAllData(activity: Activity)
}

class BaseNavigationManager<Screen: AppScreen>: ObservableObject {
    @Published var path = NavigationPath()

    func push(_ screen: Screen) {
        path.append(screen)
    }

    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    func resetToRoot() {
        path = NavigationPath()
    }
}
// create alias

typealias AuthNavigationManager = BaseNavigationManager<AuthScreen>
typealias MainNavigationManager = BaseNavigationManager<MainScreen>

// MARK: mainview

enum MenuScreen {
    case home
    case account
    case settings
}
