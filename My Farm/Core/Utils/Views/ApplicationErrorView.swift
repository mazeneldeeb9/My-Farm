//
//  ApplicationErrorView.swift
//  3oon
//
//  Created by mazen eldeeb on 11/02/2025.
//


import SwiftUI

struct ApplicationErrorView: View {

    // MARK: - Binding Variables
    @Binding var errorMessage: String

    // MARK: - Variables
    var isWarning = false

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text(errorMessage)
                    .font(.system(size: 14))
                    .foregroundColor(.secondaryGreen)

                Spacer()
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(.errorLow)
            .cornerRadius(8)
            .padding(.top, 8)

            Spacer()
        }
        .padding(.horizontal, 20)
        .isHidden(errorMessage.isEmpty, remove: true)
        .onChange(of: errorMessage) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.errorMessage = ""
                }
            }
        }
    }
}

#Preview {
    ApplicationErrorView(errorMessage: .constant(""))
}
