//
//  OTPWidget.swift
//  3oon
//
//  Created by mazen eldeeb on 12/02/2025.
//


import SwiftUI
import TrianglzOTPView

struct OTPWidget: View {


    // MARK: - private constants
    private let textFieldCount = 4
    private let cornerRadius: CGFloat = 8
    private let hstackSpacing: CGFloat = 24
    private let otpDiemnsion: CGFloat = 66
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // MARK: - state variables
    @State var timeRemaining = 60
    @State var isTimerHidden = false
    @State var verificationCode = ""
    @State private var shouldDismissKeyboard = false

    // MARK: - Binding Variables
    @Binding var error: String
    @Binding var isLoading: Bool

    // MARK: - Variables
    var phoneNumber: String

    // MARK: - Computed Variables
    var isValidVerificationCode: Bool {
        verificationCode.count == 4
    }

    var body: some View {
        VStack(spacing: 0) {
            TrianglzOTPView(textFieldCount: textFieldCount,
                            customStyle: TrianglzOTPView.Style(foregroundColor: .secondaryGreen,
                                                               fontStyle:.systemFont(ofSize: 24, weight: .bold),
                                                               hstackSpacing: hstackSpacing,
                                                               hstackAlignment: .center,
                                                               borderColor: .primaryGreen,
                                                               width: otpDiemnsion,
                                                               height: otpDiemnsion,
                                                               backgroundColor: .white,
                                                               cornerRadius: cornerRadius,
                                                               borderWidth: 1.6,
                                                               isCursorHidden: false,
                                                               focusedStateColor: .secondaryGreen),
                            onChangeCallback: { changedText in verificationCode = changedText },
                            onCompleteCallback: onOTPComplete,
                            shouldDismissKeyboard: $shouldDismissKeyboard)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 24)

            HStack(spacing: 0) {
                Text(Constants.Verification.didntReceiveCode)
                    .font(.system(size: 16))
                    .foregroundColor(.gray)

                Button {
                    handleResendTap()
                } label: {
                    Text(Constants.Verification.resend)
                        .foregroundColor(.secondaryGreen)
                        .font(.system(size: 16))
                }
            }
            .isHidden(!isTimerHidden, remove: true)
            .frame(maxWidth: .infinity, alignment: .center)

            Text(getTimerText())
                .font(.system(size: 16))
                .foregroundColor(.grayBackground)
                .isHidden(isTimerHidden, remove: true)
                .frame(maxWidth: .infinity, alignment: .center)
                .onReceive(timer) { _ in
                    if !isTimerHidden {
                        handleDecrementingTimer()
                    }
                }

            Spacer()

            ApplicationButton(buttonText: Constants.Verification.verify,
                           isButtonDisabled: !isValidVerificationCode,
                           buttonAction: verifyCode)
                .padding(.bottom, 26)
        }
        .onAppear {
            handleTimer()
        }
    }
}

#Preview {
    OTPWidget(
        error: .constant(""),
        isLoading: .constant(false),
        phoneNumber: "")
}
