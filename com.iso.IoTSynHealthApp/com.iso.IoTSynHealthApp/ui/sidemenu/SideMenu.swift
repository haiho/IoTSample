//
//  Drawer in SwiftUI.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 20/8/25.
//

import SwiftUI

public struct SideMenu<MenuContent: View>: ViewModifier {
    @Binding var isShowing: Bool
    private let menuContent: () -> MenuContent

    public init(
        isShowing: Binding<Bool>,
        @ViewBuilder menuContent: @escaping () -> MenuContent
    ) {
        _isShowing = isShowing
        self.menuContent = menuContent
    }

    public func body(content: Content) -> some View {
        let drag = DragGesture().onEnded { event in
            if event.location.x < 200 && abs(event.translation.height) < 50
                && abs(event.translation.width) > 50
            {
                withAnimation {
                    self.isShowing = event.translation.width > 0
                }
            }
        }

        return GeometryReader { geometry in
            let menuWidth = geometry.size.width * 0.7

            ZStack(alignment: .leading) {
                content
                    .disabled(isShowing)
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    .offset(x: self.isShowing ? menuWidth : 0)

                menuContent()
                    .frame(width: menuWidth)
                    .transition(.move(edge: .leading))
                    .offset(x: self.isShowing ? 0 : -menuWidth)
            }
            .gesture(drag)
        }
    }

}

extension View {
    public func sideMenu<MenuContent: View>(
        isShowing: Binding<Bool>,
        @ViewBuilder menuContent: @escaping () -> MenuContent
    ) -> some View {
        self.modifier(SideMenu(isShowing: isShowing, menuContent: menuContent))
    }
}

