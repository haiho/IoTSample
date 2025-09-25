//
//  ForgotPasswordView.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 13/8/25.
//

import SwiftUI

struct RegisterScreen: View {
    @EnvironmentObject var navManager: AuthNavigationManager
    @EnvironmentObject var viewModel: LandingViewModel

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var rePassword = ""

    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    @State private var isRegisterSuccess: Bool = false

    var body: some View {
        BaseScrollVStrack {
            Image("test_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.bottom, 40)

            HStack {
                CustomTextFieldWithLabel(
                    label: "lbl_first_name",
                    placeholder: "lbl_password",
                    text: $firstName
                )
                Spacer().frame(width: 16)
                CustomTextFieldWithLabel(
                    label: "lbl_last_name",
                    placeholder: "lbl_last_name",
                    text: $lastName
                )
            }

            CustomTextFieldWithLabel(
                label: "lbl_email",
                placeholder: "lbl_email",
                text: $email
            )

            CustomTextFieldWithLabel(
                label: "lbl_password",
                placeholder: "lbl_password",
                text: $password,
                isSecure: true
            )

            CustomTextFieldWithLabel(
                label: "str_confirm_pw",
                placeholder: "str_confirm_pw",
                text: $rePassword,
                isSecure: true
            ).padding(.bottom, 30)

            CustomButton(title: "btn_send") {
                Task {
                    if validateAccount() {
                        isLoading = true
                        do { isLoading = false }

                        if (await viewModel.register(
                            email: email,
                            password: password,
                            firstName: firstName,
                            lastName: lastName
                        )) != nil {
                            errorMessage = "msg_register_success".localized
                            withAnimation {
                                showError = true

                            }
                            isRegisterSuccess = true
                        } else {
                            errorMessage =
                                viewModel.errorMessage ?? "Unknown error"
                            withAnimation { showError = true }
                        }
                    } else {
                        withAnimation { showError = true }
                    }
                }
            }

        }.customNavigationBar(
            title: "lbl_signup",
            backAction: {
                navManager.pop()
            }
        )
        .appScreenPadding()
        .disabled(isLoading)  // Chặn tương tác khi loading
        .alert(isPresented: $showError) {
            Alert(
                title: Text(
                    isRegisterSuccess ? "" : "title_alert_error".localized
                ),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK")) {
                    showError = false
                    if isRegisterSuccess {
                        isRegisterSuccess = false
                        navManager.pop()
                    }

                }
            )
        }

        if isLoading {
            LoadingView()
        }

    }

    // MARK: - ✅ Validate Email và Password
    func validateAccount() -> Bool {

        if firstName.isEmpty {
            errorMessage = "msg_first_name_blank".localized
            return false
        }

        if lastName.isEmpty {
            errorMessage = "msg_last_name_blank".localized
            return false
        }

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

        if password.count < 8 {
            errorMessage = "msg_valid_pw".localized
            return false
        }
        if password != rePassword {
            errorMessage = "msg_pw_not_match".localized
            return false
        }
        return true
    }
}

#Preview {
    RegisterScreen()
}
