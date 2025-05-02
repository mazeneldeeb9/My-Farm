//
//  HomeTabView.swift
//  My Farm
//
//  Created by developer on 27/06/2024.
//

import SwiftUI
import Combine

struct HomeTabView: View {
    @State private var selectedCropIndex: Int = 0
    @State private var crops = Crop.sampleCrops
    @State private var isShowingDetail = false
    
    // Weather states
    @State private var weatherData: WeatherResponse?
    @State private var isLoadingWeather = true
    @State private var weatherError: String?
    @State private var cancellables = Set<AnyCancellable>()
    
    private let weatherService = WeatherService()
    private let defaultLocation = "London" // You can change this to a default location or use user's location
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome card
                    ApplicationCardView(
                        title: "Welcome to My Farm",
                        subtitle: "Your smart farming assistant",
                        systemImageName: "leaf.fill",
                        imageSize: 40
                    ) {
                        Text("Manage your farm efficiently with AI-powered insights")
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                    }
                    
                    // Weather card
                    ApplicationCardView(
                        title: "Today's Weather",
                        systemImageName: weatherData?.current.condition.systemImageName ?? "sun.max.fill",
                        imageColor: .yellow
                    ) {
                        if isLoadingWeather {
                            ProgressView()
                                .frame(height: 60)
                        } else if let error = weatherError {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.system(size: 14))
                        } else if let weather = weatherData {
                            VStack(spacing: 10) {
                                HStack {
                                    Text(weather.current.condition.text)
                                        .foregroundColor(.secondaryGreen)
                                    Spacer()
                                    Text("\(Int(weather.current.tempC))°C")
                                        .foregroundColor(.secondaryGreen)
                                        .fontWeight(.bold)
                                }
                                
                                HStack {
                                    Image(systemName: "drop.fill")
                                        .foregroundColor(.blue)
                                    Text("Humidity: \(weather.current.humidity)%")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "wind")
                                        .foregroundColor(.gray)
                                    Text("Wind: \(Int(weather.current.windKph)) km/h")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                
                                Text("Location: \(weather.location.name), \(weather.location.country)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        } else {
                            Text("Weather data unavailable")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    ZStack {
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
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 80) // Add padding for the tab bar
            }
            .background(Color.grayBackground)
            .navigationTitle("My Farm")
            .onAppear {
                fetchWeather()
                NotificationCenter.default.addObserver(
                    forName: NSNotification.Name("AddNewCrop"),
                    object: nil,
                    queue: .main
                ) { notification in
                    if let newCrop = notification.userInfo?["crop"] as? Crop {
                        self.crops.append(newCrop)
                        // Optionally select the new crop
                        self.selectedCropIndex = self.crops.count - 1
                    }
                }
            }
        }
    }
    
    private func fetchWeather() {
        isLoadingWeather = true
        weatherError = nil
        
        weatherService.getCurrentWeatherByLocation()
            .sink(receiveCompletion: { completion in
                isLoadingWeather = false
                if case .failure(let error) = completion {
                    weatherError = "Failed to load weather: \(error.localizedDescription)"
                    // Fallback to default location if location access fails
                    self.fetchWeatherForDefaultLocation()
                }
            }, receiveValue: { response in
                weatherData = response
                isLoadingWeather = false
            })
            .store(in: &cancellables)
    }
    
    private func fetchWeatherForDefaultLocation() {
        weatherService.getCurrentWeather(for: defaultLocation)
            .sink(receiveCompletion: { completion in
                isLoadingWeather = false
                if case .failure(let error) = completion {
                    weatherError = "Failed to load weather: \(error.localizedDescription)"
                }
            }, receiveValue: { response in
                weatherData = response
                isLoadingWeather = false
            })
            .store(in: &cancellables)
    }
}

struct HomeCropCarouselView: View {
    let crops: [Crop]
    @Binding var selectedCropIndex: Int
    
    var body: some View {
        TabView(selection: $selectedCropIndex) {
            ForEach(crops.indices, id: \.self) { index in
                CropCardView(crop: crops[index])
                    .padding(.horizontal, 10)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    }
}

struct CropCardView: View {
    let crop: Crop
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomLeading) {
                Image(crop.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .clipped()
                    .cornerRadius(12)
                
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 60)
                .cornerRadius(12)
                
                Text(crop.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 8)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Planted: \(crop.plantedDate)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Text("Type: \(crop.type)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 4)
                        .frame(width: 40, height: 40)
                    
                    Circle()
                        .trim(from: 0, to: crop.growthProgress)
                        .stroke(Color.primaryGreen, lineWidth: 4)
                        .frame(width: 40, height: 40)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(Int(crop.growthProgress * 100))%")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.primaryGreen)
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 8)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct TaskRow: View {
    var title: String
    var isCompleted: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isCompleted ? .green : .gray)
            
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(isCompleted ? .gray : .primary)
                .strikethrough(isCompleted)
            
            Spacer()
        }
    }
}

#Preview {
    HomeTabView()
}
