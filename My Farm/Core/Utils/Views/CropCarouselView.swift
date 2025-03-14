//
//  CropCarouselView.swift
//  My Farm
//
//  Created by developer on 16/02/2025.
//

import SwiftUI

struct CropCarouselView: View {
    // MARK: - Properties
    let crops: [Crop]
    @Binding var selectedCropIndex: Int
    @Binding var isShowingDetail: Bool
    
    // MARK: - UI Properties
    private let itemWidth: CGFloat = 200
    private let spacing: CGFloat = 20
    private let scaleFactor: CGFloat = 0.8
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.grayBackground.ignoresSafeArea()
            
            VStack {
                Text("Select a Crop")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.secondaryGreen)
                    .padding(.top, 20)
                
                GeometryReader { geometry in
                    let totalWidth = geometry.size.width
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: spacing) {
                            ForEach(crops.indices, id: \.self) { index in
                                cropCard(for: crops[index], index: index, totalWidth: totalWidth)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            selectedCropIndex = index
                                            isShowingDetail = true
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, (totalWidth - itemWidth) / 2)
                    }
                    .content.offset(x: CGFloat(selectedCropIndex) * -(itemWidth + spacing))
                    .scrollDisabled(true)
                }
                
                // Pagination dots
                HStack(spacing: 8) {
                    ForEach(crops.indices, id: \.self) { index in
                        Circle()
                            .fill(index == selectedCropIndex ? Color.primaryGreen : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 20)
                
                // Navigation buttons
                HStack(spacing: 40) {
                    Button(action: {
                        withAnimation(.spring()) {
                            selectedCropIndex = max(0, selectedCropIndex - 1)
                        }
                    }) {
                        Image(systemName: "chevron.left.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.primaryGreen)
                            .opacity(selectedCropIndex > 0 ? 1.0 : 0.3)
                    }
                    .disabled(selectedCropIndex == 0)
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            selectedCropIndex = min(crops.count - 1, selectedCropIndex + 1)
                        }
                    }) {
                        Image(systemName: "chevron.right.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.primaryGreen)
                            .opacity(selectedCropIndex < crops.count - 1 ? 1.0 : 0.3)
                    }
                    .disabled(selectedCropIndex == crops.count - 1)
                }
                .padding(.bottom, 30)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 50 && selectedCropIndex > 0 {
                        withAnimation(.spring()) {
                            selectedCropIndex -= 1
                        }
                    } else if value.translation.width < -50 && selectedCropIndex < crops.count - 1 {
                        withAnimation(.spring()) {
                            selectedCropIndex += 1
                        }
                    }
                }
        )
    }
    
    // MARK: - Crop Card View
    private func cropCard(for crop: Crop, index: Int, totalWidth: CGFloat) -> some View {
        let isSelected = index == selectedCropIndex
        
        return VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                
                VStack {
                    Image(crop.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: itemWidth * 0.8, height: itemWidth * 0.8)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.top, 20)
                    
                    Text(crop.name)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.secondaryGreen)
                        .padding(.top, 10)
                    
                    Text(crop.growthPeriod)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                }
            }
            .frame(width: itemWidth, height: itemWidth * 1.4)
            .scaleEffect(isSelected ? 1.0 : scaleFactor)
        }
        .padding(.vertical, 20)
    }
}

// MARK: - Preview
#Preview {
    CropCarouselView(
        crops: Crop.sampleCrops,
        selectedCropIndex: .constant(2),
        isShowingDetail: .constant(false)
    )
} 