//
//  ApplicationButtonStyle.swift
//  3oon
//
//  Created by mazen eldeeb on 09/02/2025.
//


import SwiftUI

struct ApplicationButtonStyle: ButtonStyle {
    var strokeColor: Color
    var buttonColor: Color
    var minHeight: CGFloat?
    var maxHeight: CGFloat?
    var maxWidth: CGFloat?

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: maxWidth ?? .infinity, minHeight: minHeight ?? 56, maxHeight: maxHeight ?? 58)
            .background(buttonColor)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(strokeColor, lineWidth: 2)
            )
            .cornerRadius(8)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}
