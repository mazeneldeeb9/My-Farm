//
//  AuthTextFieldsWidget.swift
//  3oon
//
//  Created by mazen eldeeb on 11/02/2025.
//

import SwiftUI

struct AuthTextFieldsWidget: View {

    // MARK: - State Variables
    @State var isValidEmail = false
    @State var isValidPassword = false
    @FocusState var focusedField: FocusedTextField?

    // MARK: - Binding Variables
    @Binding var isSignInButtonDisabled: Bool
    @Binding var phoneNumber: String
    @Binding var password: String

    // MARK: - Variables
    var submitButtonAction: (() -> Void)

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ApplicationTextfieldView(textFieldType: .email,
                              textFieldValue: $phoneNumber,
                              isValid: $isValidEmail)
            .padding(.vertical, 24)

            ApplicationTextfieldView(textFieldType: .password, textFieldValue: $password, isValid: $isValidPassword)
                .focused($focusedField, equals: .password)
                .onSubmit {
                    if !isSignInButtonDisabled {
                        submitButtonAction()
                    }
                }
        }
        .onChange(of: isValidEmail) { _ in
            checkSignInButtonDisabled()
        }
        .onChange(of: isValidPassword) { _ in
            checkSignInButtonDisabled()
        }
    }
}

#Preview {
    AuthTextFieldsWidget(isSignInButtonDisabled: .constant(false),
                         phoneNumber: .constant(""),
                         password: .constant("")) {
        print("")
    }
}
