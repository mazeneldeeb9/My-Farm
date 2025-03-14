//
//  SignInBottomView.swift
//  3oon
//
//  Created by mazen eldeeb on 11/02/2025.
//

import SwiftUI

struct SignInBottomView: View {

    // MARK: - Binding Variables
    @Binding var isLoginActive: Bool

    // MARK: - Variables
    var isSignInButtonDisabled: Bool
    var signInButtonAction: () -> Void

    // MARK: - State Variables
    @State private var navToSignUp = false
    @State private var navToHome = false

    var body: some View {
        VStack(spacing: 0) {
            ApplicationButton(buttonText: Constants.Login.signInButtonText,
                              isButtonDisabled: isSignInButtonDisabled) {
                navToHome = true
            }
                           .padding(.bottom, 20)

            HStack(spacing: 0) {
                Text("\(Constants.Login.dontHaveAcc) ")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)

                Button {
                    navToSignUp = true
                } label: {
                    Text(Constants.Login.signUpButtonText)
                        .font(.system(size: 16))
                        .foregroundColor(Color.primaryGreen)
                }
            }
            .padding(.bottom, 26)
        }
        .navigationDestination(isPresented: $navToSignUp) {
            SignupScreen(isLoginActive: $navToSignUp).toolbarRole(.editor)
        }
        .navigationDestination(isPresented: $navToHome) {
           
        }
    }
}

#Preview {
    SignInBottomView(isLoginActive: .constant(false), isSignInButtonDisabled: false) {
        print(" ")
    }
}
