//
//  AuthTextFieldsWidget+Extension.swift
//  3oon
//
//  Created by mazen eldeeb on 11/02/2025.
//

import Foundation

extension AuthTextFieldsWidget {
    func checkSignInButtonDisabled() {
        isSignInButtonDisabled = !isValidEmail || !isValidPassword
    }
}
