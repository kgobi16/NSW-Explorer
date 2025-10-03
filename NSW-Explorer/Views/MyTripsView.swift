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
    
    /// ViewModel managing trip data
    @StateObject private var viewModel = MyTripsViewModel()
    
    /// Controls whether to display trips in grid or list layout
    @State private var isGridView: Bool = true
    
    /// Search query for filtering trips by name
    @State private var searchText: String = ""
    
    /// Mock active journey for demo (will use real data in Section 7)
    @State private var activeJourney: ActiveJourney? = ActiveJourney.sample
    
    /// Navigate to active journey
    @State private var navigateToActiveJourney: Bool = false
    
    /// Navigate to trip detail
    @State private var selectedTrip: AnyTrip?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // MARK: - Active Journey Widget
                if let activeJourney = activeJourney {
                    VStack(spacing: 0) {
                        JourneyProgressWidget(
                            activeJourney: activeJourney,
                            onTap: {
                                navigateToActiveJourney = true
                            }
                        )
                        .padding()
                        
                        Divider()
                    }
                    .background(Color.BackgroundGray)
                }
                
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
            .navigationDestination(isPresented: $navigateToActiveJourney) {
                if let activeJourney = activeJourney {
                    ActiveJourneyView(activeJourney: activeJourney)
                }
            }
            .sheet(item: $selectedTrip) { trip in
                TripDetailSheet(trip: trip, viewModel: viewModel)
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
        }
    }
    
    // MARK: - Statistics Banner
    private var statisticsBanner: some View {
        HStack(spacing: 0) {
            StatisticCard(
                value: "\(viewModel.statistics.totalTrips)",
                label: "Total",
                icon: "map",
                color: .PrimaryTeal
            )
            
            Divider()
                .frame(height: 60)
            
            StatisticCard(
                value: "\(viewModel.statistics.completedTrips)",
                label: "Completed",
                icon: "checkmark.circle",
                color: .FreshGreen
            )
            
            Divider()
                .frame(height: 60)
            
            StatisticCard(
                value: viewModel.statistics.distanceString,
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
            ForEach(MyTripsViewModel.TripFilter.allCases, id: \.self) { filter in
                Button(action: {
                    withAnimation {
                        viewModel.selectedFilter = filter
                    }
                }) {
                    Text(filter.rawValue)
                        .font(.bodyMedium)
                        .foregroundColor(viewModel.selectedFilter == filter ? .white : .PrimaryTeal)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            viewModel.selectedFilter == filter ? Color.PrimaryTeal : Color.clear
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
                    TripGridCard(trip: trip)
                        .onTapGesture {
                            selectedTrip = trip
                        }
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
                    TripListRow(trip: trip)
                        .onTapGesture {
                            selectedTrip = trip
                        }
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
            Image(systemName: viewModel.selectedFilter == .completed ? "checkmark.circle" : "bookmark")
                .font(.system(size: 60))
                .foregroundColor(.TextSecondary.opacity(0.5))
            
            Text("No \(viewModel.selectedFilter.rawValue.lowercased()) trips")
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
        switch viewModel.selectedFilter {
        case .all:
            return "Start exploring to create your first trip"
        case .completed:
            return "Complete a journey to see it here"
        case .saved:
            return "Save journeys to view them later"
        }
    }
    
    private var filteredTrips: [AnyTrip] {
        let trips = viewModel.filteredTrips
        
        if searchText.isEmpty {
            return trips
        }
        
        return trips.filter { trip in
            trip.name.localizedCaseInsensitiveContains(searchText)
        }
    }
}

// MARK: - Trip Grid Card Component
struct TripGridCard: View {
    let trip: AnyTrip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Status indicator
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(trip.isCompleted ? Color.FreshGreen.opacity(0.3) : Color.PrimaryTeal.opacity(0.3))
                    .frame(height: 120)
                    .overlay(
                        Image(systemName: trip.isCompleted ? "checkmark.circle.fill" : "bookmark.fill")
                            .font(.largeTitle)
                            .foregroundColor(trip.isCompleted ? .FreshGreen : .PrimaryTeal)
                    )
                
                // Completion badge
                if trip.isCompleted {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.title3)
                        .foregroundColor(.FreshGreen)
                        .padding(8)
                }
            }
            
            // Info section
            VStack(alignment: .leading, spacing: 6) {
                Text(trip.name)
                    .font(.headingSmall)
                    .foregroundColor(.TextPrimary)
                    .lineLimit(2)
                
                HStack {
                    Label("\(trip.stopCount) stops", systemImage: "mappin.circle")
                        .font(.caption)
                        .foregroundColor(.TextSecondary)
                    
                    Spacer()
                    
                    Text(trip.isCompleted ? "Completed" : "Saved")
                        .font(.caption)
                        .foregroundColor(trip.isCompleted ? .FreshGreen : .PrimaryTeal)
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
struct TripListRow: View {
    let trip: AnyTrip
    
    var body: some View {
        HStack(spacing: 12) {
            // Status icon
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(trip.isCompleted ? Color.FreshGreen.opacity(0.2) : Color.PrimaryTeal.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: trip.isCompleted ? "checkmark.circle.fill" : "bookmark.fill")
                    .font(.title2)
                    .foregroundColor(trip.isCompleted ? .FreshGreen : .PrimaryTeal)
            }
            
            // Info section
            VStack(alignment: .leading, spacing: 6) {
                Text(trip.name)
                    .font(.headingSmall)
                    .foregroundColor(.TextPrimary)
                    .lineLimit(2)
                
                HStack(spacing: 12) {
                    Label("\(trip.stopCount) stops", systemImage: "mappin.circle")
                        .font(.caption)
                        .foregroundColor(.TextSecondary)
                }
                
                Text(formattedDate(trip.date))
                    .font(.captionSmall)
                    .foregroundColor(.TextSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.body)
                .foregroundColor(.TextSecondary)
        }
        .padding(12)
        .background(Color.SurfaceWhite)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
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
