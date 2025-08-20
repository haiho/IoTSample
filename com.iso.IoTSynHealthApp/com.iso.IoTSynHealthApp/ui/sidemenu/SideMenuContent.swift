//
//  SideMenuContent.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 20/8/25.
//

import SwiftUI

struct SideMenuContent: View {
    @Binding var isShowing: Bool
    @AppStorage("isLoggedIn") var isLoggedIn = false
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            //            // ❌ Close Button
            //            Button(action: {
            //                withAnimation {
            //                    self.isShowing = false
            //                }
            //            }) {
            //                Image(systemName: "xmark")
            //                    .foregroundColor(.white)
            //                    .padding(8)
            //                    .background(Color.black.opacity(0.3))
            //                    .clipShape(Circle())
            //            }
            //            .padding(.top, 40)

            // 👤 Avatar + Info
            HStack(alignment: .center, spacing: 15) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.white)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Nguyễn Văn A")
                        .font(.headline)
                        .foregroundColor(.white)

                    Text("email@example.com")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }.padding(.top, 80)

            Divider()
                .background(Color.white.opacity(0.3))

            // 📄 Menu Items
            VStack(alignment: .leading, spacing: 15) {
                SideMenuItem(title: "Trang chủ", systemImage: "house") {
                    print("Trang chủ tapped")
                    withAnimation { isShowing = false }
                }

                SideMenuItem(title: "Tài khoản", systemImage: "person") {
                    print("Tài khoản tapped")
                    withAnimation { isShowing = false }
                }

                SideMenuItem(title: "Cài đặt", systemImage: "gear") {
                    print("Cài đặt tapped")
                    withAnimation { isShowing = false }
                }

                SideMenuItem(
                    title: "Đăng xuất",
                    systemImage: "arrow.right.square"
                ) {
                    print("Đăng xuất tapped")
                    withAnimation {
                        isShowing = false
                        isLoggedIn = false
                    }
                }
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.9))
        .edgesIgnoringSafeArea(.all)
    }
}
