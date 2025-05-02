//
//  EmailAndNewPassWidget+Extension.swift
//  3oon
//
//  Created by Mazen on 11/02/2024.
//


import Foundation

extension EmailAndNewPassWidget {
    func checkIfFieldsAreValid() {
        isSignupButtonDisabled = !isValidFullName || !isValidEmail || !isValidPassword || !isValidPhoneNumber || !isValidConfirmPassword
    }
    
    func validateConfirmPassword() {
        isValidConfirmPassword = !confirmPassword.isEmpty && confirmPassword == password
        if !confirmPassword.isEmpty && confirmPassword != password {
            handler.errorMsg = "Passwords do not match"
        }
    }

    func submitUserData() {
        // Validate passwords match
        if password != confirmPassword {
            handler.errorMsg = "Passwords do not match"
            return
        }
        
        // Set loading state
        handler.isLoading = true
        
        // Create user with UserManager
        Task {
            do {
                try await UserManager.shared.createUser(
                    email: email,
                    password: password,
                    name: fullName,
                    phoneNumber: phoneNumber
                )
                
                // Handle success
                DispatchQueue.main.async {
                    self.handler.isLoading = false
                    self.isLoginActive = true // Navigate to the next screen
                }
            } catch let error as UserCreationError {
                // Handle specific user creation errors
                DispatchQueue.main.async {
                    self.handler.isLoading = false
                    self.handler.errorMsg = error.localizedDescription
                }
            } catch {
                // Handle generic errors
                DispatchQueue.main.async {
                    self.handler.isLoading = false
                    self.handler.errorMsg = "حدث خطأ أثناء إنشاء الحساب. يرجى المحاولة مرة أخرى."
                }
            }
        }
    }
}
