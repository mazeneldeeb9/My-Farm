//
//  SettingsTabView.swift
//  My Farm
//
//  Created by developer on 27/06/2024.
//

import SwiftUI

struct SettingsTabView: View {
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var language = "English"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ApplicationCardView(
                        title: "Appearance",
                        systemImageName: "paintbrush.fill"
                    ) {
                        VStack(spacing: 12) {
                            Toggle("Dark Mode", isOn: $darkModeEnabled)
                                .toggleStyle(SwitchToggleStyle(tint: .primaryGreen))
                        }
                    }
                    
                    ApplicationCardView(
                        title: "Notifications",
                        systemImageName: "bell.fill"
                    ) {
                        VStack(spacing: 12) {
                            Toggle("Enable Notifications", isOn: $notificationsEnabled)
                                .toggleStyle(SwitchToggleStyle(tint: .primaryGreen))
                        }
                    }
                    
                    ApplicationCardView(
                        title: "Language",
                        systemImageName: "globe"
                    ) {
                        VStack(alignment: .leading, spacing: 12) {
                            Picker("Select Language", selection: $language) {
                                Text("English").tag("English")
                                Text("Arabic").tag("Arabic")
                            }
                            .pickerStyle(MenuPickerStyle())
                            .foregroundColor(.secondaryGreen)
                        }
                    }
                    
                    ApplicationCardView(
                        title: "About",
                        systemImageName: "info.circle.fill"
                    ) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Version")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("1.0.0")
                                    .foregroundColor(.secondaryGreen)
                            }
                            
                            Divider()
                            
                            Button {
                                // Action
                            } label: {
                                Text("Privacy Policy")
                                    .foregroundColor(.secondaryGreen)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            Divider()
                            
                            Button {
                                // Action
                            } label: {
                                Text("Terms of Service")
                                    .foregroundColor(.secondaryGreen)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .background(Color.grayBackground)
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsTabView()
}