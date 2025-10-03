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
    let title: String
    let description: String
    let stops: [Stop]
    let duration: Int // days
    let estimatedDistance: Double // kilometers
    let estimatedTotalTime: Int // minutes
    let interests: [String] // User interests that created this
    let generatedDate: Date
    
    // Computed property for backward compatibility
    var name: String { title }
    var estimatedDuration: Int { estimatedTotalTime }
    var totalDistance: Double { estimatedDistance }
    var createdAt: Date { generatedDate }
    
    // MARK: - Computed Properties
    
    var durationString: String {
        let hours = estimatedTotalTime / 60
        let minutes = estimatedTotalTime % 60
        
        if hours > 0 && minutes > 0 {
            return "\(hours)h \(minutes)m"
        } else if hours > 0 {
            return "\(hours)h"
        } else {
            return "\(minutes)m"
        }
    }
    
    var distanceString: String {
        String(format: "%.1f km", estimatedDistance)
    }
    
    var stopCount: Int {
        stops.count
    }
    
    // MARK: - Initializer
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        stops: [Stop],
        duration: Int,
        estimatedDistance: Double,
        estimatedTotalTime: Int,
        interests: [String],
        generatedDate: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.stops = stops
        self.duration = duration
        self.estimatedDistance = estimatedDistance
        self.estimatedTotalTime = estimatedTotalTime
        self.interests = interests
        self.generatedDate = generatedDate
    }
    
    // Legacy initializer for backward compatibility
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
        self.title = name
        self.description = "A personalized journey through NSW"
        self.stops = stops
        self.duration = 1
        self.estimatedDistance = totalDistance
        self.estimatedTotalTime = estimatedDuration
        self.interests = interests
        self.generatedDate = createdAt
    }
}

// MARK: - Preview Helpers
extension GeneratedJourney {
    /// Sample journey for previews with real-looking data
    static var sample: GeneratedJourney {
        let sampleStops = [
            Stop(
                name: "Circular Quay",
                description: "Iconic harbour hub with ferries, restaurants, and stunning Opera House views.",
                latitude: -33.8613,
                longitude: 151.2109,
                type: .ferry,
                estimatedStayDuration: 30,
                order: 0,
                category: "Transport Hub",
                rating: 4.5,
                isCheckedIn: false
            ),
            Stop(
                name: "Sydney Opera House",
                description: "World-famous performing arts centre and architectural masterpiece.",
                latitude: -33.8568,
                longitude: 151.2153,
                type: .landmark,
                estimatedStayDuration: 90,
                order: 1,
                category: "Historic Sites",
                rating: 4.8,
                isCheckedIn: false
            ),
            Stop(
                name: "Royal Botanic Garden",
                description: "Beautiful gardens with harbour views and diverse plant collections.",
                latitude: -33.8642,
                longitude: 151.2166,
                type: .nature,
                estimatedStayDuration: 60,
                order: 2,
                category: "Parks",
                rating: 4.6,
                isCheckedIn: false
            ),
            Stop(
                name: "The Rocks Markets",
                description: "Historic precinct with weekend markets, galleries, and cafes.",
                latitude: -33.8594,
                longitude: 151.2089,
                type: .shopping,
                estimatedStayDuration: 90,
                order: 3,
                category: "Shopping",
                rating: 4.3,
                isCheckedIn: false
            ),
            Stop(
                name: "Manly Beach",
                description: "Popular beach destination with great surf and beachside dining.",
                latitude: -33.7969,
                longitude: 151.2873,
                type: .beach,
                estimatedStayDuration: 120,
                order: 4,
                category: "Beaches",
                rating: 4.7,
                isCheckedIn: false
            )
        ]
        
        return GeneratedJourney(
            title: "Sydney Harbour & Beach Explorer",
            description: "A perfect day exploring Sydney's iconic harbour attractions and beautiful beaches",
            stops: sampleStops,
            duration: 1,
            estimatedDistance: 24.5,
            estimatedTotalTime: 390,
            interests: ["Historic Sites", "Parks", "Shopping", "Beaches"]
        )
    }
}
