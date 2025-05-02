//
//  MarketplaceTabView.swift
//  My Farm
//
//  Created by developer on 27/06/2024.
//

import SwiftUI

struct MarketplaceTabView: View {
    @StateObject private var userManager = UserManager.shared
    @State private var searchText = ""
    @State private var selectedCategory: CropCategory = .all
    @State private var isLoading = true
    
    var filteredCrops: [CropListing] {
        var filtered = userManager.marketplaceCrops
        
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
                
                if isLoading {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .primaryGreen))
                    Spacer()
                } else if filteredCrops.isEmpty {
                    Spacer()
                    Text("No crops available")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    Spacer()
                } else {
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
            }
            .navigationTitle("Marketplace")
            .onAppear {
                loadMarketplaceCrops()
            }
        }
    }
    
    private func loadMarketplaceCrops() {
        isLoading = true
        Task {
            do {
                try await userManager.fetchMarketplaceCrops()
                DispatchQueue.main.async {
                    isLoading = false
                }
            } catch {
                print("Error loading marketplace crops: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    isLoading = false
                }
            }
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
    @State private var cropImage: UIImage? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            // Image placeholder with actual image loading
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(10)
                
                if let image = cropImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width / 2 - 24, height: UIScreen.main.bounds.width / 2 - 24)
                        .cornerRadius(10)
                        .clipped()
                } else {
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.primaryGreen)
                }
            }
            .onAppear {
                loadImage()
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
    
    private func loadImage() {
        // If it's a system image name, use that
        if UIImage(named: crop.image) != nil {
            cropImage = UIImage(named: crop.image)
            return
        }
        
        // Otherwise, try to load from documents directory (for user-uploaded images)
        if crop.image.hasPrefix("crop_") {
            cropImage = UserManager.shared.loadImageFromDocuments(named: crop.image)
            return
        }
    }
}

// Helper function to load images from documents directory
func loadImageFromDocuments(named: String) -> UIImage? {
    let fileManager = FileManager.default
    let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = documentsDirectory.appendingPathComponent(named)
    
    if fileManager.fileExists(atPath: fileURL.path) {
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    return nil
}

struct CropListing: Identifiable {
    let id: UUID
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
