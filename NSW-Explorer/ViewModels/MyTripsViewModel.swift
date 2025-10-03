//
//  MyTripsViewModel.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 3/10/2025.
//
//  ViewModel managing trip history, saved journeys, and statistics
//  Will connect to SQLite database in Section 7
//

import Foundation
import SwiftUI

class MyTripsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// All completed trips
    @Published var completedTrips: [CompletedTrip] = []
    
    /// All saved journeys (not yet started)
    @Published var savedJourneys: [SavedJourney] = []
    
    /// User statistics
    @Published var statistics: UserTripStatistics = UserTripStatistics()
    
    /// Loading state
    @Published var isLoading: Bool = false
    
    /// Current filter selection
    @Published var selectedFilter: TripFilter = .all
    
    // MARK: - Filter Enum
    
    enum TripFilter: String, CaseIterable {
        case all = "All"
        case completed = "Completed"
        case saved = "Saved"
    }
    
    // MARK: - Computed Properties
    
    /// Filtered trips based on current selection
    var filteredTrips: [AnyTrip] {
        switch selectedFilter {
        case .all:
            let completed = completedTrips.map { AnyTrip.completed($0) }
            let saved = savedJourneys.map { AnyTrip.saved($0) }
            return (completed + saved).sorted { $0.date > $1.date }
        case .completed:
            return completedTrips.map { AnyTrip.completed($0) }.sorted { $0.date > $1.date }
        case .saved:
            return savedJourneys.map { AnyTrip.saved($0) }.sorted { $0.date > $1.date }
        }
    }
    
    /// Total trip count
    var totalTripCount: Int {
        completedTrips.count + savedJourneys.count
    }
    
    // MARK: - Initializer
    
    init() {
        loadMockData()
    }
    
    // MARK: - Data Loading
    
    /// Load mock data for development
    /// Will be replaced with database queries in Section 7
    func loadMockData() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.completedTrips = CompletedTrip.samples
            self?.savedJourneys = SavedJourney.samples
            self?.statistics = self?.calculateStatistics() ?? UserTripStatistics()
            self?.isLoading = false
        }
    }
    
    /// Calculate user statistics from trips
    private func calculateStatistics() -> UserTripStatistics {
        let totalTrips = totalTripCount
        let totalCompleted = completedTrips.count
        let totalSaved = savedJourneys.count
        
        // Calculate total distance (rough estimate)
        let distance = Double(completedTrips.count) * 15.0 // Average 15km per trip
        
        // Calculate total duration
        let duration = completedTrips.reduce(0) { $0 + $1.durationMinutes }
        
        // Calculate photo count
        let photos = completedTrips.reduce(0) { $0 + $1.photoCount }
        
        // Calculate check-in count
        let checkIns = completedTrips.reduce(0) { $0 + $1.checkIns.count }
        
        // Calculate favorite interests
        var interests: [String: Int] = [:]
        for trip in completedTrips {
            for interest in trip.interests {
                interests[interest, default: 0] += 1
            }
        }
        for journey in savedJourneys {
            for interest in journey.interests {
                interests[interest, default: 0] += 1
            }
        }
        
        return UserTripStatistics(
            totalTrips: totalTrips,
            completedTrips: totalCompleted,
            savedTrips: totalSaved,
            totalDistance: distance,
            totalDuration: duration,
            totalPhotos: photos,
            totalCheckIns: checkIns,
            favoriteInterests: interests
        )
    }
    
    // MARK: - Trip Management
    
    /// Save a journey for later
    func saveJourney(name: String, stops: [Stop], interests: [String], duration: Int) {
        let savedJourney = SavedJourney(
            journeyId: UUID(),
            journeyName: name,
            stops: stops,
            interests: interests,
            estimatedDuration: duration
        )
        
        savedJourneys.append(savedJourney)
        statistics = calculateStatistics()
        
        // Will save to database in Section 7
        print("Saved journey: \(name)")
    }
    
    /// Delete a saved journey
    func deleteSavedJourney(_ journey: SavedJourney) {
        savedJourneys.removeAll { $0.id == journey.id }
        statistics = calculateStatistics()
        
        // Will delete from database in Section 7
        print("Deleted saved journey")
    }
    
    /// Delete a completed trip
    func deleteCompletedTrip(_ trip: CompletedTrip) {
        completedTrips.removeAll { $0.id == trip.id }
        statistics = calculateStatistics()
        
        // Will delete from database in Section 7
        print("Deleted completed trip")
    }
    
    /// Get completed trip by ID
    func getCompletedTrip(id: UUID) -> CompletedTrip? {
        completedTrips.first { $0.id == id }
    }
    
    /// Get saved journey by ID
    func getSavedJourney(id: UUID) -> SavedJourney? {
        savedJourneys.first { $0.id == id }
    }
}

// MARK: - User Trip Statistics
struct UserTripStatistics {
    let totalTrips: Int
    let completedTrips: Int
    let savedTrips: Int
    let totalDistance: Double
    let totalDuration: Int // minutes
    let totalPhotos: Int
    let totalCheckIns: Int
    let favoriteInterests: [String: Int]
    
    init(
        totalTrips: Int = 0,
        completedTrips: Int = 0,
        savedTrips: Int = 0,
        totalDistance: Double = 0.0,
        totalDuration: Int = 0,
        totalPhotos: Int = 0,
        totalCheckIns: Int = 0,
        favoriteInterests: [String: Int] = [:]
    ) {
        self.totalTrips = totalTrips
        self.completedTrips = completedTrips
        self.savedTrips = savedTrips
        self.totalDistance = totalDistance
        self.totalDuration = totalDuration
        self.totalPhotos = totalPhotos
        self.totalCheckIns = totalCheckIns
        self.favoriteInterests = favoriteInterests
    }
    
    var distanceString: String {
        String(format: "%.1f km", totalDistance)
    }
    
    var durationString: String {
        let hours = totalDuration / 60
        let minutes = totalDuration % 60
        
        if hours > 0 && minutes > 0 {
            return "\(hours)h \(minutes)m"
        } else if hours > 0 {
            return "\(hours)h"
        } else {
            return "\(minutes)m"
        }
    }
    
    var completionRate: Double {
        guard totalTrips > 0 else { return 0 }
        return Double(completedTrips) / Double(totalTrips)
    }
    
    var topInterests: [String] {
        favoriteInterests.sorted { $0.value > $1.value }.prefix(3).map { $0.key }
    }
}

// MARK: - Type-Erased Trip
/// Wrapper to handle both completed trips and saved journeys in a single list
enum AnyTrip: Identifiable {
    case completed(CompletedTrip)
    case saved(SavedJourney)
    
    var id: UUID {
        switch self {
        case .completed(let trip): return trip.id
        case .saved(let journey): return journey.id
        }
    }
    
    var name: String {
        switch self {
        case .completed(let trip): return trip.journeyName
        case .saved(let journey): return journey.journeyName
        }
    }
    
    var stopCount: Int {
        switch self {
        case .completed(let trip): return trip.stopCount
        case .saved(let journey): return journey.stopCount
        }
    }
    
    var date: Date {
        switch self {
        case .completed(let trip): return trip.completedAt
        case .saved(let journey): return journey.savedAt
        }
    }
    
    var isCompleted: Bool {
        switch self {
        case .completed: return true
        case .saved: return false
        }
    }
    
    var interests: [String] {
        switch self {
        case .completed(let trip): return trip.interests
        case .saved(let journey): return journey.interests
        }
    }
    
    var totalDistance: Double {
        switch self {
        case .completed(let trip): return trip.totalDistance
        case .saved(let journey): return journey.totalDistance
        }
    }
    
    var category: JourneyCategory {
        switch self {
        case .completed(let trip): return trip.category
        case .saved(let journey): return journey.category
        }
    }
}
