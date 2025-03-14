//
//  MainTabBar.swift
//  My Farm
//
//  Created by developer on 27/06/2024.
//

import SwiftUI

struct MainTabBar: View {
    @Binding var selectedTab: Tab
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                TabButton(
                    tab: tab,
                    selectedTab: $selectedTab,
                    animation: animation
                )
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
    }
}

struct TabButton: View {
    let tab: Tab
    @Binding var selectedTab: Tab
    var animation: Namespace.ID
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 20))
                    .foregroundColor(selectedTab == tab ? .primaryGreen : .gray)
                
                Text(tab.title)
                    .font(.system(size: 10))
                    .fontWeight(selectedTab == tab ? .semibold : .regular)
                    .foregroundColor(selectedTab == tab ? .primaryGreen : .gray)
                
                if selectedTab == tab {
                    Circle()
                        .fill(Color.primaryGreen)
                        .frame(width: 5, height: 5)
                        .matchedGeometryEffect(id: "TAB", in: animation)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
    }
}

enum Tab: String, CaseIterable {
    case home, marketplace, favorites, profile, settings
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .marketplace:
            return "Marketplace"
        case .favorites:
            return "Favorites"
        case .profile:
            return "Profile"
        case .settings:
            return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .marketplace:
            return "cart.fill"
        case .favorites:
            return "heart.fill"
        case .profile:
            return "person.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}

// Extension for rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    MainTabBar(selectedTab: .constant(.home))
        .previewLayout(.sizeThatFits)
        .padding()
}