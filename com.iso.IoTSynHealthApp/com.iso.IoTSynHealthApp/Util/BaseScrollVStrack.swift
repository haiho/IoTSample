//
//  BaseScrollVStrack.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 14/8/25.
//
import SwiftUI

// MARK : BaseScrollVStrack

struct BaseScrollVStrack<Content: View>: View {
    let spacing: CGFloat
    let backgroundColor: Color?
    let content: () -> Content

    init(
        spacing: CGFloat = 16,
        backgroundColor: Color? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.spacing = spacing
        self.content = content
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: spacing) {
                content()
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.horizontal, 16)
        }
        .background(backgroundColor ?? Color(.systemBackground))
        .ignoresSafeArea(.keyboard, edges: .bottom)
        //// hoặc dùng .safeAreaInset nếu muốn tự động
    }
}
// MARK : CenteredScrollVStack
struct CenteredScrollVStack<Content: View>: View {
    let spacing: CGFloat
    let content: () -> Content

    init(
        spacing: CGFloat = 16,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                VStack(spacing: spacing) {
                    Spacer(minLength: 0)

                    VStack(spacing: spacing) {
                        content()
                    }
                    .frame(maxWidth: .infinity)

                    Spacer(minLength: 0)
                }
                .frame(minHeight: geo.size.height)
                .padding(.horizontal, 16)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color(.systemBackground))
            .ignoresSafeArea(.keyboard, edges: .bottom)  // push view on keyboard
        }
    }
}
