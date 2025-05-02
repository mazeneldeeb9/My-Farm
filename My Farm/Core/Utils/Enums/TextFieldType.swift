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
    case password, createPassword, confirmPassword
    case fullName
    case phoneNumber
    

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
        case .phoneNumber:
            return .phonePad
        default:
            return .default
        }
    }

    func getTextFieldTitle() -> String {
        switch self {
        case .password:
            return Constants.TextField.passwordTitle
        case .createPassword:
            return Constants.TextField.createPasswordTitle
        case .confirmPassword:
            return Constants.TextField.confirmPasswordTitle
        case .email:
            return Constants.TextField.emailTitle
        case .fullName:
            return Constants.TextField.fullName
        case .phoneNumber:
            return Constants.TextField.phoneNumber
        default:
            return ""
        }
    }

    func getTextFieldPlaceholder() -> String {
        switch self {
        case .password, .createPassword:
            return Constants.TextField.passwordPlaceholder
        case .confirmPassword:
            return Constants.TextField.confirmPasswordPlaceholder
        case .email:
            return Constants.TextField.emailPlaceholder
        case .fullName:
            return Constants.TextField.fullNamePlaceholder
        case .phoneNumber:
            return Constants.TextField.phoneNumberPlaceholder
        }
    }

    func passwordFieldTypeCheck() -> Bool {
        switch self {
        case .password, .createPassword, .confirmPassword:
            return true
        default:
            return false
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
        case .fullName:
            return !text.isEmpty ? "" : Constants.TextField.invalidFullName
        case .phoneNumber:
            return text.count >= 10 ? "" : Constants.TextField.invalidPhoneNumber
        default:
            return ""
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
        case .password, .createPassword, .confirmPassword:
            return .password
        case .fullName:
            return .name
        case .phoneNumber:
            return .telephoneNumber
        }
    }
}
