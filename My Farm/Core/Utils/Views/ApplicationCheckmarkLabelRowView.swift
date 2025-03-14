//
//  ApplicationCheckmarkLabelRowView.swift
//  3oon
//
//  Created by mazen eldeeb on 11/02/2025.
//

import SwiftUI

struct ApplicationCheckmarkLabelRowView: View {

    // MARK: - Variables
    var password: String
    var validationTypeMode: PasswordValidationEnum

    var body: some View {
        HStack(spacing: 8) {

            Image(validationTypeMode.getValidationImage(for: password))
                .animation(.easeInOut(duration: 0.25),
                           value: validationTypeMode.getValidation(password: password))

            Text(validationTypeMode.getValidationText())
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    ApplicationCheckmarkLabelRowView(password: "", validationTypeMode: .eightChar)
}
