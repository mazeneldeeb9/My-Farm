//
//  UserScoreManager.swift
//  Maren
//
//  Created by mazen eldeeb on 11/03/2025.
//


import Foundation
import Supabase
import Combine
import UIKit

@MainActor
class UserManager: ObservableObject {
    private let supabaseURL = "https://pixtoqzsajzpxtcizrdw.supabase.co"
    private let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBpeHRvcXpzYWp6cHh0Y2l6cmR3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU3NzYwMDYsImV4cCI6MjA2MTM1MjAwNn0.VxnHo4YkUK82L1NvNxvq89ar7OSX9XE7d1uYVjZpoJI"
    private lazy var supabase = SupabaseClient(supabaseURL: URL(string: supabaseURL)!, supabaseKey: supabaseKey)
    
    @Published var currentUser: User?
    @Published var userCrops: [Crop] = []
    var password: String?

    // Singleton pattern
    static let shared = UserManager()
    private init() {
        currentUser = loadUserFromLocal()
    
        // Ensure crops table exists when the app starts
        Task {
            await ensureCropsTableExists()
        }
    }

    func updatePassword(oldPassword: String, newPassword: String) async throws {
        guard oldPassword == self.password else {
            throw UserCreationError.unknown("كلمة المرور الحالية غير صحيحة")
        }
        do {
            let response = try await supabase.auth.update(user: UserAttributes(password: newPassword))
            print("response: \(response)")
            let updatedUser = User(
                id: self.currentUser!.id,
                email: currentUser!.email,
                name: currentUser!.name,
                phoneNumber: currentUser?.phoneNumber,
                createdAt: currentUser!.createdAt,
                updatedAt: Date().description
            )
            currentUser = updatedUser
            print("user: \(updatedUser)")
            password = newPassword
            saveUserLocally(updatedUser, password: newPassword)
        } catch {
            print("Error updating user: \(error.localizedDescription)")
        }
    }
    
    func createUser(email: String, password: String, name: String, phoneNumber: String = "") async throws {
        do {
            let response = try await supabase.auth.signUp(
                email: email,
                password: password,
                data: [
                    "name": .string(name),
                    "phone_number": .string(phoneNumber)
                ]
            )
            print("response: \(response)")
    
            currentUser = User(
                id: UUID(uuidString: response.user.id.uuidString) ?? UUID(),
                email: response.user.email ?? "",
                name: response.user.userMetadata["name"]?.stringValue ?? "",
                phoneNumber: response.user.userMetadata["phone_number"]?.stringValue ?? "",
                createdAt: response.user.createdAt.description,
                updatedAt: response.user.updatedAt.description
            )
            if let user = currentUser {
                self.password = password
                saveUserLocally(user, password: password)
                print("user: \(user)")
                
                // Post notification that user signed up and logged in
                NotificationCenter.default.post(name: .userLoggedIn, object: nil)
            }
        } catch let error as AuthError {
            print(error)
            if error.message.contains("User already registered") ||
                error.message.contains("user_already_exists") {
                throw UserCreationError.userAlreadyExists
            } else {
                print("unkown auth error: \(error.message)")
                throw UserCreationError.unknown(error.message)
            }
        } catch {
            throw UserCreationError.unknown("unkown error")
        }
    }

    func signIn(email: String, password: String) async throws {
        do {
            let response = try await supabase.auth.signIn(
                email: email,
                password: password
            )
            print("response: \(response)")
            currentUser = User(
                id: UUID(uuidString: response.user.id.uuidString) ?? UUID(),
                email: response.user.email ?? "",
                name: response.user.userMetadata["name"]?.stringValue ?? "",
                phoneNumber: response.user.userMetadata["phone_number"]?.stringValue ?? "",
                createdAt: response.user.createdAt.description,
                updatedAt: response.user.updatedAt.description
            )
            if let user = currentUser {
                self.password = password
                saveUserLocally(user, password: password)
                print("user: \(user)")
                
                // Post notification that user logged in
                NotificationCenter.default.post(name: .userLoggedIn, object: nil)
            }
        } catch let error as AuthError {
            if error.message.contains("User already registered") ||
                error.message.contains("user_already_exists") {
                throw UserCreationError.invalidCredentials
            }
        }
    }

    func saveUserLocally(_ user: User, password: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: "savedUser")
            UserDefaults.standard.set(password, forKey: "password")
        }
    }

    func loadUserFromLocal() -> User? {
        if let savedUserData = UserDefaults.standard.data(forKey: "savedUser") {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(User.self, from: savedUserData) {
                self.password = UserDefaults.standard.string(forKey: "password") ?? ""
                return loadedUser
            }
        }
        return nil
    }

    func logout() async throws {
        do {
            try await supabase.auth.signOut()
            self.currentUser = nil
            password = nil
            UserDefaults.standard.removeObject(forKey: "savedUser")
            UserDefaults.standard.removeObject(forKey: "password")
            print("User logged out successfully.")
            
            // Post notification that user logged out
            NotificationCenter.default.post(name: .userLoggedOut, object: nil)
        } catch {
            throw UserCreationError.unknown("حدث خطأ ما")
        }
    }

    func saveCrop(_ crop: Crop) async throws {
        guard let userId = currentUser?.id.uuidString else {
            throw UserCreationError.unknown("User not logged in")
        }
        
        // Ensure the crops table exists
        await ensureCropsTableExists()
        
        do {
            // Convert image to base64 if it's from documents
            var imageBase64: String? = nil
            if crop.imageName.hasPrefix("crop_") {
                if let image = loadImageFromDocuments(named: crop.imageName) {
                    if let imageData = image.jpegData(compressionQuality: 0.7) {
                        imageBase64 = imageData.base64EncodedString()
                    }
                }
            }
            
            // Create a proper encodable struct for the crop data
            let cropInsertData = CropInsertData(
                id: UUID(),
                userId: userId,
                name: crop.name,
                type: crop.type,
                imageName: crop.imageName,
                imageData: imageBase64,
                plantedDate: crop.plantedDate,
                nextWatering: crop.nextWatering,
                growthProgress: crop.growthProgress,
                description: crop.description,
                soilType: crop.soilType,
                sunExposure: crop.sunExposure,
                wateringFrequency: crop.wateringFrequency,
                harvestTime: crop.harvestTime,
                idealTemperature: crop.idealTemperature
            )
            
            // Insert crop into Supabase
            let response = try await supabase
                .from("Crops")
                .insert(cropInsertData)
                .execute()
            
            print("Crop saved to Supabase: \(response)")
            
            // Add to local array
            userCrops.append(crop)
        } catch {
            print("Error saving crop: \(error.localizedDescription)")
            throw UserCreationError.unknown("Failed to save crop: \(error.localizedDescription)")
        }
    }
    
    func fetchUserCrops() async throws {
        guard let userId = currentUser?.id.uuidString else {
            throw UserCreationError.unknown("User not logged in")
        }
        
        // Ensure the crops table exists
        await ensureCropsTableExists()
        
        do {
            let response = try await supabase
                .from("Crops")
                .select()
                .eq("user_id", value: userId)
                .execute()
            
            
            let decoder = JSONDecoder()
            let cropRecords = try decoder.decode([CropInsertData].self, from: response.data)
            
            // Convert CropRecord to Crop and save images to documents if needed
            var fetchedCrops: [Crop] = []
            
            for record in cropRecords {
                // If we have image data, save it to documents
                var imageName = record.imageName
                if let imageData = record.imageData, !imageData.isEmpty {
                    if let data = Data(base64Encoded: imageData) {
                        let newImageName = "crop_\(UUID().uuidString).jpg"
                        saveImageData(data, withName: newImageName)
                        imageName = newImageName
                    }
                }
                
                let crop = Crop(
                    name: record.name,
                    type: record.type,
                    imageName: imageName,
                    plantedDate: record.plantedDate,
                    nextWatering: record.nextWatering,
                    growthProgress: record.growthProgress,
                    description: record.description,
                    soilType: record.soilType,
                    sunExposure: record.sunExposure,
                    wateringFrequency: record.wateringFrequency,
                    harvestTime: record.harvestTime,
                    idealTemperature: record.idealTemperature
                )
                
                fetchedCrops.append(crop)
            }
            
            // Update the published property on the main thread
            DispatchQueue.main.async {
                self.userCrops = fetchedCrops
            }
            
        } catch {
            print("Error fetching crops: \(error.localizedDescription)")
            throw UserCreationError.unknown("Failed to fetch crops: \(error.localizedDescription)")
        }
    }
    // Helper function to save image data to documents
    private func saveImageData(_ data: Data, withName name: String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(name)
        try? data.write(to: fileURL)
    }
    
    func loadImageFromDocuments(named filename: String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        return UIImage(contentsOfFile: fileURL.path)
    }
    // Add this method after the init() method
    func ensureCropsTableExists() async {
        do {
            // Check if the table exists by trying to select from it
            let _ = try await supabase
                .from("Crops")
                .select("id")
                .limit(1)
                .execute()
            
            print("Crops table exists")
        } catch {
            print("Crops table doesn't exist, creating it...")
        }
    }
    @Published var marketplaceCrops: [CropListing] = []
    
    func fetchMarketplaceCrops() async throws {
        do {
            let response = try await supabase
                .from("Crops")
                .select()
                .execute()
            
            let decoder = JSONDecoder()
            let cropRecords = try decoder.decode([CropInsertData].self, from: response.data)
            
            // Convert CropRecord to CropListing
            var fetchedCrops: [CropListing] = []
            
            for record in cropRecords {
                // Determine category based on crop type
                let cropType = record.type.lowercased()
                let category: CropCategory = {
                    switch cropType {
                    case let type where type.contains("vegetable"):
                        return .vegetables
                    case let type where type.contains("fruit"):
                        return .fruits
                    case let type where type.contains("grain"):
                        return .grains
                    case let type where type.contains("seed"):
                        return .seeds
                    default:
                        return .all
                    }
                }()
                
                // Create a marketplace listing from the crop record
                let cropListing = CropListing(
                    id: record.id ?? UUID(),
                    name: record.name,
                    seller: "Farm Market", // Default seller name since Crops table doesn't have a seller field
                    price: 2.99, // Default price since Crops table doesn't have a price field
                    image: record.imageName,
                    category: category
                )
                
                fetchedCrops.append(cropListing)
            }
            
            // Update the published property on the main thread
            DispatchQueue.main.async {
                self.marketplaceCrops = fetchedCrops
            }
            
        } catch {
            print("Error fetching marketplace crops: \(error.localizedDescription)")
            throw UserCreationError.unknown("Failed to fetch marketplace crops: \(error.localizedDescription)")
        }
    }
    
    // Remove the ensureMarketplaceTableExists function since we're using the existing Crops table
}


struct User: Codable, Identifiable, Equatable {
    let id: UUID
    let email: String
    let name: String
    let phoneNumber: String?
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case phoneNumber = "phone_number"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

enum UserCreationError: Error {
    case userAlreadyExists
    case invalidCredentials
    case weakPassword
    case networkError(String)
    case unknown(String)
    
    var localizedDescription: String {
        switch self {
        case .userAlreadyExists:
            return "البريد الإلكتروني مسجل بالفعل. يرجى تسجيل الدخول بدلاً من ذلك."
        case .invalidCredentials:
            return "البريد الإلكتروني أو كلمة المرور غير صحيحين. يرجى المحاولة مرة أخرى."
        case .weakPassword:
            return "كلمة المرور ضعيفة جدًا. يرجى استخدام كلمة مرور أقوى."
        case .networkError(let message):
            return "خطأ في الاتصال: \(message). يرجى التحقق من اتصالك بالإنترنت."
        case .unknown(let message):
            return "حدث خطأ: \(message)"
        }
    }
}

// MARK: - Crop Management
    
    
    
  


// MARK: - Crop Insert Data for Supabase
struct CropInsertData: Codable {
    var id: UUID?
    let userId: String
    let name: String
    let type: String
    let imageName: String
    let imageData: String?
    let plantedDate: String
    let nextWatering: String
    let growthProgress: Double
    let description: String
    let soilType: String
    let sunExposure: String
    let wateringFrequency: String
    let harvestTime: String
    let idealTemperature: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case name
        case type
        case imageName = "image_name"
        case imageData = "image_data"
        case plantedDate = "planted_date"
        case nextWatering = "next_watering"
        case growthProgress = "growth_progress"
        case description
        case soilType = "soil_type"
        case sunExposure = "sun_exposure"
        case wateringFrequency = "watering_frequency"
        case harvestTime = "harvest_time"
        case idealTemperature = "ideal_temperature"
    }
}
