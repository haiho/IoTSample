//
//  LoadingView.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 24/9/25.
//
import SwiftUI
struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.3), value: UUID()) // optional
    }
}
