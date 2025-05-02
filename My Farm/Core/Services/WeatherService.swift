//
//  WeatherService.swift
//  My Farm
//
//  Created by developer on 27/06/2024.
//

import Foundation
import Combine
import CoreLocation

class WeatherService: NSObject, CLLocationManagerDelegate {
    private let apiKey = "ed4e573efbe141faa9f220202231409"
    private let baseURL = "https://api.weatherapi.com/v1"
    
    private let locationManager = CLLocationManager()
    private var locationCompletion: ((Result<CLLocation, Error>) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer // Lower accuracy for weather is fine
    }
    
    func getCurrentWeather(for location: String) -> AnyPublisher<WeatherResponse, Error> {
        let urlString = "\(baseURL)/current.json?key=\(apiKey)&q=\(location)"
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getCurrentWeatherByLocation() -> AnyPublisher<WeatherResponse, Error> {
        return Future<CLLocation, Error> { [weak self] promise in
            self?.getCurrentLocation { result in
                promise(result)
            }
        }
        .flatMap { location -> AnyPublisher<WeatherResponse, Error> in
            let locationString = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
            return self.getCurrentWeather(for: locationString)
        }
        .eraseToAnyPublisher()
    }
    
    func getCurrentLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        // Check authorization status
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationCompletion = completion
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            completion(.failure(LocationError.accessDenied))
        case .authorizedWhenInUse, .authorizedAlways:
            locationCompletion = completion
            locationManager.requestLocation()
        @unknown default:
            completion(.failure(LocationError.unknown))
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationCompletion?(.success(location))
            locationCompletion = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationCompletion?(.failure(error))
        locationCompletion = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.requestLocation()
        } else if status == .denied || status == .restricted {
            locationCompletion?(.failure(LocationError.accessDenied))
            locationCompletion = nil
        }
    }
}

enum LocationError: Error {
    case accessDenied
    case unknown
}

// Weather API Response Models
struct WeatherResponse: Codable {
    let location: Location
    let current: CurrentWeather
}

struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let localtime: String
}

struct CurrentWeather: Codable {
    let lastUpdatedEpoch: Int
    let lastUpdated: String
    let tempC: Double
    let tempF: Double
    let isDay: Int
    let condition: WeatherCondition
    let windMph: Double
    let windKph: Double
    let windDegree: Int
    let windDir: String
    let pressureMb: Double
    let pressureIn: Double
    let precipMm: Double
    let precipIn: Double
    let humidity: Int
    let cloud: Int
    let feelslikeC: Double
    let feelslikeF: Double
    let visKm: Double
    let visMiles: Double
    let uv: Double
    
    enum CodingKeys: String, CodingKey {
        case lastUpdatedEpoch = "last_updated_epoch"
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case condition
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureMb = "pressure_mb"
        case pressureIn = "pressure_in"
        case precipMm = "precip_mm"
        case precipIn = "precip_in"
        case humidity
        case cloud
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case visKm = "vis_km"
        case visMiles = "vis_miles"
        case uv
    }
}

struct WeatherCondition: Codable {
    let text: String
    let icon: String
    let code: Int
    
    var systemImageName: String {
        switch code {
        case 1000: // Sunny/Clear
            return "sun.max.fill"
        case 1003: // Partly cloudy
            return "cloud.sun.fill"
        case 1006, 1009: // Cloudy, Overcast
            return "cloud.fill"
        case 1030, 1135, 1147: // Mist, Fog, Freezing fog
            return "cloud.fog.fill"
        case 1063, 1180, 1183, 1186, 1189, 1192, 1195, 1240, 1243, 1246: // Rain
            return "cloud.rain.fill"
        case 1066, 1114, 1117, 1210, 1213, 1216, 1219, 1222, 1225, 1255, 1258: // Snow
            return "cloud.snow.fill"
        case 1069, 1072, 1168, 1171, 1198, 1201, 1204, 1207, 1249, 1252: // Sleet
            return "cloud.sleet.fill"
        case 1087, 1273, 1276, 1279, 1282: // Thunder
            return "cloud.bolt.fill"
        default:
            return "cloud.fill"
        }
    }
}