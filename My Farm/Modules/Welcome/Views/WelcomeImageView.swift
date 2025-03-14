//
//  WelcomeImageView.swift
//  3oon
//
//  Created by mazen eldeeb on 09/02/2025.
//

import SwiftUI

struct WelcomeImageView: View {

    // MARK: - Constants
    let onBoardingStep: OnBoardingStep

    var body: some View {
        VStack {
            Image(onBoardingStep.image)
                .resizable()
                .scaledToFit()
                .frame(height: 230)

            Text(onBoardingStep.description)
                .bold()
                .font(.system(size: 28))
                .foregroundStyle(.secondaryGreen)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

#Preview {
    WelcomeImageView(onBoardingStep: OnBoardingStep.onboarding.first!)
}
