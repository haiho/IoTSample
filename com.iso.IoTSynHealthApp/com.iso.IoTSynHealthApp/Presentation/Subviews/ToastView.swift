//
//  ToastView.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 23/9/25.
//
import SwiftUI

struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.black.opacity(0.8))
            .cornerRadius(12)
            .shadow(radius: 10)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
    }
}
