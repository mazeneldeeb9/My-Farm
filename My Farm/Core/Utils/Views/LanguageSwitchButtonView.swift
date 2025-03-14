//
//  LanguageSwitchButtonView.swift
//  3oon
//
//  Created by mazen eldeeb on 11/02/2025.
//


import SwiftUI
import TZChangeLanguage

struct LanguageSwitchButtonView: View {

    // MARK: - State Variables
    @State private var showLanguageChangeAlert = false

    var body: some View {
        Button {
            showLanguageChangeAlert = true
        } label: {
            HStack {
                Text(Constants.Login.arabic)
                    .font(.system(size: 14))
                    .foregroundColor(.white)

                Image(systemName: "globe")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.primaryGreen)
            }
        }
        .padding(8)
        .background(Color.secondary)
        .cornerRadius(8)
        .changeLanguageAlert(isPresented: $showLanguageChangeAlert)
    }
}

#Preview {
    LanguageSwitchButtonView()
}
