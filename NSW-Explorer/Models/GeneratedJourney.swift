//
//  GeneratedJourney.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 3/10/2025.
//
//  Simplified journey model for AI-generated trips
//  This will be populated from TfNSW API data in Section 10
//

import Foundation

// MARK: - Generated Journey Model
/// Represents a trip generated from user interests
/// Much simpler than the old curated Journey model
struct GeneratedJourney: Identifiable, Codable {
    // MARK: - Properties
    
    let id: UUID
    let name: String
    let stops: [Stop]
    let estimatedDuration: Int // minutes
    let totalDistance: Double // kilometers
    let createdAt: Date
    var interests: [String] // User interests that created this
    
    // MARK: - Computed Properties
    
    var durationString: String {
        let hours = estimatedDuration / 60
        let minutes = estimatedDuration % 60
        
        if hours > 0 && minutes > 0 {
            return "\(hours)h \(minutes)m"
        } else if hours > 0 {
            return "\(hours)h"
        } else {
            return "\(minutes)m"
        }
    }
    
    var distanceString: String {
        String(format: "%.1f km", totalDistance)
    }
    
    var stopCount: Int {
        stops.count
    }
    
    // MARK: - Initializer
    
    init(
        id: UUID = UUID(),
        name: String,
        stops: [Stop],
        estimatedDuration: Int,
        totalDistance: Double,
        createdAt: Date = Date(),
        interests: [String] = []
    ) {
        self.id = id
        self.name = name
        self.stops = stops
        self.estimatedDuration = estimatedDuration
        self.totalDistance = totalDistance
        self.createdAt = createdAt
        self.interests = interests
    }
}

// MARK: - Preview Helpers
extension GeneratedJourney {
    /// Sample journey for previews
    static var sample: GeneratedJourney {
        GeneratedJourney(
            name: "Beach & Culture Adventure",
            stops: Stop.sampleStops,
            estimatedDuration: 240,
            totalDistance: 18.5,
            interests: ["Beaches", "Museums"]
        )
    }
}
