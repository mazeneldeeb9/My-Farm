//
//  PasswordValidationWidget.swift
//  3oon
//
//  Created by mazen eldeeb on 11/02/2025.
//

import SwiftUI

struct PasswordValidationWidget: View {

    // MARK: - Variables
     var password: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ApplicationCheckmarkLabelRowView(password: password,
                                      validationTypeMode: .eightChar)

            ApplicationCheckmarkLabelRowView(password: password,
                                      validationTypeMode: .upperAndLowerCase)

            ApplicationCheckmarkLabelRowView(password: password,
                                      validationTypeMode: .specialChar)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PasswordValidationWidget(password: "")
}
