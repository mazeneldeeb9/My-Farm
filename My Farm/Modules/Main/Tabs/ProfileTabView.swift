//
//  ProfileTabView.swift
//  My Farm
//
//  Created by developer on 27/06/2024.
//

import SwiftUI

struct ProfileTabView: View {
    @ObservedObject private var userManager = UserManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile header
                    VStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.primaryGreen)
                        
                        Text(userManager.currentUser?.name ?? "Guest User")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.secondaryGreen)
                        
                        Text(userManager.currentUser?.email ?? "")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 20)
                    
                    // Profile details
                    ApplicationCardView(
                        title: "Account Information",
                        systemImageName: "person.text.rectangle.fill"
                    ) {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Name")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(userManager.currentUser?.name ?? "Not set")
                                    .foregroundColor(.secondaryGreen)
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Email")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(userManager.currentUser?.email ?? "Not set")
                                    .foregroundColor(.secondaryGreen)
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Score")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(userManager.currentUser?.score ?? 0)")
                                    .foregroundColor(.secondaryGreen)
                            }
                        }
                    }
                    
                    // Logout button
                    Button {
                        Task {
                            try? await userManager.logout()
                        }
                    } label: {
                        Text("Logout")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .background(Color.grayBackground)
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileTabView()
}