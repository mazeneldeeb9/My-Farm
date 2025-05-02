//
//  Crop.swift
//  My Farm
//
//  Created by developer on 27/06/2024.
//

import Foundation

struct Crop: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let imageName: String
    let plantedDate: String
    let nextWatering: String
    let growthProgress: Double
    let description: String
    let soilType: String
    let sunExposure: String
    let wateringFrequency: String
    let harvestTime: String
    let idealTemperature: String
    
    static var sampleCrops: [Crop] = [
        Crop(
            name: "Tomatoes",
            type: "Vegetable",
            imageName: "tomato_image",
            plantedDate: "May 15, 2024",
            nextWatering: "Today",
            growthProgress: 0.7,
            description: "Roma tomatoes are grown for canning and sauce production. They have fewer seeds and are more dense than other tomatoes.",
            soilType: "Well-drained, slightly acidic",
            sunExposure: "Full sun (6-8 hours)",
            wateringFrequency: "Every 2-3 days",
            harvestTime: "75-90 days after planting",
            idealTemperature: "21-24°C (70-75°F)"
        ),
        Crop(
            name: "Corn",
            type: "Grain",
            imageName: "tomato_image",
            plantedDate: "April 10, 2024",
            nextWatering: "Tomorrow",
            growthProgress: 0.85,
            description: "Sweet corn is a variety of maize with high sugar content. It's harvested when immature and eaten as a vegetable.",
            soilType: "Rich, well-drained soil",
            sunExposure: "Full sun (6+ hours)",
            wateringFrequency: "Weekly, 1-2 inches",
            harvestTime: "60-100 days after planting",
            idealTemperature: "16-35°C (60-95°F)"
        ),
        Crop(
            name: "Wheat",
            type: "Grain",
            imageName: "tomato_image",
            plantedDate: "March 5, 2024",
            nextWatering: "In 3 days",
            growthProgress: 0.95,
            description: "Wheat is a grass widely cultivated for its seed, a cereal grain that is a worldwide staple food.",
            soilType: "Loamy, well-drained",
            sunExposure: "Full sun",
            wateringFrequency: "Moderate, depends on rainfall",
            harvestTime: "7-8 months after planting",
            idealTemperature: "21-24°C (70-75°F)"
        ),
        Crop(
            name: "Potatoes",
            type: "Tuber",
            imageName: "tomato_image",
            plantedDate: "April 25, 2024",
            nextWatering: "Today",
            growthProgress: 0.6,
            description: "Russet potatoes are large, with dark brown skin and few eyes. The flesh is white, dry, and mealy, and it's good for baking, mashing, and french fries.",
            soilType: "Loose, well-drained, slightly acidic",
            sunExposure: "Full sun to partial shade",
            wateringFrequency: "1-2 inches per week",
            harvestTime: "70-120 days after planting",
            idealTemperature: "15-20°C (60-68°F)"
        ),
        Crop(
            name: "Carrots",
            type: "Root",
            imageName: "tomato_image",
            plantedDate: "May 1, 2024",
            nextWatering: "In 2 days",
            growthProgress: 0.5,
            description: "Carrots are root vegetables, usually orange in color, though purple, black, red, white, and yellow varieties exist.",
            soilType: "Sandy, loose, well-drained",
            sunExposure: "Full sun to partial shade",
            wateringFrequency: "1 inch per week",
            harvestTime: "70-80 days after planting",
            idealTemperature: "15-18°C (60-65°F)"
        )
    ]
}
