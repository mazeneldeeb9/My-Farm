//
//  MyFarm.swift
//  3oon
//
//  Created by mazen eldeeb on 09/02/2025.
//

import SwiftUI
import IQKeyboardManagerSwift

@main
struct My_FarmApp: App {
    @State private var isUserLoggedIn: Bool = UserManager.shared.currentUser != nil
    
    init() {
        setUpKeyboard()
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.secondaryGreen
        ]
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.backgroundColor = UIColor.clear
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isUserLoggedIn {
                    MainScreen()
                        .onReceive(NotificationCenter.default.publisher(for: .userLoggedOut)) { _ in
                            isUserLoggedIn = false
                        }
                } else {
                    NavigationStack {
                        WelcomeScreen()
                    }
                    .onReceive(NotificationCenter.default.publisher(for: .userLoggedIn)) { _ in
                        isUserLoggedIn = true
                    }
                }
            }
            .background(.primaryGreen)
            .tint(.secondaryGreen)
        }
    }
    
    @MainActor
    private func setUpKeyboard() {
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.resignOnTouchOutside = true
    }
}

// Add notification extensions
extension Notification.Name {
    static let userLoggedIn = Notification.Name("userLoggedIn")
    static let userLoggedOut = Notification.Name("userLoggedOut")
}
