//
//  MyTripsView.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 1/10/2025.
//

import SwiftUI

struct MyTripsView: View {
    
    // Controls whether to display trips in grid or list layout
    @State private var isGridView: Bool = true
    // Currently selected filter tab
    @State private var selectedFilter: String = "All"
    // Search query for filtering trips by name
    @State private var searchText: String = ""
    // Filter options
    private let filters = ["All", "Saved", "Completed"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // MARK: - Statistics Banner
                // Shows user's trip statistics at the top
                statisticsBanner
                
                // MARK: - Filter Tabs
                filterTabs
                
                // MARK: - Trip List/Grid
                // Main content area showing trips
                if isGridView {
                    tripGridView
                } else {
                    tripListView
                }
            }
            .background(Color.backgroundGray)
            .navigationTitle("My Trips")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search trips")
            .toolbar {
                // MARK: - Toolbar Items
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Toggle between grid and list view
                    Button(action: {
                        withAnimation {
                            isGridView.toggle()
                        }
                    }) {
                        Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                            .foregroundColor(.primaryTeal)
                    }
                }
            }
        }
    }
    
    // MARK: - Statistics Banner
    // Shows key metrics about user's journeys
    private var statisticsBanner: some View {
        HStack(spacing: 0) {
            // Total trips
            StatisticCard(
                value: "12",
                label: "Total Trips",
                icon: "map",
                color: .primaryTeal
            )
            
            Divider()
                .frame(height: 60)
            
            // Completed
            StatisticCard(
                value: "8",
                label: "Completed",
                icon: "checkmark.circle",
                color: .freshGreen
            )
            
            Divider()
                .frame(height: 60)
            
            // Distance traveled
            StatisticCard(
                value: "247km",
                label: "Traveled",
                icon: "location",
                color: .sunsetOrange
            )
        }
        .frame(height: 100)
        .background(Color.SurfaceWhite)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Filter Tabs
    // Segmented control for filtering trips
    private var filterTabs: some View {
        HStack(spacing: 0) {
            ForEach(filters, id: \.self) { filter in
                Button(action: {
                    withAnimation {
                        selectedFilter = filter
                    }
                }) {
                    Text(filter)
                        .font(.bodyMedium)
                        .foregroundColor(selectedFilter == filter ? .white : .primaryTeal)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            selectedFilter == filter ? Color.primaryTeal : Color.clear
                        )
                }
            }
        }
        .background(Color.primaryTeal.opacity(0.1))
        .cornerRadius(12)
        .padding()
    }
    
    // MARK: - Trip Grid View
    // Grid layout for trips - more visual, shows images prominently
    private var tripGridView: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                // Placeholder trip cards (will be replaced with real data in Section 7)
                ForEach(0..<6) { index in
                    TripGridCard(
                        title: "Trip \(index + 1)",
                        category: "Beach",
                        date: "Dec \(index + 1)",
                        isCompleted: index % 2 == 0
                    )
                }
            }
            .padding()
        }
    }
    
    // MARK: - Trip List View
    // List layout for trips - more compact, shows more information
    private var tripListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                // Placeholder trip rows (will be replaced with real data in Section 7)
                ForEach(0..<8) { index in
                    TripListRow(
                        title: "Journey Number \(index + 1)",
                        category: "Beach",
                        date: "December \(index + 1), 2024",
                        distance: "\(index + 5)km",
                        isCompleted: index % 2 == 0
                    )
                }
            }
            .padding()
        }
    }
}

// MARK: - Statistic Card Component
// Individual stat display in the banner
struct StatisticCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            // Icon
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            // Value (large number)
            Text(value)
                .font(.headingLarge)
                .foregroundColor(.textPrimary)
            
            // Label (description)
            Text(label)
                .font(.captionSmall)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Trip Grid Card Component
// Card view for grid layout - emphasizes visuals
struct TripGridCard: View {
    let title: String
    let category: String
    let date: String
    let isCompleted: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image placeholder
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.primaryTeal.opacity(0.3))
                    .frame(height: 120)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.primaryTeal.opacity(0.5))
                    )
                
                // Completion badge
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.freshGreen)
                        .padding(8)
                }
            }
            
            // Info section
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headingSmall)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                
                HStack {
                    Label(category, systemImage: "tag")
                        .font(.captionSmall)
                        .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    Text(date)
                        .font(.captionSmall)
                        .foregroundColor(.textSecondary)
                }
            }
            .padding(12)
        }
        .background(Color.SurfaceWhite)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Trip List Row Component
// Row view for list layout - shows more details
struct TripListRow: View {
    let title: String
    let category: String
    let date: String
    let distance: String
    let isCompleted: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Thumbnail image
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.deepPurple.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "map")
                            .font(.title2)
                            .foregroundColor(.deepPurple.opacity(0.5))
                    )
                
                // Completion badge
                if isCompleted {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .font(.body)
                                .foregroundColor(.freshGreen)
                                .padding(4)
                        }
                    }
                }
            }
            
            // Info section
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headingSmall)
                    .foregroundColor(.textPrimary)
                    .lineLimit(2)
                
                HStack(spacing: 12) {
                    Label(category, systemImage: "tag")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                    
                    Label(distance, systemImage: "location")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Text(date)
                    .font(.captionSmall)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            // Chevron indicator
            Image(systemName: "chevron.right")
                .font(.body)
                .foregroundColor(.textSecondary)
        }
        .padding(12)
        .background(Color.SurfaceWhite)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Preview Provider
struct MyTripsView_Previews: PreviewProvider {
    static var previews: some View {
        MyTripsView()
    }
}
