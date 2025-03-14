//
//  ApplicationTextfieldView.swift
//  3oon
//
//  Created by mazen eldeeb on 11/02/2025.
//

import SwiftUI

struct ApplicationTextfieldView: View {

    // MARK: - Constants
    let textFieldType: TextFieldType

    // MARK: - State Variables
    @FocusState var isFocused: Bool
    @State var isSecureField: Bool = false
    @State var alertMessage = ""
    @State var emptyTextField = true
    @State var isTextFieldDisabled: Bool = false
    @State var isCountriesScreenPresented = false

    // MARK: - Binding Variables
    @Binding var textFieldValue: String
    @Binding var isValid: Bool

    // MARK: - Variables
    var isRequired: Bool = true
    var trailingButtonAction: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 0) {
                Text(textFieldType.getTextFieldTitle())
                    .foregroundColor(Color.secondaryGreen)
                    .font(.system(size: 14))
                    .isHidden(textFieldType.getTextFieldTitle().isEmpty, remove: true)

                Text(Constants.TextField.optionalFileds)
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .isHidden(isRequired, remove: true)
            }

            HStack {
                ZStack {
                    Text(textFieldType.getTextFieldPlaceholder())
                        .font(.system(size: 14))
                        .foregroundColor(Color.secondaryGreen).opacity(0.6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .opacity(isFocused || !emptyTextField ? 0 : 1)

                    Group {
                        SecureField("",
                                    text: $textFieldValue)
                        .isHidden(!isSecureField,
                                  remove: true)
                        TextField("",
                                  text: $textFieldValue)
                        .disabled(isTextFieldDisabled)
                        .isHidden(isSecureField, remove: true)
                    }
                    .foregroundColor(Color.secondaryGreen)
                    .submitLabel(textFieldType.getSubmitLabel())
                    .focused($isFocused)
                    .keyboardType(textFieldType.getTextFieldInputType())
                    .textContentType(textFieldType.getTextContentType())
                }

                Button {
                    if textFieldType.passwordFieldTypeCheck() {
                        isSecureField.toggle()
                    } else {
                        trailingButtonAction?()
                    }
                } label: {
                    Image(systemName: textFieldType.getTextFieldTrailingIcon(isSecureField: isSecureField))
                        .foregroundStyle(.primaryGreen)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(getBorderColor(isEmpty: emptyTextField), lineWidth: 1)
            )
            .onTapGesture {
                trailingButtonAction?()
            }
            ApplicationTextfieldErrorView(errorText: alertMessage)
                .padding(.top, 8)
                .isHidden(alertMessage.isEmpty || emptyTextField, remove: true)
        }
        .onAppear {
            enableSecurePasswordField()
            updateTextFieldState(isEmpty: textFieldValue.isEmpty)
            checkForValidations()
        }
        .onChange(of: textFieldValue) { textValue in
            withAnimation {
                checkForValidations()
                updateTextFieldState(isEmpty: textValue.isEmpty)
            }
        }
    }
}

#Preview {
    ApplicationTextfieldView(textFieldType: .email,
                      textFieldValue: .constant(""),
                      isValid: .constant(true))
}
