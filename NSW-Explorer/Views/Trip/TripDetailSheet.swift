//
//  TripDetailSheet.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 3/10/2025.
//
//  Detailed view of a trip showing stops, distance, time
//  Allows users to start journey or toggle favorites
//

import SwiftUI

struct TripDetailSheet: View {
    let journey: GeneratedJourney
    let onStartJourney: () -> Void
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var tripStorage = TripStorageService.shared
    @State private var showingActiveJourney = false
    @State private var activeJourney: ActiveJourney?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with title and description
                    headerSection
                    
                    // Statistics row
                    statisticsSection
                    
                    // Action buttons
                    actionButtonsSection
                    
                    // Stops list
                    stopsSection
                }
                .padding()
            }
            .background(Color.BackgroundGray)
            .navigationTitle("Trip Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: toggleFavorite) {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .foregroundColor(isFavorited ? .red : .TextSecondary)
                    }
                }
            }
            .navigationDestination(isPresented: $showingActiveJourney) {
                if let activeJourney = activeJourney {
                    ActiveJourneyView(activeJourney: activeJourney)
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(journey.title)
                .font(.headingLarge)
                .foregroundColor(.TextPrimary)
                .multilineTextAlignment(.leading)
            
            Text(journey.description)
                .font(.bodyMedium)
                .foregroundColor(.TextSecondary)
                .multilineTextAlignment(.leading)
            
            // Trip badges
            HStack {
                ForEach(journey.interests, id: \.self) { interest in
                    Text(interest)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.PrimaryTeal.opacity(0.1))
                        .foregroundColor(.PrimaryTeal)
                        .cornerRadius(8)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
    
    // MARK: - Statistics Section
    private var statisticsSection: some View {
        HStack(spacing: 0) {
            StatDetailCard(
                value: "\(journey.stops.count)",
                label: "Stops",
                icon: "mappin.circle",
                color: .PrimaryTeal
            )
            
            Divider()
                .frame(height: 60)
            
            StatDetailCard(
                value: journey.distanceString,
                label: "Distance",
                icon: "location",
                color: .SunsetOrange
            )
            
            Divider()
                .frame(height: 60)
            
            StatDetailCard(
                value: journey.durationString,
                label: "Duration",
                icon: "clock",
                color: .FreshGreen
            )
        }
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
    
    // MARK: - Action Buttons Section
    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            if isCompleted {
                // Journey completed - show view option
                SecondaryButton("View Completed Journey", icon: "checkmark.circle.fill") {
                    startJourney()
                }
                .disabled(true)
                
                Text("This journey has been completed")
                    .font(.caption)
                    .foregroundColor(.TextSecondary)
            } else {
                // Active journey - show start button
                PrimaryButton("Start Journey", icon: "play.circle.fill") {
                    startJourney()
                }
                
                SecondaryButton("Save for Later", icon: "bookmark") {
                    saveTrip()
                }
                
                Text("Journey will be tracked and saved to your trips")
                    .font(.caption)
                    .foregroundColor(.TextSecondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    // MARK: - Stops Section
    private var stopsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Stops (\(journey.stops.count))")
                .font(.headingMedium)
                .foregroundColor(.TextPrimary)
            
            LazyVStack(spacing: 12) {
                ForEach(Array(journey.stops.enumerated()), id: \.element.id) { index, stop in
                    TripStopCard(
                        stop: stop,
                        stopNumber: index + 1,
                        isLast: index == journey.stops.count - 1
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Computed Properties
    private var isCompleted: Bool {
        journey.stops.allSatisfy { $0.isCheckedIn }
    }
    
    private var isFavorited: Bool {
        tripStorage.favoriteTripIds.contains(journey.id)
    }
    
    // MARK: - Actions
    private func startJourney() {
        // Create active journey using JourneyService
        let newActiveJourney = JourneyService.shared.startJourney(from: journey)
        activeJourney = newActiveJourney
        showingActiveJourney = true
        
        // Call the provided callback
        onStartJourney()
        
        // Dismiss this sheet
        dismiss()
    }
    
    private func saveTrip() {
        tripStorage.saveTrip(journey)
        
        // Show some feedback (could add a toast notification here)
        print("Trip saved successfully")
    }
    
    private func toggleFavorite() {
        if isFavorited {
            tripStorage.removeFromFavorites(journey.id)
        } else {
            tripStorage.addToFavorites(journey.id)
        }
    }
}

// MARK: - Stat Detail Card Component
struct StatDetailCard: View {
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
                .font(.headingSmall)
                .fontWeight(.semibold)
                .foregroundColor(.TextPrimary)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.TextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }
}

// MARK: - Trip Stop Card Component
struct TripStopCard: View {
    let stop: Stop
    let stopNumber: Int
    let isLast: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Stop number and connector
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(Color(stop.type.colorName))
                        .frame(width: 32, height: 32)
                    
                    Text("\(stopNumber)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                if !isLast {
                    Rectangle()
                        .fill(Color.TextSecondary.opacity(0.3))
                        .frame(width: 2, height: 40)
                }
            }
            
            // Stop information
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(stop.name)
                        .font(.headingSmall)
                        .foregroundColor(.TextPrimary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if stop.isCheckedIn {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.body)
                            .foregroundColor(.FreshGreen)
                    }
                }
                
                Text(stop.description)
                    .font(.bodySmall)
                    .foregroundColor(.TextSecondary)
                    .lineLimit(2)
                
                HStack(spacing: 12) {
                    Label(stop.type.rawValue, systemImage: stop.type.icon)
                        .font(.caption)
                        .foregroundColor(Color(stop.type.colorName))
                    
                    Label(stop.durationString, systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.TextSecondary)
                }
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.SurfaceWhite)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Preview Provider
struct TripDetailSheet_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailSheet(
            journey: GeneratedJourney.sample,
            onStartJourney: {
                print("Starting journey...")
            }
        )
    }
}
