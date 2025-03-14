//
//  ApplicationTextfieldView+Extension.swift
//  3oon
//
//  Created by mazen eldeeb on 11/02/2025.
//

import Foundation
import SwiftUI

extension ApplicationTextfieldView {

    func checkForValidations() {
        alertMessage = textFieldType.getTextFieldValidations(text: textFieldValue, isFieldRequired: isRequired)
        print(alertMessage)
        isValid = alertMessage.isEmpty
    }

    func getBorderColor(isEmpty: Bool) -> Color {
        if isEmpty || isValid {
            return isFocused ? .secondaryGreen : .primaryGreen
        } else {
            return .error
        }
    }

    func enableSecurePasswordField() {
        if textFieldType.passwordFieldTypeCheck() {
            isSecureField = true
        }
    }

    func updateTextFieldState(isEmpty: Bool) {
        emptyTextField = isEmpty
      }
}
