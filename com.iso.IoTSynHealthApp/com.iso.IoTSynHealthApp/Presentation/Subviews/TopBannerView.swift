//
//  TopBannerView.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 23/9/25.
//
import SwiftUI

struct TopBannerView: View {
    let message: String
    @Binding var isShowing: Bool

    var body: some View {
        if isShowing {
            Text(message)
                .foregroundColor(.white)
                .padding(.top, 12)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)  // 👈 tăng padding bottom tại đây
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(999)
        }
    }
}
