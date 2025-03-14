//
//  SignInWidget.swift
//  3oon
//
//  Created by mazen eldeeb on 11/02/2025.
//


//
//  SignInWidget.swift
//  TCaptain
//
//  Created by OS on 27/06/2024.
//

import SwiftUI

struct SignInWidget: View {

    // MARK: - State Variables
    @State var isSignInButtonDisabled = true
    @State var email = ""
    @State var password = ""
    @State var isLoginActive = false

    // MARK: Binding
    @Binding var error: String
    @Binding var isLoading: Bool

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            AuthTextFieldsWidget(isSignInButtonDisabled: $isSignInButtonDisabled,
                                 phoneNumber: $email,
                                 password: $password) {
            }

            Button {
                  isLoginActive = true
                }
              label: {
                  Text(Constants.Login.forgotPassText)
                      .font(.system(size: 14))
                      .foregroundColor(.primaryGreen)
                    .padding(.top, 16)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)

            Spacer()

            SignInBottomView(isLoginActive: $isLoginActive, isSignInButtonDisabled: isSignInButtonDisabled) {
            }
        }
        .navigationDestination(isPresented: $isLoginActive) {
            ResetPasswordScreen(isLoginActive: $isLoginActive)
                .toolbarRole(.editor)
        }
    }
}

#Preview {
    SignInWidget(error: .constant(""),
                 isLoading: .constant(false))
}
