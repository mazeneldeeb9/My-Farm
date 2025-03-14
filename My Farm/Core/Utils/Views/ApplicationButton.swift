//
//  ApplicationButton.swift
//  3oon
//
//  Created by mazen eldeeb on 09/02/2025.
//

import SwiftUI

struct ApplicationButton: View {

    var buttonText: String
    var isButtonDisabled: Bool
    var fontSize: CGFloat = 16
    var leadingIcon: String?
    var trailingIcon: String?
    var iconSize: CGFloat = 0
    var textColor: Color = .white
    var strokeColor: Color = .clear
    var horizontalPadding: CGFloat = 16
    var verticalPadding: CGFloat = 8
    var maxWidth: CGFloat = .infinity
    var buttonColor: Color = .secondaryGreen
    var buttonAction: (() -> Void)

    var body: some View {
        Button (action: buttonAction) {
            Text(buttonText)
                .fontWeight(.bold)
                .font(.system(size: fontSize))
                .foregroundStyle(textColor)
                .frame(maxWidth: maxWidth)
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .padding(.horizontal, 20)
        }
        .buttonStyle(ApplicationButtonStyle(strokeColor: strokeColor,
                                           buttonColor: buttonColor,
                                           maxWidth: maxWidth))
        .disabled(isButtonDisabled)

    }
}
