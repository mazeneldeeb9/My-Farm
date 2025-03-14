//
//  SignInScreen.swift
//  3oon
//
//  Created by mazen eldeeb on 11/02/2025.
//

import SwiftUI
import TZChangeLanguage

struct SignInScreen: View {

    // MARK: State variables
    @State private var errorMessage = ""
    @State private var isLoading = false

    var body: some View {
        VerticalScrollView {
            VStack(alignment: .center, spacing: 0) {

                LanguageSwitchButtonView()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.top, 12)

                WelcomeImageView(onBoardingStep: OnBoardingStep(image: Constants.LoginIcons.loginVector, description: Constants.Login.welcome))

                SignInWidget(error: $errorMessage,
                             isLoading: $isLoading)
            }
            .padding(.horizontal, 20)
            .overlay(
                ApplicationErrorView(errorMessage: $errorMessage)
            )
            .overlay(
                ApplicationProgressView(isHidden: !isLoading)
            )
            .navigationTitle("")
            .navigationBarBackButtonHidden(true)
            .background(Color.grayBackground.ignoresSafeArea())
        }
    }
}
