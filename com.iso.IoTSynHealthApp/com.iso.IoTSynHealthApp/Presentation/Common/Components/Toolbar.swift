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

struct CustomNavigationBarView: View {
    let title: LocalizedStringKey
    var showBackButton: Bool = true
    var backAction: (() -> Void)? = nil

    var body: some View {
        HStack {
            if showBackButton, let action = backAction {
                Button(action: action) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }
            }
            Spacer()
            Text(title)
                .font(.fontTitle)
                .foregroundColor(.black)
            Spacer()
            // Để title luôn giữa, ta thêm 1 view vô hình
            if showBackButton {
                Color.clear
                    .frame(width: 24, height: 24)
            }
        }
        .padding()
        .background(Color.white)
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

    func customNavigationBarStringValue(
        title: String,
        showBackButton: Bool = true,
        backAction: (() -> Void)? = nil
    ) -> some View {
        self.modifier(
            CustomNavigationBarStringModifier(
                title: title,
                showBackButton: showBackButton,
                backAction: backAction

            )
        )
    }
}

private struct CustomNavigationBarStringModifier: ViewModifier {
    var title: String
    var showBackButton: Bool
    var backAction: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .toolbar {
                // set title ở giữa màn hình
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.fontTitle)
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

private struct CustomNavigationBarModifier: ViewModifier {
    var title: LocalizedStringKey
    var showBackButton: Bool
    var backAction: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .toolbar {
                // set title ở giữa màn hình
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.fontTitle)
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
