//
//  EmailAndNewPassWidget.swift
//  3oon
//
//  Created by Mazen on 11/02/2024.
//


import SwiftUI

struct EmailAndNewPassWidget: View {

    // MARK: - StateObject var
    @StateObject var handler = Handler()

    // MARK: - State var
    @State var email = ""
    @State var password = ""
    @State var isValidEmail = false
    @State var isValidPassword = false

    // MARK: Binding
    @Binding var isSignupButtonDisabled: Bool
    @Binding var error: String
    @Binding var isLoading: Bool
    @Binding var isLoginActive: Bool

    var body: some View {
        VStack(spacing: 0) {
            ApplicationTextfieldView(textFieldType: .email,
                              textFieldValue: $email,
                                     isValid: $isValidEmail)
            .padding(.bottom, 24)

            ApplicationTextfieldView(textFieldType: .createPassword,
                              textFieldValue: $password,
                              isValid: $isValidPassword)

            .padding(.bottom, 16)
            .onSubmit {
                if !isSignupButtonDisabled {
                    submitCaptainData()
                }
            }

            PasswordValidationWidget(password: password)

            Spacer()

            SignupBottomView(isSignupButtonDisabled: isSignupButtonDisabled) {
                submitCaptainData()
            }
        }
        .onReceive(handler.$errorMsg) { errorMessage in
            self.error = errorMessage
        }
        .onReceive(handler.$isLoading) { isLoading in
            self.isLoading = isLoading
        }
        .onChange(of: isValidEmail) { _ in
            checkIfFieldsAreValid()
        }
        .onChange(of: isValidPassword) { _ in
            checkIfFieldsAreValid()
        }
    }
}

#Preview {
    EmailAndNewPassWidget(isSignupButtonDisabled: .constant(false),
                          error: .constant(""),
                          isLoading: .constant(false),
                          isLoginActive: .constant(false))
}
