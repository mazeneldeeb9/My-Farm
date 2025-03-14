//
//  Crop.swift
//  My Farm
//
//  Created by developer on 16/02/2025.
//

import Foundation
import SwiftUI

struct Crop: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let description: String
    let growthPeriod: String
    let waterRequirements: String
    let sunRequirements: String
    let soilType: String
    let harvestTime: String
    let tips: String
    
    static let sampleCrops: [Crop] = [
        Crop(
            name: "Tomato",
            image: "tomato_image",
            description: "Tomatoes are the major dietary source of the antioxidant lycopene, which has been linked to many health benefits, including reduced risk of heart disease and cancer.",
            growthPeriod: "70-85 days",
            waterRequirements: "Regular watering, about 1-2 inches per week",
            sunRequirements: "Full sun, 6-8 hours daily",
            soilType: "Well-draining, slightly acidic soil (pH 6.0-6.8)",
            harvestTime: "Summer to early fall",
            tips: "Stake or cage plants to support growth. Prune suckers for indeterminate varieties."
        ),
        Crop(
            name: "Carrot",
            image: "carrot_image",
            description: "Carrots are a good source of beta carotene, fiber, vitamin K1, potassium, and antioxidants.",
            growthPeriod: "70-80 days",
            waterRequirements: "Consistent moisture, about 1 inch per week",
            sunRequirements: "Full sun to partial shade",
            soilType: "Loose, sandy soil free of rocks (pH 6.0-7.0)",
            harvestTime: "Spring and fall",
            tips: "Thin seedlings to 2 inches apart. Keep soil consistently moist for best flavor."
        ),
        Crop(
            name: "Lettuce",
            image: "lettuce_image",
            description: "Lettuce is a low-calorie vegetable that is high in fiber, and minerals like calcium, phosphorus, magnesium, and potassium.",
            growthPeriod: "45-55 days",
            waterRequirements: "Regular watering, keeping soil moist",
            sunRequirements: "Partial shade in hot weather, full sun in cool weather",
            soilType: "Rich, well-draining soil (pH 6.0-7.0)",
            harvestTime: "Spring and fall",
            tips: "Harvest outer leaves as needed. Plant in succession for continuous harvest."
        ),
        Crop(
            name: "Cucumber",
            image: "cucumber_image",
            description: "Cucumbers are low in calories but high in many important vitamins and minerals, as well as water content.",
            growthPeriod: "50-70 days",
            waterRequirements: "Regular watering, 1-2 inches per week",
            sunRequirements: "Full sun, 6+ hours daily",
            soilType: "Rich, well-draining soil (pH 6.0-7.0)",
            harvestTime: "Summer",
            tips: "Harvest regularly to encourage production. Consider trellising to save space."
        ),
        Crop(
            name: "Bell Pepper",
            image: "pepper_image",
            description: "Bell peppers are rich in many vitamins and antioxidants, especially vitamin C and various carotenoids.",
            growthPeriod: "60-90 days",
            waterRequirements: "Regular watering, keeping soil consistently moist",
            sunRequirements: "Full sun, 6-8 hours daily",
            soilType: "Well-draining, fertile soil (pH 6.0-7.0)",
            harvestTime: "Summer to early fall",
            tips: "Support plants with stakes or cages. Harvest when peppers reach full size and desired color."
        )
    ]
} 