//
//  CheckIn.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 1/10/2025.
//
//  Data model representing a user's check-in at a stop
//  Check-ins capture when users visit stops, with photos and notes
//  This creates the travel log/journal functionality
//

import Foundation
import SwiftUI

//Check-In Model
/// Represents a single check-in at a journey stop
/// This captures the user's visit including timestamp, photos, and notes
struct CheckIn: Identifiable, Codable, Hashable {
    
    /// Unique identifier for this check-in
    let id: UUID
    /// ID of the stop where check-in occurred
    let stopId: UUID
    /// ID of the journey this check-in belongs to
    let journeyId: UUID
    /// When the check-in was created
    let timestamp: Date
    /// Optional user notes about this stop
    var notes: String?
    /// Optional photo filename/path
    var photoFilename: String?
    /// Rating out of 5 stars (optional)
    var rating: Int?
    /// Whether this check-in has been synced to cloud
    var isSynced: Bool
    
    //Computed Properties
    
    /// Human-readable timestamp
    var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    /// Short date string (e.g., "Dec 15")
    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: timestamp)
    }
    
    /// Time only string (e.g., "2:30 PM")
    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    /// Whether this check-in has a photo
    var hasPhoto: Bool {
        photoFilename != nil
    }
    
    /// Whether this check-in has notes
    var hasNotes: Bool {
        notes != nil && !notes!.isEmpty
    }
    
    /// Whether this check-in has a rating
    var hasRating: Bool {
        rating != nil
    }
    
    //Initializer
    
    init(
        id: UUID = UUID(),
        stopId: UUID,
        journeyId: UUID,
        timestamp: Date = Date(),
        notes: String? = nil,
        photoFilename: String? = nil,
        rating: Int? = nil,
        isSynced: Bool = false
    ) {
        self.id = id
        self.stopId = stopId
        self.journeyId = journeyId
        self.timestamp = timestamp
        self.notes = notes
        self.photoFilename = photoFilename
        self.rating = rating
        self.isSynced = isSynced
    }
}

//Active Journey Model - Represents a journey that's currently in progress

struct ActiveJourney: Identifiable, Codable {
  
    let id: UUID
    let journey: Journey
    let startedAt: Date
    var completedAt: Date?
    var checkIns: [CheckIn]
    var currentStopIndex: Int
    
    //Computed Properties
    
    /// Whether this journey is completed
    var isCompleted: Bool {
        completedAt != nil
    }
    
    /// Progress percentage (0.0 to 1.0)
    var progress: Double {
        guard !journey.stops.isEmpty else { return 0 }
        return Double(checkIns.count) / Double(journey.stops.count)
    }
    
    /// Number of stops completed
    var completedStopsCount: Int {
        checkIns.count
    }
    
    /// Current stop (if journey not completed)
    var currentStop: Stop? {
        guard currentStopIndex < journey.stops.count else { return nil }
        return journey.stops[currentStopIndex]
    }
    
    /// Next stop (if available)
    var nextStop: Stop? {
        let nextIndex = currentStopIndex + 1
        guard nextIndex < journey.stops.count else { return nil }
        return journey.stops[nextIndex]
    }
    
    /// Journey duration so far (in minutes)
    var durationMinutes: Int {
        let endTime = completedAt ?? Date()
        let duration = endTime.timeIntervalSince(startedAt)
        return Int(duration / 60)
    }
    
    /// Human-readable duration string
    var durationString: String {
        let hours = durationMinutes / 60
        let minutes = durationMinutes % 60
        
        if hours > 0 && minutes > 0 {
            return "\(hours)h \(minutes)m"
        } else if hours > 0 {
            return "\(hours)h"
        } else {
            return "\(minutes)m"
        }
    }
    
    /// Check if a specific stop has been checked in
    func isStopCompleted(stopId: UUID) -> Bool {
        checkIns.contains { $0.stopId == stopId }
    }
    
    /// Get check-in for a specific stop
    func getCheckIn(for stopId: UUID) -> CheckIn? {
        checkIns.first { $0.stopId == stopId }
    }
    
    //Initializer
    
    init(
        id: UUID = UUID(),
        journey: Journey,
        startedAt: Date = Date(),
        completedAt: Date? = nil,
        checkIns: [CheckIn] = [],
        currentStopIndex: Int = 0
    ) {
        self.id = id
        self.journey = journey
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.checkIns = checkIns
        self.currentStopIndex = currentStopIndex
    }
}

// MARK: - Preview Helpers
extension CheckIn {
    /// Sample check-in for previews
    static var sample: CheckIn {
        CheckIn(
            stopId: Stop.sample.id,
            journeyId: Journey.sample.id,
            timestamp: Date(),
            notes: "Amazing views! Perfect weather for the ferry ride.",
            photoFilename: "photo_sample.jpg",
            rating: 5,
            isSynced: false
        )
    }
    
    /// Array of sample check-ins
    static var samples: [CheckIn] {
        [
            CheckIn(
                stopId: UUID(),
                journeyId: UUID(),
                timestamp: Date().addingTimeInterval(-3600),
                notes: "Great start to the journey!",
                rating: 4
            ),
            CheckIn(
                stopId: UUID(),
                journeyId: UUID(),
                timestamp: Date().addingTimeInterval(-1800),
                notes: "Beautiful beach, perfect for swimming",
                photoFilename: "photo_beach.jpg",
                rating: 5
            ),
            CheckIn(
                stopId: UUID(),
                journeyId: UUID(),
                timestamp: Date(),
                notes: "Excellent food at the local cafe"
            )
        ]
    }
}

extension ActiveJourney {
    /// Sample active journey for previews
    static var sample: ActiveJourney {
        ActiveJourney(
            journey: Journey.sample,
            startedAt: Date().addingTimeInterval(-7200), // Started 2 hours ago
            checkIns: CheckIn.samples,
            currentStopIndex: 2
        )
    }
}
