//
//  WelcomeTabInfo.swift
//  3oon
//
//  Created by mazen eldeeb on 09/02/2025.
//

import Foundation

struct OnBoardingStep: Identifiable {
    let id = UUID()
    let image: String
    let description: String

    static let onboarding: [OnBoardingStep] = [
        OnBoardingStep(image: Constants.onboardingIcons.firstOnboarding, description: Constants.OnBoarding.firstWelcome),
        OnBoardingStep(image: Constants.onboardingIcons.secondOnboarding, description: Constants.OnBoarding.secondWelcome),
        OnBoardingStep(image: Constants.onboardingIcons.thirdOnboarding, description: Constants.OnBoarding.thirdWelcome)
    ]
}
