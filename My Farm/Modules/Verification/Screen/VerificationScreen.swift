//
//  VerificationScreen.swift
//  3oon
//
//  Created by mazen eldeeb on 12/02/2025.
//

import SwiftUI

struct VerificationScreen: View {

    // MARK: - State Variables
    @State private var errorMessage = ""
    @State private var isLoading = false

    @Environment(\.presentationMode) var presentationMode

    // MARK: - Variables
    var email: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(Constants.Verification.verifyYourEmail)
                .font(.system(size: 22))
                .fontWeight(.semibold)
                .foregroundColor(.secondaryGreen)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 16)

            Text(Constants.Verification.enterVerificationCode)
                .foregroundColor(.gray)
                .font(.system(size: 18))
                .padding(.bottom, 40)

            OTPWidget(
                      error: $errorMessage,
                      isLoading: $isLoading,
                      phoneNumber: email)
        }
        .padding(.horizontal, 20)
        .overlay {
            ApplicationProgressView(isHidden: !isLoading)
        }
        .overlay(
            ApplicationErrorView(errorMessage: $errorMessage)
        )
        .background(.grayBackground)
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    VerificationScreen(email: "")
}
