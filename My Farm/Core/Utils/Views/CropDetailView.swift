//
//  CropDetailView.swift
//  My Farm
//
//  Created by developer on 16/02/2025.
//

import SwiftUI

struct CropDetailView: View {
    // MARK: - Properties
    let crop: Crop
    @Binding var isShowingDetail: Bool
    @State private var scrollOffset: CGFloat = 0
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            // Background
            Color.grayBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Hero image with parallax effect
                    GeometryReader { geometry in
                        let minY = geometry.frame(in: .global).minY
                        let height = geometry.size.height
                        let offset = min(0, -minY)
                        
                        Image(crop.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: height + (minY > 0 ? minY : 0))
                            .clipped()
                            .offset(y: minY > 0 ? -minY : 0)
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                            .overlay(
                                VStack {
                                    Spacer()
                                    Text(crop.name)
                                        .font(.system(size: 36))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.bottom, 20)
                                        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                                }
                                .padding(.horizontal)
                            )
                    }
                    .frame(height: 400)
                    
                    // Content
                    VStack(alignment: .leading, spacing: 20) {
                        // Description
                        Text(crop.description)
                            .font(.system(size: 16))
                            .foregroundColor(.secondaryGreen)
                            .padding(.top, 20)
                        
                        // Growing information
                        infoSection(title: "Growing Information", items: [
                            ("Growth Period", String(format: "%.2f", crop.growthProgress), "calendar"),
                            ("Water Requirements", crop.wateringFrequency, "drop.fill"),
                            ("Sun Requirements", crop.sunExposure, "sun.max.fill"),
                            ("Soil Type", crop.soilType, "leaf.fill"),
                            ("Harvest Time", crop.harvestTime, "scissors")
                        ])
                        
                        // Tips
                        ApplicationCardView(
                            title: "Growing Tips",
                            systemImageName: "lightbulb.fill",
                            imageColor: .yellow
                        ) {
                            Text(crop.idealTemperature)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                        }
                        
                        // Add to my garden button
                        ApplicationButton(
                            buttonText: "Add to My Garden",
                            isButtonDisabled: false,
                            leadingIcon: "plus.circle.fill"
                        ) {
                            // Action to add crop to garden
                        }
                        .padding(.vertical, 20)
                    }
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
                            .offset(y: -30)
                    )
                    .offset(y: -30)
                }
            }
            .ignoresSafeArea(edges: .top)
            .coordinateSpace(name: "scroll")
            
            // Back button
            Button(action: {
                withAnimation(.spring()) {
                    isShowingDetail = false
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Circle().fill(Color.black.opacity(0.4)))
            }
            .padding(.top, 60)
            .padding(.leading, 20)
            .zIndex(1)
        }
        .navigationBarHidden(true)
        .statusBar(hidden: true)
    }
    
    // MARK: - Info Section
    private func infoSection(title: String, items: [(String, String, String)]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(.secondaryGreen)
            
            ForEach(items, id: \.0) { item in
                HStack(spacing: 15) {
                    Image(systemName: item.2)
                        .foregroundColor(.primaryGreen)
                        .frame(width: 24, height: 24)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.0)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Text(item.1)
                            .font(.system(size: 16))
                            .foregroundColor(.secondaryGreen)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

// MARK: - Preview
#Preview {
    CropDetailView(
        crop: Crop.sampleCrops[0],
        isShowingDetail: .constant(true)
    )
} 
