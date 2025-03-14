//
//  SignupBottomView.swift
//  3oon
//
//  Created by Mazen  on 11/02/2025.
//

import SwiftUI

struct SignupBottomView: View {

  // MARK: - Environment
    @Environment(\.presentationMode) var presentationMode

    // MARK: - Variables
    var isSignupButtonDisabled: Bool
    var submitButtonAction: (() -> Void)

    var body: some View {
        VStack(spacing: 20) {
            ApplicationButton(buttonText: Constants.Login.signUpButtonText,
                           isButtonDisabled: isSignupButtonDisabled,
                           buttonAction: submitButtonAction)

            HStack(spacing: 0) {
                Text("\(Constants.Signup.alreadyHaveAcc) ")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)

                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text(Constants.Login.signInButtonText)
                        .font(.system(size: 16))
                        .foregroundColor(.primaryGreen)
                }
            }.padding(.bottom, 26)
        }
    }
}

#Preview {

    SignupBottomView(isSignupButtonDisabled: true) {
        print("")
    }
}
