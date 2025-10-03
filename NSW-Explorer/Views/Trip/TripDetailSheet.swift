//
//  TripDetailSheet.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 3/10/2025.
//
//  Modal sheet showing details of a completed or saved trip
//  Displays journey info, check-ins, photos, and notes
//

import SwiftUI

struct TripDetailSheet: View {
    // MARK: - Properties
    
    let trip: AnyTrip
    @ObservedObject var viewModel: MyTripsViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showDeleteAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Header Card
                    headerCard
                    
                    // MARK: - Interests Section
                    if !trip.interests.isEmpty {
                        interestsSection
                    }
                    
                    // MARK: - Content Based on Type
                    if trip.isCompleted {
                        completedTripContent
                    } else {
                        savedJourneyContent
                    }
                    
                    // MARK: - Stops List
                    stopsSection
                    
                    // MARK: - Action Buttons
                    actionButtons
                }
                .padding()
            }
            .background(Color.BackgroundGray)
            .navigationTitle(trip.isCompleted ? "Completed Trip" : "Saved Journey")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            // Share functionality
                            print("Share trip")
                        }) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        
                        Divider()
                        
                        Button(role: .destructive, action: {
                            showDeleteAlert = true
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.PrimaryTeal)
                    }
                }
            }
            .alert("Delete Trip?", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteTrip()
                }
            } message: {
                Text("This action cannot be undone.")
            }
        }
    }
    
    // MARK: - Header Card
    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Status badge
            HStack {
                Image(systemName: trip.isCompleted ? "checkmark.seal.fill" : "bookmark.fill")
                    .font(.title3)
                Text(trip.isCompleted ? "Completed" : "Saved")
                    .font(.bodyMedium)
                    .fontWeight(.semibold)
            }
            .foregroundColor(trip.isCompleted ? .FreshGreen : .PrimaryTeal)
            
            // Title
            Text(trip.name)
                .font(.displaymedium)
                .foregroundColor(.TextPrimary)
            
            // Metadata
            HStack(spacing: 16) {
                Label("\(trip.stopCount) stops", systemImage: "mappin.circle")
                    .font(.bodyMedium)
                    .foregroundColor(.TextSecondary)
                
                Label(formattedDate(trip.date), systemImage: "calendar")
                    .font(.bodyMedium)
                    .foregroundColor(.TextSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
    
    // MARK: - Interests Section
    private var interestsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Interests")
                .font(.headingMedium)
                .foregroundColor(.TextPrimary)
            
            FlowLayout(spacing: 8) {
                ForEach(trip.interests, id: \.self) { interest in
                    Text(interest)
                        .font(.bodyMedium)
                        .foregroundColor(.PrimaryTeal)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.PrimaryTeal.opacity(0.1))
                        .cornerRadius(12)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
    
    // MARK: - Completed Trip Content
    @ViewBuilder
    private var completedTripContent: some View {
        if case .completed(let completedTrip) = trip {
            // Statistics
            VStack(alignment: .leading, spacing: 16) {
                Text("Trip Statistics")
                    .font(.headingMedium)
                    .foregroundColor(.TextPrimary)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    StatCard(
                        icon: "clock.fill",
                        value: completedTrip.durationString,
                        label: "Duration",
                        color: .PrimaryTeal
                    )
                    
                    StatCard(
                        icon: "photo.fill",
                        value: "\(completedTrip.photoCount)",
                        label: "Photos",
                        color: .SunsetOrange
                    )
                    
                    if let rating = completedTrip.averageRating {
                        StatCard(
                            icon: "star.fill",
                            value: String(format: "%.1f", rating),
                            label: "Avg Rating",
                            color: .SunsetOrange
                        )
                    }
                    
                    StatCard(
                        icon: "checkmark.circle.fill",
                        value: "\(completedTrip.checkIns.count)",
                        label: "Check-ins",
                        color: .FreshGreen
                    )
                }
            }
            .padding()
            .background(Color.SurfaceWhite)
            .cornerRadius(16)
            
            // Check-ins/Memories
            if !completedTrip.checkIns.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Trip Memories")
                        .font(.headingMedium)
                        .foregroundColor(.TextPrimary)
                    
                    VStack(spacing: 12) {
                        ForEach(completedTrip.checkIns) { checkIn in
                            CheckInCard(
                                checkIn: checkIn,
                                stop: completedTrip.stops.first { $0.id == checkIn.stopId }
                            )
                        }
                    }
                }
                .padding()
                .background(Color.SurfaceWhite)
                .cornerRadius(16)
            }
        }
    }
    
    // MARK: - Saved Journey Content
    @ViewBuilder
    private var savedJourneyContent: some View {
        if case .saved(let savedJourney) = trip {
            VStack(alignment: .leading, spacing: 12) {
                Text("Trip Details")
                    .font(.headingMedium)
                    .foregroundColor(.TextPrimary)
                
                VStack(spacing: 12) {
                    InfoRow(
                        icon: "clock",
                        label: "Estimated Duration",
                        value: savedJourney.durationString
                    )
                    
                    InfoRow(
                        icon: "calendar",
                        label: "Saved On",
                        value: formattedDate(savedJourney.savedAt)
                    )
                }
            }
            .padding()
            .background(Color.SurfaceWhite)
            .cornerRadius(16)
        }
    }
    
    // MARK: - Stops Section
    private var stopsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Journey Stops")
                .font(.headingMedium)
                .foregroundColor(.TextPrimary)
            
            VStack(spacing: 8) {
                ForEach(getStops().indices, id: \.self) { index in
                    let stop = getStops()[index]
                    SimpleStopRow(
                        stop: stop,
                        number: index + 1,
                        isLast: index == getStops().count - 1
                    )
                }
            }
        }
        .padding()
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        VStack(spacing: 12) {
            if !trip.isCompleted {
                PrimaryButton("Start This Journey", icon: "location.fill") {
                    startJourney()
                }
            }
            
            SecondaryButton("Share Trip", icon: "square.and.arrow.up") {
                print("Share trip")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func getStops() -> [Stop] {
        switch trip {
        case .completed(let completedTrip):
            return completedTrip.stops
        case .saved(let savedJourney):
            return savedJourney.stops
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    private func deleteTrip() {
        switch trip {
        case .completed(let completedTrip):
            viewModel.deleteCompletedTrip(completedTrip)
        case .saved(let savedJourney):
            viewModel.deleteSavedJourney(savedJourney)
        }
        dismiss()
    }
    
    private func startJourney() {
        // Will implement journey start in future
        print("Starting journey: \(trip.name)")
        dismiss()
    }
}

// MARK: - Check-In Card Component
struct CheckInCard: View {
    let checkIn: CheckIn
    let stop: Stop?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                if let stop = stop {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(stop.name)
                            .font(.headingSmall)
                            .foregroundColor(.TextPrimary)
                        
                        Text(checkIn.formattedTimestamp)
                            .font(.caption)
                            .foregroundColor(.TextSecondary)
                    }
                }
                
                Spacer()
                
                // Rating
                if let rating = checkIn.rating {
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= rating ? "star.fill" : "star")
                                .font(.caption)
                                .foregroundColor(.SunsetOrange)
                        }
                    }
                }
            }
            
            // Notes
            if let notes = checkIn.notes, !notes.isEmpty {
                Text(notes)
                    .font(.bodyMedium)
                    .foregroundColor(.TextSecondary)
                    .lineSpacing(4)
            }
            
            // Photo indicator
            if checkIn.hasPhoto {
                HStack(spacing: 6) {
                    Image(systemName: "photo.fill")
                        .font(.caption)
                    Text("Photo attached")
                        .font(.caption)
                }
                .foregroundColor(.PrimaryTeal)
            }
        }
        .padding()
        .background(Color.BackgroundGray)
        .cornerRadius(12)
    }
}

// MARK: - Simple Stop Row Component
struct SimpleStopRow: View {
    let stop: Stop
    let number: Int
    let isLast: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Number indicator
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(Color(stop.type.colorName))
                        .frame(width: 32, height: 32)
                    
                    Text("\(number)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                if !isLast {
                    Rectangle()
                        .fill(Color(stop.type.colorName).opacity(0.3))
                        .frame(width: 2, height: 40)
                }
            }
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(stop.name)
                    .font(.bodyLarge)
                    .fontWeight(.semibold)
                    .foregroundColor(.TextPrimary)
                
                Text(stop.description)
                    .font(.bodyMedium)
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
            .padding(.bottom, isLast ? 0 : 12)
        }
    }
}

// MARK: - Preview Provider
struct TripDetailSheet_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailSheet(
            trip: .completed(CompletedTrip.sample),
            viewModel: MyTripsViewModel()
        )
    }
}
