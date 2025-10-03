import Foundation
import SwiftUI

/// Service for managing user's saved and generated trips
class TripStorageService: ObservableObject {
    static let shared = TripStorageService()
    
    @Published var savedTrips: [GeneratedJourney] = []
    @Published var completedTrips: [GeneratedJourney] = []
    @Published var favoriteTripIds: Set<UUID> = []
    
    private init() {
        loadSampleData()
        loadFavorites()
    }
    
    /// Add a new trip from the generator
    func saveGeneratedTrip(_ trip: GeneratedJourney) {
        savedTrips.append(trip)
    }
    
    /// Save a trip (alias for saveGeneratedTrip for better naming)
    func saveTrip(_ trip: GeneratedJourney) {
        saveGeneratedTrip(trip)
    }
    
    /// Delete a trip from saved trips
    func deleteTrip(withId id: UUID) {
        savedTrips.removeAll { $0.id == id }
        completedTrips.removeAll { $0.id == id }
        removeFromFavorites(id)
    }
    
    /// Add trip to favorites
    func addToFavorites(_ tripId: UUID) {
        favoriteTripIds.insert(tripId)
        saveFavorites()
    }
    
    /// Remove trip from favorites
    func removeFromFavorites(_ tripId: UUID) {
        favoriteTripIds.remove(tripId)
        saveFavorites()
    }
    
    /// Check if trip is favorited
    func isFavorited(_ tripId: UUID) -> Bool {
        favoriteTripIds.contains(tripId)
    }
    
    /// Get all favorited trips
    func getFavoriteTrips() -> [GeneratedJourney] {
        let allTrips = savedTrips + completedTrips
        return allTrips.filter { favoriteTripIds.contains($0.id) }
    }
    
    /// Mark a trip as completed
    func completeTrip(_ trip: GeneratedJourney) {
        if let index = savedTrips.firstIndex(where: { $0.id == trip.id }) {
            savedTrips.remove(at: index)
        }
        
        // Create a completed version with all stops checked in
        var updatedStops = trip.stops
        for i in 0..<updatedStops.count {
            updatedStops[i].isCheckedIn = true
            updatedStops[i].checkInTime = Date().addingTimeInterval(-Double(i * 1800)) // 30 min intervals
            updatedStops[i].isCompleted = true
        }
        
        let finalTrip = GeneratedJourney(
            id: trip.id,
            title: trip.title,
            description: trip.description,
            stops: updatedStops,
            duration: trip.duration,
            estimatedDistance: trip.estimatedDistance,
            estimatedTotalTime: trip.estimatedTotalTime,
            interests: trip.interests,
            generatedDate: trip.generatedDate
        )
        
        completedTrips.insert(finalTrip, at: 0) // Most recent first
    }
    
    /// Remove a saved trip
    func removeSavedTrip(_ trip: GeneratedJourney) {
        savedTrips.removeAll { $0.id == trip.id }
    }
    
    /// Get total stats
    var totalTripsCompleted: Int {
        completedTrips.count
    }
    
    var totalDistanceTraveled: Double {
        completedTrips.reduce(0) { $0 + $1.estimatedDistance }
    }
    
    var totalStopsVisited: Int {
        completedTrips.reduce(0) { $0 + $1.stops.count }
    }
    
    // MARK: - Persistence Methods
    
    /// Save favorites to UserDefaults
    private func saveFavorites() {
        let favoritesArray = favoriteTripIds.map { $0.uuidString }
        UserDefaults.standard.set(favoritesArray, forKey: "FavoriteTripIds")
    }
    
    /// Load favorites from UserDefaults
    private func loadFavorites() {
        if let favoritesArray = UserDefaults.standard.array(forKey: "FavoriteTripIds") as? [String] {
            favoriteTripIds = Set(favoritesArray.compactMap { UUID(uuidString: $0) })
        }
    }
    
    /// Load some sample data for demonstration
    private func loadSampleData() {
        // Start with empty arrays - users will populate with real data
        savedTrips = []
        completedTrips = []
    }
}
