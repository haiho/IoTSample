import SwiftUI

struct LoginView: View {
    @State private var email = "duyendm@doctella.com"
    @State private var password = "Doctella@2020"

    @EnvironmentObject var navManager: AuthNavigationManager
    @EnvironmentObject var appSession: AppSession
    @EnvironmentObject var viewModel: LandingViewModel

    @State private var showErrorBanner = false
    @State private var errorMessage = ""

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                // Tạo không gian cho navigation bar custom
                Color.clear.frame(height: 64)

                CenteredScrollVStack {
                    CustomTextField(
                        placeholder: "lbl_email",
                        text: $email,
                        icon: "envelope",
                        keyboardType: .emailAddress
                    )
                    .padding(.bottom, 8)

                    CustomTextField(
                        placeholder: "lbl_password",
                        text: $password,
                        icon: "lock",
                        isSecure: true
                    )
                    .padding(.bottom, 8)

                    Spacer().frame(height: 16)

                    CustomButton(title: "lbl_login") {
                        Task {
                            if let response = await viewModel.login(
                                email: email,
                                password: password
                            ) {
                                // Login thành công
                                errorMessage = " Login thành công \(response)"
                                withAnimation {
                                    showErrorBanner = true
                                }
                                DispatchQueue.main.asyncAfter(
                                    deadline: .now() + 4
                                ) {
                                    withAnimation {
                                        showErrorBanner = false
                                    }
                                }
                            } else {
                                errorMessage =
                                    viewModel.errorMessage ?? "Unknown error"
                                withAnimation {
                                    showErrorBanner = true
                                }
                                DispatchQueue.main.asyncAfter(
                                    deadline: .now() + 4
                                ) {
                                    withAnimation {
                                        showErrorBanner = false
                                    }
                                }
                            }
                        }
                    }

                    HStack {
                        ClickableTextLink(
                            strText: "lbl_signup",
                            screen: .register
                        )
                        Spacer().frame(width: 20)
                        ClickableTextLink(
                            strText: "lbl_forgot_pw",
                            screen: .forgotPW
                        )
                    }
                    .padding(.top, 40)
                }
                .appScreenPadding()
            }

            // Hiển thị custom nav bar
            CustomNavigationBarView(title: "title_login_screen")
                .zIndex(2)

            // Hiển thị TopBannerView nếu có lỗi
            if showErrorBanner {
                TopBannerView(
                    message: errorMessage,
                    isShowing: $showErrorBanner
                )
                .zIndex(3)
                .transition(.move(edge: .top))
            }
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarHidden(true)  // Ẩn toolbar mặc định
    }

}
