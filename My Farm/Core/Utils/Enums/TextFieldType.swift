//
//  TextFieldType.swift
//  3oon
//
//  Created by mazen eldeeb on 11/02/2025.
//


import Foundation
import SwiftUI

enum TextFieldType {

    case email
    case password, createPassword
    case ai

    func getTextFieldTrailingIcon(isSecureField: Bool = false) -> String {
        switch self {
        case .password, .createPassword:
            return isSecureField ? Constants.TextFieldIcons.hidePasswordIcon : Constants.TextFieldIcons.showPasswordIcon
        default:
            return ""
        }
    }

    func getTextFieldInputType() -> UIKeyboardType {
        switch self {
        case .email:
            return .emailAddress
        default:
            return .default
        }
    }

    func passwordFieldTypeCheck() -> Bool {
        switch self {
        case .password, .createPassword:
            return true
        default:
            return false
        }
    }

    func getTextFieldTitle() -> String {
        switch self {
        case .password:
            return Constants.TextField.passwordTitle
        case .createPassword:
            return Constants.TextField.createPasswordTitle
        case .email:
            return Constants.TextField.emailTitle
        default:
            return ""
        }
    }

    func getTextFieldPlaceholder() -> String {
        switch self {
        case .password, .createPassword:
            return Constants.TextField.passwordPlaceholder
        case .email:
            return Constants.TextField.emailPlaceholder
        case .ai:
            return Constants.Home.askNow
        }
    }

    func getTextFieldValidations(text: String,
                                 isFieldRequired: Bool) -> String {
        if !isFieldRequired && text.isEmpty {
            return ""
        }
        switch self {
        case .email:
            return text.trimmed.isValidEmail ? "" : Constants.TextField.invalidEmail
        case .password, .createPassword:
            return text.isValidStrongPassword ? "" : Constants.TextField.invalidPassword
        case .ai:
            return text.isEmpty ? "" : Constants.TextField.emptyField
        }
    }

    func getSubmitLabel() -> SubmitLabel {
        switch self {
        case .email:
            return .next
        default:
            return .done
        }
    }

    func getTextContentType() -> UITextContentType? {
        switch self {
        case .email:
            return .emailAddress
        case .password, .createPassword:
            return .password
        case .ai:
            return nil
        }
    }
}
