//
//  ApplicationCardView.swift
//  My Farm
//
//  Created by developer on 15/02/2025.
//

import SwiftUI

struct ApplicationCardView<Content: View>: View {
    
    // MARK: - Constants
    let content: Content
    
    // MARK: - Variables
    var title: String
    var subtitle: String?
    var imageName: String?
    var systemImageName: String?
    var imageSize: CGFloat = 40
    var imageColor: Color = .primaryGreen
    var cornerRadius: CGFloat = 8
    var backgroundColor: Color = .white
    var borderColor: Color = .primaryGreen
    var titleColor: Color = .secondaryGreen
    var subtitleColor: Color = .gray
    var shadowRadius: CGFloat = 2
    var padding: CGFloat = 16
    
    init(
        title: String,
        subtitle: String? = nil,
        imageName: String? = nil,
        systemImageName: String? = nil,
        imageSize: CGFloat = 40,
        imageColor: Color = .primaryGreen,
        cornerRadius: CGFloat = 8,
        backgroundColor: Color = .white,
        borderColor: Color = .primaryGreen,
        titleColor: Color = .secondaryGreen,
        subtitleColor: Color = .gray,
        shadowRadius: CGFloat = 2,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName
        self.systemImageName = systemImageName
        self.imageSize = imageSize
        self.imageColor = imageColor
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
        self.shadowRadius = shadowRadius
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title, image, and subtitle section
            HStack(spacing: 12) {
                // Image section
                if let systemImageName = systemImageName {
                    Image(systemName: systemImageName)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(imageColor)
                        .frame(width: imageSize, height: imageSize)
                } else if let imageName = imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageSize, height: imageSize)
                }
                
                // Title and subtitle
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .foregroundColor(titleColor)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 14))
                            .foregroundColor(subtitleColor)
                    }
                }
            }
            
            // Content section
            content
        }
        .padding(padding)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: shadowRadius, x: 0, y: 2)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        ApplicationCardView(
            title: "Crop Information",
            subtitle: "Details about your current crops",
            systemImageName: "leaf.fill",
            imageSize: 30
        ) {
            Text("Tomatoes are growing well")
                .foregroundColor(.secondaryGreen)
        }
        
        ApplicationCardView(
            title: "Weather Forecast",
            systemImageName: "sun.max.fill",
            imageColor: .yellow,
            backgroundColor: Color.grayBackground
        ) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Sunny")
                        .foregroundColor(.secondaryGreen)
                    Spacer()
                    Text("28°C")
                        .foregroundColor(.secondaryGreen)
                        .fontWeight(.bold)
                }
                
                Text("Perfect weather for your crops today!")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
        
        ApplicationCardView(
            title: "Farm Tips",
            subtitle: "Best practices for your farm",
            imageName: "ic_first"
        ) {
            Text("Water your plants early in the morning to reduce evaporation")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
    }
    .padding()
    .background(Color.grayBackground)
} 
