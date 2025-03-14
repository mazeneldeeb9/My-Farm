//
//  NetworkManager.swift
//  3oon
//
//  Created by mazen eldeeb on 15/02/2025.
//

import Foundation
import Alamofire

protocol NetworkManaging {
    func request(
        url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders?
    ) async throws -> Void
}

class NetworkManager: NetworkManaging {
    static let shared = NetworkManager()
    
    func request(
        url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil
    ) async throws -> Void {
        AF.request(url)
            .validate()
    }
    
    static var defaultHeaders: HTTPHeaders {
        var headers = HTTPHeaders()
        headers["Authorization"] = "Bearer f8118d4c-8214-4e9b-8e24-0f95b3bc10f0"
        headers["Accept"] = "application/json"
        return headers
    }
}
