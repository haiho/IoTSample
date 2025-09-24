import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    @EnvironmentObject var navManager: AuthNavigationManager
    @EnvironmentObject var appSession: AppSession
    @EnvironmentObject var viewModel: LandingViewModel

    @State private var showErrorBanner = false
    @State private var errorMessage = ""
    @State private var isLoading = false

    var body: some View {
        ZStack {
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
                        if !validateAccount() {
                            withAnimation { showErrorBanner = true }
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + 4
                            ) {
                                withAnimation { showErrorBanner = false }
                            }
                            return
                        }
                        isLoading = true
                        defer { isLoading = false }  // ← Tự động gọi khi Task kết thúc
                        //                        defer {
                        //                            Task {
                        //                                // Delay 10 giây trước khi tắt loading
                        //                                try? await Task.sleep(
                        //                                    nanoseconds: 10 * 1_000_000_000
                        //                                )
                        //                                isLoading = false
                        //                            }
                        //                        }

                        if let response = await viewModel.login(
                            email: email,
                            password: password
                        ) {
                            errorMessage = "Login thành công \(response)"
                            withAnimation { showErrorBanner = true }
                            navManager.resetToRoot()  // cần khi xoá hết cách stack
                            navManager.push(.main)
                        } else {
                            errorMessage =
                                viewModel.errorMessage ?? "Unknown error"
                            withAnimation { showErrorBanner = true }
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
            .customNavigationBar(title: "title_login_screen")
            .appScreenPadding()
            .disabled(isLoading)  // Chặn tương tác khi loading
            .alert(isPresented: $showErrorBanner) {
                Alert(
                    title: Text("title_alert_error".localized),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK")) {
                        showErrorBanner = false
                        //                        navManager.resetToRoot()  // cần khi xoá hết cách stack
                        //                        navManager.push(.main)
                    }
                )
            }
            if isLoading {
                LoadingView()
            }

        }
    }

    // MARK: - ✅ Validate Email và Password
    func validateAccount() -> Bool {
        if email.isEmpty {
            errorMessage = "msg_email_blank".localized
            return false
        }
        if password.isEmpty {
            errorMessage = "msg_pw_blank".localized
            return false
        }

        if !isValidEmail(email) {
            errorMessage = "msg_valid_email".localized
            return false
        }

        if password.count < 6 {
            errorMessage = "msg_valid_pw".localized
            return false
        }

        return true
    }
}
