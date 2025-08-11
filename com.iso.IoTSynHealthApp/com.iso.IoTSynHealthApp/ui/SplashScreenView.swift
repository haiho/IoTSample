//
//  SplashScreenView.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 8/8/25.
//
import SwiftUI

struct SplashScreenView: View {

    @State var isActive: Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var body: some View {
        if isActive {
            LandingView()
        } else {
            ZStack {
                Color.green  // Nền xanh
                    .opacity(0.2)
                    .ignoresSafeArea()  // Phủ kín toàn màn hình

                VStack {
                    VStack {
                        Image(
                            colorScheme == .light
                                ? "splash-light" : "splash-dark"

                        )
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 125)

                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .foregroundColor(Color.red)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 0.9
                            self.opacity = 1.00
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
