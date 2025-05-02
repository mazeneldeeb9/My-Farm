//
//  CropSelectionScreen.swift
//  My Farm
//
//  Created by developer on 16/02/2025.
//

import SwiftUI

struct CropSelectionScreen: View {
    // MARK: - State
    @State private var selectedCropIndex = 0
    @State private var isShowingDetail = false
    
    // MARK: - Properties
    let crops = Crop.sampleCrops
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Carousel view
            CropCarouselView(
                selectedCropIndex: $selectedCropIndex,
                isShowingDetail: $isShowingDetail
            )
            .opacity(isShowingDetail ? 0 : 1)
            
            // Detail view
            if isShowingDetail {
                CropDetailView(
                    crop: crops[selectedCropIndex],
                    isShowingDetail: $isShowingDetail
                )
                .transition(.move(edge: .trailing))
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

// MARK: - Preview
#Preview {
    CropSelectionScreen()
} 
