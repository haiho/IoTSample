//
//  Toolbar.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 13/8/25.
//

import SwiftUI

//struct ToolbarCenter: ToolbarContent {
//    var title: LocalizedStringKey
//
//    var body: some ToolbarContent {
//        ToolbarItem(placement: .principal) {
//            Text(title)
//                .font(.system(size: 24, weight: .bold))
//                .foregroundColor(.black)
//        }
//    }
//}

struct CustomNavigationBarModifier: ViewModifier {
    var title: LocalizedStringKey
    var showBackButton: Bool
    var backAction: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .toolbar {
                // set title ở giữa màn hình
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                }
                // Nút back bên trái
                if showBackButton, let action = backAction {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: action) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.blue)
                                .imageScale(.large)

                        }
                    }
                }

            }
            .navigationBarBackButtonHidden(true)  // hide lable back

    }
}

extension View {
    func customNavigationBar(
        title: LocalizedStringKey,
        showBackButton: Bool = true,
        backAction: (() -> Void)? = nil
    ) -> some View {
        self.modifier(
            CustomNavigationBarModifier(
                title: title,
                showBackButton: showBackButton,
                backAction: backAction

            )
        )
    }
}
// MARK : Vstack to base

