//
//  ResetPasswordWidget.swift
//  3oon
//
//  Created by OS on 11/02/2025.
//

import SwiftUI

struct ResetPasswordWidget: View {

    @Environment(\.presentationMode) var presentationMode

    // MARK: - StateObject var
    @StateObject var handler = Handler()

    // MARK: - State Variables
    @State var email = ""
    @State var isValidEmail = false
    @State var navToVerificationScreen = false

    // MARK: Binding
    @Binding var isLoginActive: Bool
    @Binding var error: String
    @Binding var isLoading: Bool
    
    // MARK: - Computed Variables
    var isSendOTPButtonDisabled: Bool {
        !isValidEmail
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {

            ApplicationTextfieldView(textFieldType: .email,
                                     textFieldValue: $email,
                              isValid: $isValidEmail)
                .padding(.vertical, 24)

            Spacer()

            ApplicationButton(
                buttonText: Constants.ResetPassword.sendOTP,
                isButtonDisabled: !isValidEmail,
                buttonAction: resetPasswordAction)
            .padding(.bottom, 20)

            HStack(spacing: 0) {
                Text("\(Constants.ResetPassword.rememberedPassword) ")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)

                Button {
                    presentationMode.wrappedValue.dismiss()
                }  label: {
                    Text(Constants.ResetPassword.signIn)
                        .font(.system(size: 16))
                        .foregroundColor(.primaryGreen)
                }
            }
            .padding(.bottom, 26)
        }
        .onReceive(handler.$errorMsg) { errorMessage in
            self.error = errorMessage
        }
        .onReceive(handler.$isLoading) { isLoading in
            self.isLoading = isLoading
        }
        .navigationTitle("")
        .navigationDestination(isPresented: $navToVerificationScreen) {
            VerificationScreen(email: email)
        }
    }
}

#Preview {
    ResetPasswordWidget(isLoginActive: .constant(false),
                        error: .constant(""),
                        isLoading: .constant(false))
}
