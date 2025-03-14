//
//  ApplicationTextfieldErrorView.swift
//  3oon
//
//  Created by mazen eldeeb on 11/02/2025.
//


import SwiftUI

struct ApplicationTextfieldErrorView: View {

    // MARK: - Constants
    let errorText: String

    var body: some View {
        Text(errorText)
            .font(.system(size: 12))
            .foregroundColor(.error)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ApplicationTextfieldErrorView(errorText: "")
}
