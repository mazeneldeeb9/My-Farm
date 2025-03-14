//
//  ApplicationProgressView.swift
//  3oon
//
//  Created by mazen eldeeb on 11/02/2025.
//


import SwiftUI

struct ApplicationProgressView: View {

    var isHidden: Bool

    var body: some View {
        ProgressView().isHidden(isHidden, remove: true)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    ApplicationProgressView(isHidden: false)
}
