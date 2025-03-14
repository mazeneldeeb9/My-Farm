//
//  PasswordValidationEnum.swift
//  3oon
//
//  Created by mazen eldeeb on 11/02/2025.
//

import SwiftUI

enum PasswordValidationEnum {
    case eightChar
    case upperAndLowerCase
    case specialChar

    func getValidationText() -> String {
        switch self {
        case .eightChar:
            return Constants.ChangePassword.atLeastEightChar
        case .upperAndLowerCase:
            return Constants.ChangePassword.upperAndLowerCase
        case .specialChar:
            return Constants.ChangePassword.specialCharacter
        }
    }

    func getValidation(password: String) -> Bool {
        switch self {
        case .eightChar:
            return password.isMoreThanEightChar
        case .upperAndLowerCase:
            return password.isUpperAndLowerCase
        case .specialChar:
            return password.isSpecialChar
        }
    }

    func getValidationImage(for password: String) -> String {
        if getValidation(password: password) {
            return Constants.ChangePasswordIcons.greenChecked
        } else {
            return Constants.ChangePasswordIcons.unchecked
        }
    }

    func getValidationColor(for password: String) -> Color {
        if getValidation(password: password) {
            return .lightGreen
        } else {
            return .grayBackground
        }
    }
}
