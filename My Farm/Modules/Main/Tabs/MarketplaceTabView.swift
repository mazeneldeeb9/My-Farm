//
//  MarketplaceTabView.swift
//  My Farm
//
//  Created by developer on 27/06/2024.
//

import SwiftUI

struct MarketplaceTabView: View {
    @State private var searchText = ""
    @State private var selectedCategory: CropCategory = .all
    
    // Sample data
    private let cropListings = [
        CropListing(id: 1, name: "Organic Tomatoes", seller: "Green Farms", price: 2.99, image: "tomato", category: .vegetables),
        CropListing(id: 2, name: "Fresh Corn", seller: "Harvest Fields", price: 1.49, image: "corn", category: .vegetables),
        CropListing(id: 3, name: "Premium Wheat", seller: "Golden Grains", price: 3.99, image: "wheat", category: .grains),
        CropListing(id: 4, name: "Russet Potatoes", seller: "Earth Bounty", price: 0.99, image: "potato", category: .vegetables),
        CropListing(id: 5, name: "Organic Apples", seller: "Orchard Fresh", price: 2.49, image: "apple", category: .fruits),
        CropListing(id: 6, name: "Strawberries", seller: "Berry Good", price: 3.99, image: "strawberry", category: .fruits),
        CropListing(id: 7, name: "Barley Seeds", seller: "Seed Master", price: 5.99, image: "barley", category: .seeds),
        CropListing(id: 8, name: "Sunflower Seeds", seller: "Sunny Fields", price: 4.49, image: "sunflower", category: .seeds)
    ]
    
    var filteredCrops: [CropListing] {
        var filtered = cropListings
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        if selectedCategory != .all {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search crops", text: $searchText)
                        .foregroundColor(.primary)
                    
                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Category selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(CropCategory.allCases, id: \.self) { category in
                            CategoryButton(
                                title: category.displayName,
                                isSelected: selectedCategory == category,
                                action: {
                                    selectedCategory = category
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                
                // Crop listings
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(filteredCrops) { crop in
                            CropListingCard(crop: crop)
                        }
                    }
                    .padding()
                }
                .background(Color.grayBackground)
            }
            .navigationTitle("Marketplace")
        }
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.primaryGreen : Color.white)
                .foregroundColor(isSelected ? .white : .gray)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

struct CropListingCard: View {
    let crop: CropListing
    
    var body: some View {
        VStack(alignment: .leading) {
            // Image placeholder (in a real app, you'd use AsyncImage or similar)
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(10)
                
                Image(systemName: "leaf.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.primaryGreen)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(crop.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text("by \(crop.seller)")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                HStack {
                    Text("$\(String(format: "%.2f", crop.price))")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primaryGreen)
                    
                    Spacer()
                    
                    Button {
                        // Add to cart action
                    } label: {
                        Image(systemName: "cart.badge.plus")
                            .foregroundColor(.primaryGreen)
                    }
                }
                .padding(.top, 4)
            }
            .padding(8)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct CropListing: Identifiable {
    let id: Int
    let name: String
    let seller: String
    let price: Double
    let image: String
    let category: CropCategory
}

enum CropCategory: String, CaseIterable {
    case all
    case vegetables
    case fruits
    case grains
    case seeds
    
    var displayName: String {
        switch self {
        case .all: return "All"
        case .vegetables: return "Vegetables"
        case .fruits: return "Fruits"
        case .grains: return "Grains"
        case .seeds: return "Seeds"
        }
    }
}

#Preview {
    MarketplaceTabView()
}