//
//  JourneyService.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 3/10/2025.

import Foundation

/// Service for converting between different journey types and managing active journeys
class JourneyService: ObservableObject {
    static let shared = JourneyService()
    
    @Published var activeJourney: ActiveJourney?
    
    private init() {}
    
    /// Convert a GeneratedJourney to a Journey model
    func convertToJourney(_ generatedJourney: GeneratedJourney) -> Journey {
        // Map interests to a primary category
        let category = mapInterestsToCategory(generatedJourney.interests)
        
        return Journey(
            id: generatedJourney.id,
            name: generatedJourney.title,
            description: generatedJourney.description,
            stops: generatedJourney.stops,
            estimatedDuration: generatedJourney.estimatedTotalTime,
            totalDistance: generatedJourney.estimatedDistance,
            createdAt: generatedJourney.generatedDate,
            interests: generatedJourney.interests,
            category: category
        )
    }
    
    /// Start a new active journey from a GeneratedJourney
    func startJourney(from generatedJourney: GeneratedJourney) -> ActiveJourney {
        let category = mapInterestsToCategory(generatedJourney.interests)
        
        let activeJourney = ActiveJourney(
            journeyId: generatedJourney.id,
            journeyName: generatedJourney.title,
            stops: generatedJourney.stops,
            startedAt: Date(),
            currentStopIndex: 0,
            category: category,
            totalDistance: generatedJourney.estimatedDistance
        )
        
        self.activeJourney = activeJourney
        return activeJourney
    }
    
    /// Start a journey from a saved trip in MyTripsView
    func startJourneyFromSavedTrip(_ savedTrip: GeneratedJourney) -> ActiveJourney {
        return startJourney(from: savedTrip)
    }
    
    /// Complete the current active journey
    func completeJourney() {
        guard var journey = activeJourney else { return }
        journey.completedAt = Date()
        activeJourney = journey
        
        // Move completed journey to TripStorageService
        let completedTrip = createCompletedTrip(from: journey)
        TripStorageService.shared.completeTrip(GeneratedJourney(
            id: journey.journeyId,
            title: journey.journeyName,
            description: "Completed journey",
            stops: journey.stops,
            duration: 1,
            estimatedDistance: journey.totalDistance,
            estimatedTotalTime: journey.durationMinutes,
            interests: mapCategoryToInterests(journey.category),
            generatedDate: journey.startedAt
        ))
        
        // Clear active journey
        activeJourney = nil
    }
    
    /// Cancel the current journey
    func cancelJourney() {
        activeJourney = nil
    }
    
    /// Check if there's an active journey
    var hasActiveJourney: Bool {
        activeJourney != nil
    }
    
    // MARK: - Private Helper Methods
    
    private func mapInterestsToCategory(_ interests: [String]) -> JourneyCategory {
        // Map interests to primary category based on first interest
        guard let firstInterest = interests.first else { return .mixed }
        
        switch firstInterest.lowercased() {
        case "beaches":
            return .beach
        case "museums":
            return .culture
        case "food & cafes", "food":
            return .food
        case "hiking", "parks", "nature":
            return .nature
        case "historic sites", "history":
            return .history
        case "entertainment":
            return .entertainment
        default:
            return .mixed
        }
    }
    
    private func mapCategoryToInterests(_ category: JourneyCategory) -> [String] {
        switch category {
        case .beach:
            return ["Beaches"]
        case .culture:
            return ["Museums"]
        case .food:
            return ["Food & Cafes"]
        case .nature:
            return ["Parks", "Hiking"]
        case .history:
            return ["Historic Sites"]
        case .entertainment:
            return ["Entertainment"]
        case .mixed:
            return ["Mixed"]
        }
    }
    
    private func createCompletedTrip(from activeJourney: ActiveJourney) -> GeneratedJourney {
        // Update stops with check-in status
        var updatedStops = activeJourney.stops
        for i in 0..<updatedStops.count {
            if let checkIn = activeJourney.getCheckIn(for: updatedStops[i].id) {
                updatedStops[i].isCheckedIn = true
                updatedStops[i].checkInTime = checkIn.timestamp
                updatedStops[i].isCompleted = true
            }
        }
        
        return GeneratedJourney(
            id: activeJourney.journeyId,
            title: activeJourney.journeyName,
            description: "Completed on \(formattedDate(activeJourney.completedAt ?? Date()))",
            stops: updatedStops,
            duration: 1,
            estimatedDistance: activeJourney.totalDistance,
            estimatedTotalTime: activeJourney.durationMinutes,
            interests: mapCategoryToInterests(activeJourney.category),
            generatedDate: activeJourney.startedAt
        )
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
