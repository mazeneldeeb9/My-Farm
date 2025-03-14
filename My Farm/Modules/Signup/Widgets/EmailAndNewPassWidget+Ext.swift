//
//  EmailAndNewPassWidget+Extension.swift
//  3oon
//
//  Created by Mazen on 11/02/2024.
//


import Foundation

extension EmailAndNewPassWidget {
    func checkIfFieldsAreValid() {
        isSignupButtonDisabled = !isValidEmail || !isValidPassword
    }

    func submitCaptainData() {
    }
}
