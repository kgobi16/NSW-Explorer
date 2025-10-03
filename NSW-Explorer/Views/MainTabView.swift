//
//  MainTabView.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 1/10/2025.
//


import SwiftUI

struct MainTabView: View {
    // MARK: - State Properties
    
    /// Tracks which tab is currently selected
    /// Starting at 0 means we show the Generator tab first
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // MARK: - Generator Tab (MAIN PAGE)
            // The primary feature - AI-powered trip generation
            GeneratorView()
                .tabItem {
                    Label {
                        Text("Generate")
                    } icon: {
                        Image(systemName: selectedTab == 0 ? "sparkles" : "sparkles")
                    }
                }
                .tag(0)
            
            // MARK: - My Trips Tab
            // User's saved and completed journeys
            MyTripsView()
                .tabItem {
                    Label {
                        Text("My Trips")
                    } icon: {
                        Image(systemName: selectedTab == 1 ? "book.fill" : "book")
                    }
                }
                .tag(1)
            
            // MARK: - Profile Tab
            // User settings and preferences
            ProfileView()
                .tabItem {
                    Label {
                        Text("Profile")
                    } icon: {
                        Image(systemName: selectedTab == 2 ? "person.fill" : "person")
                    }
                }
                .tag(2)
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = UIColor(Color.SurfaceWhite.opacity(0.95))
            UITabBar.appearance().standardAppearance = appearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
        .tint(Color.primaryTeal)
    }
}

// MARK: - Preview Provider
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
