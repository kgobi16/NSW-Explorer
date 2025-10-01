//
//  MainTabView.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 1/10/2025.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab: Int = 0
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            HomeView()
                .tabItem {
                    Label{
                        Text("Discover")
                    } icon: {
                        Image(systemName: selectedTab == 0 ? "airplane" : "airplane")
                    }
                }
                .tag(0)
            
            GeneratorView()
                .tabItem {
                    Label{
                        Text("Generator")
                    } icon: {
                        Image(systemName: selectedTab == 1 ? "sparkles" : "sparkles")
                    }
                }
                .tag(1)
            
            MyTripsView()
                .tabItem {
                    Label {
                        Text("My Trips")
                    } icon: {
                        // book represents a travel journal/log
                        Image(systemName: selectedTab == 2 ? "book.fill" : "book")
                    }
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Label {
                        Text("Profile")
                    } icon: {
                        // person represents the user/profile
                        Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                    }
                }
                .tag(3)
        }
        
        // MARK: - Tab Bar Styling
        .onAppear {
            
            // Configure tab bar appearance for a modern look
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = UIColor(Color.SurfaceWhite.opacity(0.95))
            UITabBar.appearance().standardAppearance = appearance
            
            // Ensure it looks good when scrolling content behind it
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
        .tint(Color.PrimaryTeal)
    }
}


// MARK: - Preview Provider
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}


