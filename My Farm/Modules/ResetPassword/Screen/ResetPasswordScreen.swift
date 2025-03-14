//
//  ResetPasswordScreen.swift
//  TCaptain
//
//  Created by OS on 27/06/2024.
//

import SwiftUI

struct ResetPasswordScreen: View {

    // MARK: State variables
    @State private var errorMessage = ""
    @State private var isLoading = false

    // MARK: - Binding Variables
    @Binding var isLoginActive: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(Constants.ResetPassword.resetPassword)
                .font(.system(size: 22))
                .fontWeight(.semibold)
                .foregroundColor(.primaryGreen)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 16)

            Text(Constants.ResetPassword.enterYourEmail)
                .foregroundColor(.gray)
                .font(.system(size: 18))

            ResetPasswordWidget(isLoginActive: $isLoginActive,
                                error: $errorMessage,
                                isLoading: $isLoading)
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

#Preview {
    ResetPasswordScreen(isLoginActive: .constant(false))
}
