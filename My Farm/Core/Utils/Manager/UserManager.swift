//
//  UserScoreManager.swift
//  Maren
//
//  Created by mazen eldeeb on 11/03/2025.
//


import Foundation
import Supabase
import Combine

@MainActor
class UserManager: ObservableObject {
    private let supabaseURL = "https://aurbifqmwkwztfgnsekt.supabase.co"
    private let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF1cmJpZnFtd2t3enRmZ25zZWt0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE5ODY3MDksImV4cCI6MjA1NzU2MjcwOX0.aEo-4Zy4BeUWmcGXT8OGClUOR3qDVEtvGCO6erPEXeI"
    private lazy var supabase = SupabaseClient(supabaseURL: URL(string: supabaseURL)!, supabaseKey: supabaseKey)
    
    @Published var currentUser: User?
    var password: String?

    // Singleton pattern
    static let shared = UserManager()
    private init() {
        currentUser = loadUserFromLocal()
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
                score: currentUser!.score,
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
    func updateScore(newScore: Int) async throws {
        guard let user = currentUser, let _ = UUID(uuidString: user.id.uuidString) else {
                return
            }
            do {
                let response = try await supabase.auth.update(
                    user: .init(
                        data: [
                            "score": .integer(newScore + (currentUser?.score ?? 0))
                        ]
                    )
                )
                print("response: \(response)")

                let updatedUser = User(
                    id: user.id,
                    email: user.email,
                    name: user.name,
                    score: newScore,
                    createdAt: user.createdAt,
                    updatedAt: Date().description
                )
                currentUser = updatedUser
                print("user: \(updatedUser)")
                saveUserLocally(updatedUser, password: password ?? "")
                
            } catch {
                print("Unknown error: \(error.localizedDescription)")
                throw UserCreationError.unknown("حدث خطأ ما")
            }
        }

    
    func updateName(name: String) async throws {
        guard let user = currentUser, let _ = UUID(uuidString: user.id.uuidString) else {
                return
            }
            do {
                _ = try await supabase.auth.update(
                    user: .init(
                        data: [
                            "name": .string(name)
                        ]
                    )
                )
                let updatedUser = User(
                    id: user.id,
                    email: user.email,
                    name: name,
                    score: user.score,
                    createdAt: user.createdAt,
                    updatedAt: Date().description
                )
                currentUser = updatedUser
                print("user: \(updatedUser)")
                saveUserLocally(updatedUser, password: password ?? "")
                
            } catch {
                print("Unknown error: \(error.localizedDescription)")
                throw UserCreationError.unknown("حدث خطأ ما")
            }
        }
        
    
    func createUser(email: String, password: String, name: String) async throws {
        do {
            let response = try await supabase.auth.signUp(
                email: email,
                password: password,
                data: [
                    "name": .string(name),
                    "score": .integer(0)
                ]
            )
            print("response: \(response)")

            currentUser = User(
                id: UUID(uuidString: response.user.id.uuidString) ?? UUID(),
                email: response.user.email ?? "",
                name: response.user.userMetadata["name"]?.stringValue ?? "",
                score: response.user.userMetadata["score"]?.intValue ?? 0,
                createdAt: response.user.createdAt.description,
                updatedAt: response.user.updatedAt.description
            )
            if let user = currentUser {
                self.password = password
                saveUserLocally(user, password: password)
                print("user: \(user)")
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
                score: response.user.userMetadata["score"]?.intValue ?? 0,
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

}

struct User: Codable, Identifiable, Equatable {
    let id: UUID
    let email: String
    let name: String
    let score: Int
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case score
        case email
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
