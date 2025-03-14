//
//  MainScreen.swift
//  My Farm
//
//  Created by developer on 27/06/2024.
//

import SwiftUI

struct MainScreen: View {
    @State private var selectedTab: Tab = .home
    @State private var previousTab: Tab = .home
    @Namespace private var animation
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeTabView()
                    .tag(Tab.home)
                
                MarketplaceTabView()
                    .tag(Tab.marketplace)
                
                FavoritesTabView()
                    .tag(Tab.favorites)
                
                ProfileTabView()
                    .tag(Tab.profile)
                
                SettingsTabView()
                    .tag(Tab.settings)
            }
            //.tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea(edges: .bottom)
            .onChange(of: selectedTab) { newTab in
                withAnimation(.easeInOut(duration: 0.3)) {
                    previousTab = newTab
                }
            }
            
            MainTabBar(selectedTab: $selectedTab)
        }
    .background(Color.grayBackground.ignoresSafeArea())
    }
}

#Preview {
    MainScreen()
}
