//
//  HomeTabView.swift
//  My Farm
//
//  Created by developer on 27/06/2024.
//

import SwiftUI

struct HomeTabView: View {
    @State private var selectedCrop: String = "Tomatoes"
    @State private var crops = ["Tomatoes", "Corn", "Wheat", "Potatoes", "Carrots"]
    
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
                        systemImageName: "sun.max.fill",
                        imageColor: .yellow
                    ) {
                        VStack(spacing: 10) {
                            HStack {
                                Text("Sunny")
                                    .foregroundColor(.secondaryGreen)
                                Spacer()
                                Text("28°C")
                                    .foregroundColor(.secondaryGreen)
                                    .fontWeight(.bold)
                            }
                            
                            HStack {
                                Image(systemName: "drop.fill")
                                    .foregroundColor(.blue)
                                Text("Humidity: 65%")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Image(systemName: "wind")
                                    .foregroundColor(.gray)
                                Text("Wind: 8 km/h")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    // Crop selection
                    ApplicationCardView(
                        title: "My Crops",
                        systemImageName: "leaf.arrow.circlepath",
                        imageColor: .green
                    ) {
                        VStack(alignment: .leading, spacing: 12) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(crops, id: \.self) { crop in
                                        Button {
                                            selectedCrop = crop
                                        } label: {
                                            Text(crop)
                                                .font(.system(size: 14, weight: .medium))
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(selectedCrop == crop ? Color.primaryGreen : Color.gray.opacity(0.2))
                                                .foregroundColor(selectedCrop == crop ? .white : .gray)
                                                .cornerRadius(20)
                                        }
                                    }
                                }
                            }
                            
                            if !selectedCrop.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("\(selectedCrop) Status")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.secondaryGreen)
                                    
                                    HStack {
                                        ProgressView(value: 0.7)
                                            .progressViewStyle(LinearProgressViewStyle(tint: .primaryGreen))
                                            .frame(height: 8)
                                        
                                        Text("70%")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Text("Next watering: Today")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                .padding(.top, 8)
                            }
                        }
                    }
                    
                    // AI Assistant card
                    ApplicationCardView(
                        title: Constants.Home.WhoSeeksAdvice,
                        subtitle: Constants.Home.trustedAi,
                        systemImageName: "questionmark.circle.fill"
                    ) {
                        Button {
                            // Action
                        } label: {
                            Text(Constants.Home.askNow)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(Color.primaryGreen)
                                .cornerRadius(8)
                        }
                        .padding(.top, 8)
                    }
                    
                    // Tasks for today
                    ApplicationCardView(
                        title: "Today's Tasks",
                        systemImageName: "checklist",
                        imageColor: .orange
                    ) {
                        VStack(alignment: .leading, spacing: 12) {
                            TaskRow(title: "Water tomatoes", isCompleted: true)
                            TaskRow(title: "Apply fertilizer to corn", isCompleted: false)
                            TaskRow(title: "Check soil moisture", isCompleted: false)
                            
                            Button {
                                // Action to add new task
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add Task")
                                }
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primaryGreen)
                            }
                            .padding(.top, 8)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 80) // Add padding for the tab bar
            }
            .background(Color.grayBackground)
            .navigationTitle("My Farm")
        }
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