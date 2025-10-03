//
//  MyTripsView.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 1/10/2025.
//
//  User's personal travel log showing saved and completed journeys
//  Features: Grid/list toggle, filtering, trip statistics
//  NOW WITH REAL DATA
//

import SwiftUI

struct MyTripsView: View {
    // MARK: - State Properties
    
    /// Real trip storage service
    @StateObject private var tripStorage = TripStorageService.shared
    
    /// Journey service for managing active journeys
    @StateObject private var journeyService = JourneyService.shared
    
    /// Controls whether to display trips in grid or list layout
    @State private var isGridView: Bool = true
    
    /// Search query for filtering trips by name
    @State private var searchText: String = ""
    
    /// Selected filter for displaying different trip types
    @State private var selectedFilter: TripFilter = .all
    
    /// Navigate to trip detail
    @State private var selectedTrip: GeneratedJourney?
    
    /// Show favorites filter
    @State private var showFavoritesOnly: Bool = false
    
    /// Navigate to active journey
    @State private var navigateToActiveJourney = false
    @State private var activeJourney: ActiveJourney?
    
    enum TripFilter: String, CaseIterable {
        case all = "All"
        case saved = "Saved"
        case completed = "Completed"
        case favorites = "Favorites"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // MARK: - Statistics Banner
                statisticsBanner
                
                // MARK: - Filter Tabs
                filterTabs
                
                // MARK: - Trip List/Grid
                if isGridView {
                    tripGridView
                } else {
                    tripListView
                }
            }
            .background(Color.BackgroundGray)
            .navigationTitle("My Trips")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search trips")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            isGridView.toggle()
                        }
                    }) {
                        Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                            .foregroundColor(.PrimaryTeal)
                    }
                }
            }
            .sheet(item: $selectedTrip) { trip in
                NavigationStack {
                    TripMapView(journey: trip)
                }
            }
            .navigationDestination(isPresented: $navigateToActiveJourney) {
                if let activeJourney = activeJourney {
                    ActiveJourneyView(activeJourney: activeJourney)
                }
            }
        }
    }
    
    // MARK: - Statistics Banner
    private var statisticsBanner: some View {
        HStack(spacing: 0) {
            StatisticCard(
                value: "\(tripStorage.savedTrips.count + tripStorage.completedTrips.count)",
                label: "Total",
                icon: "map",
                color: .PrimaryTeal
            )
            
            Divider()
                .frame(height: 60)
            
            StatisticCard(
                value: "\(tripStorage.totalTripsCompleted)",
                label: "Completed",
                icon: "checkmark.circle",
                color: .FreshGreen
            )
            
            Divider()
                .frame(height: 60)
            
            StatisticCard(
                value: String(format: "%.1f km", tripStorage.totalDistanceTraveled),
                label: "Traveled",
                icon: "location",
                color: .SunsetOrange
            )
        }
        .frame(height: 100)
        .background(Color.SurfaceWhite)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Filter Tabs
    private var filterTabs: some View {
        HStack(spacing: 0) {
            ForEach(TripFilter.allCases, id: \.self) { filter in
                Button(action: {
                    withAnimation {
                        selectedFilter = filter
                    }
                }) {
                    Text(filter.rawValue)
                        .font(.bodyMedium)
                        .foregroundColor(selectedFilter == filter ? .white : .PrimaryTeal)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            selectedFilter == filter ? Color.PrimaryTeal : Color.clear
                        )
                }
            }
        }
        .background(Color.PrimaryTeal.opacity(0.1))
        .cornerRadius(12)
        .padding()
    }
    
    // MARK: - Trip Grid View
    private var tripGridView: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(filteredTrips) { trip in
                    TripGridCard(
                        trip: trip,
                        onTap: { selectedTrip = trip },
                        onFavorite: { toggleFavorite(trip) },
                        onDelete: { deleteTrip(trip) },
                        isFavorited: tripStorage.isFavorited(trip.id)
                    )
                }
            }
            .padding()
            
            if filteredTrips.isEmpty {
                emptyState
            }
        }
    }
    
    // MARK: - Trip List View
    private var tripListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredTrips) { trip in
                    TripListRow(
                        trip: trip,
                        onTap: { selectedTrip = trip },
                        onFavorite: { toggleFavorite(trip) },
                        onDelete: { deleteTrip(trip) },
                        isFavorited: tripStorage.isFavorited(trip.id)
                    )
                }
            }
            .padding()
            
            if filteredTrips.isEmpty {
                emptyState
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: selectedFilter == .completed ? "checkmark.circle" : "bookmark")
                .font(.system(size: 60))
                .foregroundColor(.TextSecondary.opacity(0.5))
            
            Text("No \(selectedFilter.rawValue.lowercased()) trips")
                .font(.headingMedium)
                .foregroundColor(.TextPrimary)
            
            Text(emptyStateMessage)
                .font(.bodyMedium)
                .foregroundColor(.TextSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
    
    private var emptyStateMessage: String {
        switch selectedFilter {
        case .all:
            return "Start exploring to create your first trip"
        case .completed:
            return "Complete a journey to see it here"
        case .saved:
            return "Save journeys to view them later"
        case .favorites:
            return "Favorite trips to see them here"
        }
    }
    
    // MARK: - Helper Methods
    
    private func toggleFavorite(_ trip: GeneratedJourney) {
        if tripStorage.isFavorited(trip.id) {
            tripStorage.removeFromFavorites(trip.id)
        } else {
            tripStorage.addToFavorites(trip.id)
        }
    }
    
    private func deleteTrip(_ trip: GeneratedJourney) {
        tripStorage.deleteTrip(withId: trip.id)
    }
    
    private var filteredTrips: [GeneratedJourney] {
        let trips: [GeneratedJourney]
        
        switch selectedFilter {
        case .all:
            trips = tripStorage.savedTrips + tripStorage.completedTrips
        case .saved:
            trips = tripStorage.savedTrips
        case .completed:
            trips = tripStorage.completedTrips
        case .favorites:
            trips = tripStorage.getFavoriteTrips()
        }
        
        if searchText.isEmpty {
            return trips
        }
        
        return trips.filter { trip in
            trip.title.localizedCaseInsensitiveContains(searchText)
        }
    }
}

// MARK: - Trip Grid Card Component
struct TripGridCard: View {
    let trip: GeneratedJourney
    let onTap: () -> Void
    let onFavorite: () -> Void
    let onDelete: () -> Void
    let isFavorited: Bool
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                // Status indicator with favorite and delete buttons
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isCompleted ? Color.FreshGreen.opacity(0.3) : Color.PrimaryTeal.opacity(0.3))
                        .frame(height: 120)
                        .overlay(
                            Image(systemName: isCompleted ? "checkmark.circle.fill" : "bookmark.fill")
                                .font(.largeTitle)
                                .foregroundColor(isCompleted ? .FreshGreen : .PrimaryTeal)
                        )
                    
                    // Action buttons
                    HStack(spacing: 8) {
                        Button(action: onFavorite) {
                            Image(systemName: isFavorited ? "heart.fill" : "heart")
                                .font(.title3)
                                .foregroundColor(isFavorited ? .red : .white)
                                .background(Color.black.opacity(0.3))
                                .clipShape(Circle())
                                .frame(width: 32, height: 32)
                        }
                        
                        Button(action: { showingDeleteAlert = true }) {
                            Image(systemName: "trash")
                                .font(.title3)
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.3))
                                .clipShape(Circle())
                                .frame(width: 32, height: 32)
                        }
                    }
                    .padding(8)
                }
                
                // Info section
                VStack(alignment: .leading, spacing: 6) {
                    Text(trip.title)
                        .font(.headingSmall)
                        .foregroundColor(.TextPrimary)
                        .lineLimit(2)
                    
                    HStack {
                        Label("\(trip.stops.count) stops", systemImage: "mappin.circle")
                            .font(.caption)
                            .foregroundColor(.TextSecondary)
                        
                        Spacer()
                        
                        Text(isCompleted ? "Completed" : "Saved")
                            .font(.caption)
                            .foregroundColor(isCompleted ? .FreshGreen : .PrimaryTeal)
                    }
                }
                .padding(12)
            }
            .background(Color.SurfaceWhite)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(PlainButtonStyle())
        .alert("Delete Trip", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this trip? This action cannot be undone.")
        }
    }
    
    private var isCompleted: Bool {
        trip.stops.allSatisfy { $0.isCheckedIn }
    }
}

// MARK: - Trip List Row Component
struct TripListRow: View {
    let trip: GeneratedJourney
    let onTap: () -> Void
    let onFavorite: () -> Void
    let onDelete: () -> Void
    let isFavorited: Bool
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Status icon
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isCompleted ? Color.FreshGreen.opacity(0.2) : Color.PrimaryTeal.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "bookmark.fill")
                        .font(.title2)
                        .foregroundColor(isCompleted ? .FreshGreen : .PrimaryTeal)
                }
                
                // Info section
                VStack(alignment: .leading, spacing: 6) {
                    Text(trip.title)
                        .font(.headingSmall)
                        .foregroundColor(.TextPrimary)
                        .lineLimit(2)
                    
                    HStack(spacing: 12) {
                        Label("\(trip.stops.count) stops", systemImage: "mappin.circle")
                            .font(.caption)
                            .foregroundColor(.TextSecondary)
                        
                        Label(trip.distanceString, systemImage: "location")
                            .font(.caption)
                            .foregroundColor(.TextSecondary)
                    }
                    
                    Text(formattedDate(trip.generatedDate))
                        .font(.captionSmall)
                        .foregroundColor(.TextSecondary)
                }
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 8) {
                    Button(action: onFavorite) {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .font(.title3)
                            .foregroundColor(isFavorited ? .red : .TextSecondary)
                    }
                    
                    Button(action: { showingDeleteAlert = true }) {
                        Image(systemName: "trash")
                            .font(.title3)
                            .foregroundColor(.TextSecondary)
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.body)
                        .foregroundColor(.TextSecondary)
                }
            }
            .padding(12)
            .background(Color.SurfaceWhite)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .alert("Delete Trip", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this trip? This action cannot be undone.")
        }
    }
    
    private var isCompleted: Bool {
        trip.stops.allSatisfy { $0.isCheckedIn }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// MARK: - Statistic Card Component
struct StatisticCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.bodyMedium)
                .fontWeight(.semibold)
                .foregroundColor(.TextPrimary)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.TextSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview Provider
struct MyTripsView_Previews: PreviewProvider {
    static var previews: some View {
        MyTripsView()
    }
}
