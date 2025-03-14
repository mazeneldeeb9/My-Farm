//
//  FavoritesTabView.swift
//  My Farm
//
//  Created by developer on 27/06/2024.
//

import SwiftUI

struct FavoritesTabView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if true { // Replace with actual condition
                        Text("No favorites yet")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 100)
                    } else {
                        // Favorites content here
                        Text("Your favorites will appear here")
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .background(Color.grayBackground)
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesTabView()
}