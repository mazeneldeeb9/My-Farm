//
//  CropCarouselView.swift
//  My Farm
//
//  Created by developer on 16/02/2025.
//

import SwiftUI

struct CropCarouselView: View {
    // MARK: - Properties
    @StateObject private var userManager = UserManager.shared
    @State private var crops: [Crop] = []
    @Binding var selectedCropIndex: Int
    @Binding var isShowingDetail: Bool
    
    // MARK: - UI Properties
    private let itemWidth: CGFloat = 160  // Reduced from 200
    private let spacing: CGFloat = 15     // Reduced from 20
    private let scaleFactor: CGFloat = 0.8
    @State private var isFullScreen: Bool = false
    @State private var navigateToDetail: Bool = false
    @State private var isShowingImagePicker: Bool = false
    @State private var inputImage: UIImage?
    @State private var isIdentifyingPlant: Bool = false
    @State private var isLoading: Bool = true
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.grayBackground.ignoresSafeArea()
            
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .secondaryGreen))
            } else if crops.isEmpty {
                VStack {
                    Text("No crops yet")
                        .font(.system(size: 20))
                        .foregroundColor(.secondaryGreen)
                    
                    Button(action: {
                        isShowingImagePicker = true
                    }) {
                        Text("Add your first crop")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.secondaryGreen)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
            } else {
                VStack {
                    HStack {
                        Text("My Crops")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(.secondaryGreen)
                        
                        Spacer()
                        
                        Button(action: {
                            isShowingImagePicker = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.secondaryGreen)
                        }
                    }
                    .padding(.horizontal, 20)
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
                                                navigateToDetail = true
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal, (totalWidth - itemWidth) / 2)
                        }
                        .content.offset(x: CGFloat(selectedCropIndex) * -(itemWidth + spacing))
                        .scrollDisabled(true)
                    }
                }
                
                NavigationLink(
                    destination: CropDetailScreenView(crop: crops.isEmpty ? Crop.sampleCrops[0] : crops[min(selectedCropIndex, crops.count - 1)]),
                    isActive: $navigateToDetail,
                    label: { EmptyView() }
                )
            }
            
            // Loading overlay
            if isIdentifyingPlant {
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    
                    Text("Identifying plant...")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                }
                .padding(30)
                .background(Color.black.opacity(0.7))
                .cornerRadius(15)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if crops.isEmpty { return }
                    
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
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(image: $inputImage, onImageSelected: { selectedImage in
                isIdentifyingPlant = true
                identifyPlant(image: selectedImage)
                isShowingImagePicker = false
            })
        }
        .onAppear {
            loadCrops()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("AddNewCrop"))) { notification in
            if let newCrop = notification.userInfo?["crop"] as? Crop {
                // Save the crop to Supabase
                Task {
                    do {
                        try await userManager.saveCrop(newCrop)
                        // Reload crops after saving
                        try await userManager.fetchUserCrops()
                        DispatchQueue.main.async {
                            self.crops = userManager.userCrops
                            // Select the new crop
                            if !self.crops.isEmpty {
                                self.selectedCropIndex = self.crops.count - 1
                            }
                        }
                    } catch {
                        print("Error saving crop: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func loadCrops() {
        isLoading = true
        Task {
            do {
                try await userManager.fetchUserCrops()
                DispatchQueue.main.async {
                    self.crops = userManager.userCrops
                    self.isLoading = false
                    
                    // If we have crops but selectedCropIndex is out of bounds, fix it
                    if !self.crops.isEmpty && self.selectedCropIndex >= self.crops.count {
                        self.selectedCropIndex = 0
                    }
                }
            } catch {
                print("Error loading crops: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
    private func identifyPlant(image: UIImage) {
        // Convert image to base64
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            print("Failed to convert image to data")
            isIdentifyingPlant = false
            return
        }
        
        let base64String = imageData.base64EncodedString()
        
        // Prepare request
        let url = URL(string: "https://plant.id/api/v3/identification")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("PKCBmWiSaCkBnQKLOvsPs9JZd4978K6RTgTmYkq84G1CwyT6pU", forHTTPHeaderField: "Api-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create request body
        let requestBody: [String: Any] = [
            "images": ["data:image/jpg;base64,\(base64String)"],
            "latitude": 49.207,
            "longitude": 16.608,
            "similar_images": true
        ]
        
        // Convert request body to JSON
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("Error creating request body: \(error)")
            isIdentifyingPlant = false
            return
        }
        
        // Make API call
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Ensure we update UI on main thread
            DispatchQueue.main.async {
                // Set loading state to false when request completes
                defer { isIdentifyingPlant = false }
                
                if let error = error {
                    print("Error making API request: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                // Decode the response
                do {
                    let decoder = JSONDecoder()
                    let plantResponse = try decoder.decode(PlantIdentificationResponse.self, from: data)
                    
                    // Process the identified plant
                    if let topSuggestion = plantResponse.result.classification.suggestions.first {
                        print("Identified plant: \(topSuggestion.name) with \(topSuggestion.probability * 100)% confidence")
                        
                        // Save the image to documents directory
                        let imageName = saveImage(image)
                        
                        // Create a new crop with the identified plant information
                        let newCrop = Crop(
                            name: topSuggestion.name,
                            type: "Identified Plant",
                            imageName: imageName,
                            plantedDate: plantResponse.input.datetime,
                            nextWatering: getCurrentDate(),
                            growthProgress: 0.1,
                            description: "Lorem ipsum",
                            soilType: "Lorem ipsum",
                            sunExposure: "Lorem ipsum",
                            wateringFrequency: "Lorem ipsum",
                            harvestTime: "Lorem ipsum",
                            idealTemperature: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. This plant was identified using AI."
                        )
                        
                        // Add the new crop to your crops array
                        // Note: Since 'crops' is a let property, you'll need to use a binding or callback
                        // to update the parent's crops array
                        addNewCrop(newCrop)
                    }
                } catch {
                    print("Error decoding response: \(error)")
                    
                    // Print the raw data for debugging
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Raw response: \(responseString)")
                    }
                }
            }
        }.resume()
    }
    
    // MARK: - Crop Card View
    private func cropCard(for crop: Crop, index: Int, totalWidth: CGFloat) -> some View {
        let isSelected = index == selectedCropIndex
        
        return VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                
                VStack {
                    if crop.imageName.hasPrefix("crop_") {
                        // Load from documents directory
                        if let uiImage = loadImageFromDocuments(named: crop.imageName) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: itemWidth * 0.75, height: itemWidth * 0.75)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.top, 15)
                        }
                    } else {
                        // Load from asset catalog
                        Image(crop.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: itemWidth * 0.75, height: itemWidth * 0.75)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.top, 15)
                    }
                    
                    Text(crop.name)
                        .font(.system(size: 18))  // Reduced from 20
                        .fontWeight(.bold)
                        .foregroundColor(.secondaryGreen)
                        .padding(.top, 8)  // Reduced from 10
                    
                    Text(String(format: "%.2f", crop.growthProgress))
                        .font(.system(size: 12))  // Reduced from 14
                        .foregroundColor(.gray)
                        .padding(.bottom, 15)  // Reduced from 20
                }
            }
            .frame(width: itemWidth, height: itemWidth * 1.3)  // Reduced height ratio from 1.4
            .scaleEffect(isSelected ? 1.0 : scaleFactor)
        }
        .padding(.vertical, 15)  // Reduced from 20
    }
}

// MARK: - Crop Detail Screen View
struct CropDetailScreenView: View {
    let crop: Crop
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if crop.imageName.hasPrefix("crop_") {
                    if let uiImage = loadImageFromDocuments(named: crop.imageName) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .cornerRadius(16)
                            .padding(.horizontal)
                    }
                } else {
                    Image(crop.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(16)
                        .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(crop.name)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.secondaryGreen)
                    
                    Text(crop.type)
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                    
                    ProgressView(value: crop.growthProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .secondaryGreen))
                        .padding(.vertical, 8)
                    
                    Text("Growth Progress: \(Int(crop.growthProgress * 100))%")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Divider().padding(.vertical, 8)
                    
                    Group {
                        infoRow(title: "Planted Date", value: crop.plantedDate)
                        infoRow(title: "Next Watering", value: crop.nextWatering)
                        infoRow(title: "Soil Type", value: crop.soilType)
                        infoRow(title: "Sun Exposure", value: crop.sunExposure)
                        infoRow(title: "Watering Frequency", value: crop.wateringFrequency)
                        infoRow(title: "Harvest Time", value: crop.harvestTime)
                        infoRow(title: "Ideal Temperature", value: crop.idealTemperature)
                    }
                    
                    Text("Description")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.secondaryGreen)
                        .padding(.top, 8)
                    
                    Text(crop.description)
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                        .lineSpacing(4)
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 30)
        }
        .navigationBarTitle(crop.name, displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
            .foregroundColor(.secondaryGreen)
        })
        .background(Color.grayBackground.ignoresSafeArea())
    }
    
    // Helper view for info rows in detail screen
    private func infoRow(title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(title + ":")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondaryGreen)
                .frame(width: 140, alignment: .leading)
            
            Text(value)
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        CropCarouselView(
            selectedCropIndex: .constant(2),
            isShowingDetail: .constant(false)
        )
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var onImageSelected: (UIImage) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.image = editedImage
                parent.onImageSelected(editedImage)
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.image = originalImage
                parent.onImageSelected(originalImage)
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - Plant Identification Response Models
struct PlantIdentificationResponse: Codable {
    let accessToken: String
    let modelVersion: String
    let customID: String?
    let input: PlantInput
    let result: PlantResult
    let status: String
    let slaCompliantClient: Bool
    let slaCompliantSystem: Bool
    let created: Double
    let completed: Double
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case modelVersion = "model_version"
        case customID = "custom_id"
        case input
        case result
        case status
        case slaCompliantClient = "sla_compliant_client"
        case slaCompliantSystem = "sla_compliant_system"
        case created
        case completed
    }
}

struct PlantInput: Codable {
    let latitude: Double
    let longitude: Double
    let similarImages: Bool
    let images: [String]
    let datetime: String
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case similarImages = "similar_images"
        case images
        case datetime
    }
}

struct PlantResult: Codable {
    let isPlant: IsPlant
    let classification: Classification
    
    enum CodingKeys: String, CodingKey {
        case isPlant = "is_plant"
        case classification
    }
}

struct IsPlant: Codable {
    let probability: Double
    let binary: Bool
    let threshold: Double
}

struct Classification: Codable {
    let suggestions: [PlantSuggestion]
}

struct PlantSuggestion: Codable {
    let id: String
    let name: String
    let probability: Double
    let similarImages: [SimilarImage]
    let details: PlantDetails
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case probability
        case similarImages = "similar_images"
        case details
    }
}

struct SimilarImage: Codable {
    let id: String
    let url: String
    let licenseName: String?
    let licenseUrl: String?
    let citation: String?
    let similarity: Double
    let urlSmall: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case licenseName = "license_name"
        case licenseUrl = "license_url"
        case citation
        case similarity
        case urlSmall = "url_small"
    }
}

struct PlantDetails: Codable {
    let language: String
    let entityId: String
    
    enum CodingKeys: String, CodingKey {
        case language
        case entityId = "entity_id"
    }
}

// MARK: - Helper Functions
    
    // Function to save image to documents directory and return the filename
    private func saveImage(_ image: UIImage) -> String {
        let imageName = "crop_\(UUID().uuidString).jpg"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        
        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: fileURL)
        }
        
        return imageName
    }
    
    // Function to get current date formatted as string
    private func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: Date())
    }
    
    // Function to get next watering date (3 days from now)
    private func getNextWateringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let nextWateringDate = Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date()
        return dateFormatter.string(from: nextWateringDate)
    }
    
    // Function to add a new crop to the user's collection
    private func addNewCrop(_ newCrop: Crop) {
        // Since crops is a let property, we need to use a notification to update the parent view
        NotificationCenter.default.post(
            name: NSNotification.Name("AddNewCrop"),
            object: nil,
            userInfo: ["crop": newCrop]
        )
    }
