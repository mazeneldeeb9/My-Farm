//
//  WelcomeScreen.swift
//  3oon
//
//  Created by mazen eldeeb on 09/02/2025.
//

import SwiftUI

struct WelcomeScreen: View {

    // MARK: - State Variables
    @State var currentIndex = 0
    @State var navToSignIn = false
    @State var navToSignUp: Bool = false
    @State private var messageResponse: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            LanguageSwitchButtonView()
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 12)
    
            TabView(selection: $currentIndex) {
                ForEach(0..<OnBoardingStep.onboarding.count, id: \.self) { index in
                    WelcomeImageView(onBoardingStep: OnBoardingStep.onboarding[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

            Spacer()

            ApplicationButton(buttonText: getButtonText(), isButtonDisabled: false) {
                if currentIndex == OnBoardingStep.onboarding.count - 1 {
                    navToSignIn = true
                } else {
                    currentIndex += 1
                }
            }
            .padding(.bottom, 12)

            HStack(spacing: 0) {
                Text("\(Constants.OnBoarding.newHere) \(Constants.OnBoarding.welcomeAbroad) ")
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
                Button {
                    navToSignUp = true
                } label: {
                    Text("\(Constants.OnBoarding.signUpNow)")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondaryGreen)
                        .bold()
                }
            }
            .padding(.bottom, 32)
        }
        .padding(.horizontal, 16)
        .background(Color.grayBackground)
        .navigationDestination(isPresented: $navToSignIn) {
            SignInScreen()
                .toolbarRole(.editor)
        }
        .navigationDestination(isPresented: $navToSignUp) {
            SignupScreen(isLoginActive: .constant(true))
                .toolbarRole(.editor)
        }
    }
}

#Preview {
    WelcomeScreen()
}
