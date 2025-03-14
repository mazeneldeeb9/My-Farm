//
//  SignupScreen.swift
//  TCaptain
//
//  Created by Aya  on 07/07/2024.
//

import SwiftUI

struct SignupScreen: View {

    // MARK: State variables
    @State private var isSignupButtonDisabled = true
    @State private var errorMessage = ""
    @State private var isLoading = false

    // MARK: - Binding Variables
    @Binding var isLoginActive: Bool

    var body: some View {
        VerticalScrollView {
            VStack(spacing: 0) {

                LanguageSwitchButtonView()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.top, 4)


                EmailAndNewPassWidget(isSignupButtonDisabled: $isSignupButtonDisabled,
                                      error: $errorMessage,
                                      isLoading: $isLoading,
                                      isLoginActive: $isLoginActive)

                Spacer()
            }
            .padding(.horizontal, 20)
            .overlay {
                ApplicationProgressView(isHidden: !isLoading)
            }
            .overlay(
                ApplicationErrorView(errorMessage: $errorMessage)
            )
            .background(Color.grayBackground.ignoresSafeArea())
        }
    }
}

#Preview {
    SignupScreen(isLoginActive: .constant(false))
}
