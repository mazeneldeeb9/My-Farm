//
//  WelcomeScreen+Extension.swift
//  3oon
//
//  Created by mazen eldeeb on 11/02/2025.
//

import Foundation

extension WelcomeScreen {
    func getButtonText() -> String {
        currentIndex == (OnBoardingStep.onboarding.count - 1) ? Constants.OnBoarding.signin : Constants.OnBoarding.next
    }
}
