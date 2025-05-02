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
    @State var fullName = ""
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var phoneNumber = ""
    @State var isValidFullName = false
    @State var isValidEmail = false
    @State var isValidPassword = false
    @State var isValidConfirmPassword = false
    @State var isValidPhoneNumber = false

    // MARK: Binding
    @Binding var isSignupButtonDisabled: Bool
    @Binding var error: String
    @Binding var isLoading: Bool
    @Binding var isLoginActive: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Full Name Field
            ApplicationTextfieldView(textFieldType: .fullName,
                              textFieldValue: $fullName,
                              isValid: $isValidFullName)
            .padding(.bottom, 24)
            
            ApplicationTextfieldView(textFieldType: .email,
                              textFieldValue: $email,
                                     isValid: $isValidEmail)
            .padding(.bottom, 24)
            
            ApplicationTextfieldView(textFieldType: .phoneNumber,
                              textFieldValue: $phoneNumber,
                                     isValid: $isValidPhoneNumber)
            .padding(.bottom, 24)

            ApplicationTextfieldView(textFieldType: .createPassword,
                              textFieldValue: $password,
                              isValid: $isValidPassword)
            .padding(.bottom, 24)
            
            ApplicationTextfieldView(textFieldType: .confirmPassword,
                              textFieldValue: $confirmPassword,
                              isValid: $isValidConfirmPassword)
            .padding(.bottom, 16)
            .onSubmit {
                if !isSignupButtonDisabled {
                    submitUserData()
                }
            }

            PasswordValidationWidget(password: password)

            Spacer()

            SignupBottomView(isSignupButtonDisabled: isSignupButtonDisabled) {
                submitUserData()
            }
        }
        .onReceive(handler.$errorMsg) { errorMessage in
            self.error = errorMessage
        }
        .onReceive(handler.$isLoading) { isLoading in
            self.isLoading = isLoading
        }
        .onChange(of: isValidFullName) { _ in
            checkIfFieldsAreValid()
        }
        .onChange(of: isValidEmail) { _ in
            checkIfFieldsAreValid()
        }
        .onChange(of: isValidPassword) { _ in
            checkIfFieldsAreValid()
        }
        .onChange(of: isValidConfirmPassword) { _ in
            checkIfFieldsAreValid()
        }
        .onChange(of: isValidPhoneNumber) { _ in
            checkIfFieldsAreValid()
        }
        .onChange(of: confirmPassword) { _ in
            validateConfirmPassword()
        }
        .onChange(of: password) { _ in
            if !confirmPassword.isEmpty {
                validateConfirmPassword()
            }
        }
    }
}

#Preview {
    EmailAndNewPassWidget(isSignupButtonDisabled: .constant(false),
                          error: .constant(""),
                          isLoading: .constant(false),
                          isLoginActive: .constant(false))
}
