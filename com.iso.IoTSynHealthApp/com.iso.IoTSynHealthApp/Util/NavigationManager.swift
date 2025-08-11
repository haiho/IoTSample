//
//  NavigationManager.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 8/8/25.
//

import SwiftUI

enum Screen: Hashable {
    case login
    case main
}

class NavigationManager: ObservableObject {
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
