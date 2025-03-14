//
//  OTPWidget+Extension.swift
//  3oon
//
//  Created by mazen eldeeb on 12/02/2025.
//

import SwiftUI

extension OTPWidget {

    func getTimerText() -> String {
        "\(Constants.Verification.resendIn) \(String(timeRemaining))"
    }

    func onOTPComplete(_ otp: String) {
        verificationCode = otp
    }

    func setupIsTimerHidden(isHidden: Bool) {
        withAnimation {
            isTimerHidden = isHidden
        }
    }

    func handleDecrementingTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            setupIsTimerHidden(isHidden: true)
        }
    }

    func handleTimer() {
        timeRemaining = 60
        setupIsTimerHidden(isHidden: false)
    }

    func handleResendTap() {
    }

    func verifyCode() {
    }
}
