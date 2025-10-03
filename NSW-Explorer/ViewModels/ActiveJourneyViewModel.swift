//
//  ActiveJourneyViewModel.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 3/10/2025.
//
//  ViewModel managing active journey state and check-ins
//  Handles journey progress, check-ins, photos, and notes
//  Will connect to SQLite database in Section 7
//

import Foundation
import SwiftUI
import PhotosUI

/// Manages the state and logic for an active journey
class ActiveJourneyViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// The currently active journey (nil if no journey active)
    @Published var activeJourney: ActiveJourney?
    
    /// Whether we're showing the check-in sheet
    @Published var showCheckInSheet: Bool = false
    
    /// Currently selected stop for check-in
    @Published var selectedStop: Stop?
    
    /// Loading state for async operations
    @Published var isLoading: Bool = false
    
    /// Error message to display
    @Published var errorMessage: String?
    
    // MARK: - Journey Management
    
    /// Start a new journey
    /// Creates an ActiveJourney and sets it as current
    func startJourney(_ journey: Journey) {
        let newActiveJourney = ActiveJourney(
            journeyId: journey.id,
            journeyName: journey.name,
            stops: journey.stops,
            startedAt: Date(),
            currentStopIndex: 0,
            category: journey.category,
            totalDistance: journey.totalDistance
        )
        
        activeJourney = newActiveJourney
        
        // In Section 7, this will save to database
        print("Started journey: \(journey.name)")
    }
    
    /// Complete the current journey
    /// Marks journey as completed with timestamp
    func completeJourney() {
        guard var journey = activeJourney else { return }
        
        journey.completedAt = Date()
        activeJourney = journey
        
        // In Section 7, this will update database
        print("Completed journey: \(journey.journeyName)")
    }
    
    /// Abandon/cancel the current journey
    func cancelJourney() {
        activeJourney = nil
        
        // In Section 7, this will update database status
        print("Journey cancelled")
    }
    
    // MARK: - Check-In Management
    
    /// Open check-in sheet for a specific stop
    func openCheckIn(for stop: Stop) {
        selectedStop = stop
        showCheckInSheet = true
    }
    
    /// Create a check-in at a stop
    /// - Parameters:
    ///   - stop: The stop to check in at
    ///   - notes: Optional notes about the visit
    ///   - photoFilename: Optional photo filename
    ///   - rating: Optional rating (1-5)
    func checkIn(
        at stop: Stop,
        notes: String?,
        photoFilename: String?,
        rating: Int?
    ) {
        guard var journey = activeJourney else { return }
        
        // Create the check-in
        let checkIn = CheckIn(
            stopId: stop.id,
            journeyId: journey.journeyId,
            timestamp: Date(),
            notes: notes,
            photoFilename: photoFilename,
            rating: rating,
            isSynced: false
        )
        
        // Add to journey
        journey.checkIns.append(checkIn)
        
        // Move to next stop if available
        if journey.currentStopIndex < journey.stops.count - 1 {
            journey.currentStopIndex += 1
        }
        
        // Update active journey
        activeJourney = journey
        
        // Close sheet
        showCheckInSheet = false
        selectedStop = nil
        
        // In Section 7, this will save to database
        print("Checked in at: \(stop.name)")
        
        // Check if journey is now complete
        if journey.checkIns.count == journey.stops.count {
            completeJourney()
        }
    }
    
    /// Delete a check-in
    func deleteCheckIn(_ checkIn: CheckIn) {
        guard var journey = activeJourney else { return }
        
        journey.checkIns.removeAll { $0.id == checkIn.id }
        activeJourney = journey
        
        // In Section 7, this will delete from database
        print("Deleted check-in")
    }
    
    /// Update check-in notes
    func updateCheckInNotes(_ checkIn: CheckIn, notes: String) {
        guard var journey = activeJourney else { return }
        
        if let index = journey.checkIns.firstIndex(where: { $0.id == checkIn.id }) {
            journey.checkIns[index].notes = notes
            activeJourney = journey
            
            // In Section 7, this will update database
            print("Updated check-in notes")
        }
    }
    
    /// Update check-in rating
    func updateCheckInRating(_ checkIn: CheckIn, rating: Int) {
        guard var journey = activeJourney else { return }
        
        if let index = journey.checkIns.firstIndex(where: { $0.id == checkIn.id }) {
            journey.checkIns[index].rating = rating
            activeJourney = journey
            
            // In Section 7, this will update database
            print("Updated check-in rating")
        }
    }
    
    // MARK: - Helper Methods
    
    /// Check if a stop is completed
    func isStopCompleted(_ stop: Stop) -> Bool {
        activeJourney?.isStopCompleted(stopId: stop.id) ?? false
    }
    
    /// Get check-in for a stop
    func getCheckIn(for stop: Stop) -> CheckIn? {
        activeJourney?.getCheckIn(for: stop.id)
    }
    
    /// Calculate estimated time remaining
    func estimatedTimeRemaining() -> Int {
        guard let journey = activeJourney else { return 0 }
        
        let remainingStops = journey.stops.suffix(from: journey.currentStopIndex)
        let totalRemaining = remainingStops.reduce(0) { $0 + $1.estimatedStayDuration }
        
        return totalRemaining
    }
    
    /// Get formatted time remaining string
    func timeRemainingString() -> String {
        let minutes = estimatedTimeRemaining()
        let hours = minutes / 60
        let mins = minutes % 60
        
        if hours > 0 && mins > 0 {
            return "\(hours)h \(mins)m"
        } else if hours > 0 {
            return "\(hours)h"
        } else {
            return "\(mins)m"
        }
    }
}
