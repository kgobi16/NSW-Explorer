//
//  SavedJourney.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 3/10/2025.
//
//  Model representing a journey saved for later
//  User can save interesting journeys to start them later
//

import Foundation

// MARK: - Saved Journey Model
struct SavedJourney: Identifiable, Codable {
    // MARK: - Properties
    
    let id: UUID
    let journeyId: UUID
    let journeyName: String
    let description: String
    let stops: [Stop]
    let interests: [String]
    let estimatedDuration: Int // minutes
    let totalDistance: Double
    let category: JourneyCategory
    let savedAt: Date
    
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
    
    var formattedSavedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: savedAt)
    }
    
    // MARK: - Initializer
    
    init(
        id: UUID = UUID(),
        journeyId: UUID,
        journeyName: String,
        description: String = "",
        stops: [Stop],
        interests: [String] = [],
        estimatedDuration: Int,
        totalDistance: Double = 0.0,
        category: JourneyCategory = .mixed,
        savedAt: Date = Date()
    ) {
        self.id = id
        self.journeyId = journeyId
        self.journeyName = journeyName
        self.description = description
        self.stops = stops
        self.interests = interests
        self.estimatedDuration = estimatedDuration
        self.totalDistance = totalDistance
        self.category = category
        self.savedAt = savedAt
    }
    
    // MARK: - Convert to Journey
    
    func toJourney() -> Journey {
        Journey(
            id: journeyId,
            name: journeyName,
            description: description,
            stops: stops,
            estimatedDuration: estimatedDuration,
            totalDistance: totalDistance,
            interests: interests,
            category: category
        )
    }
}

// MARK: - Sample Data
extension SavedJourney {
    static var samples: [SavedJourney] {
        [
            SavedJourney(
                journeyId: UUID(),
                journeyName: "Blue Mountains Explorer",
                description: "Discover breathtaking views and natural wonders",
                stops: [
                    Stop(
                        name: "Katoomba Station",
                        description: "Start your Blue Mountains adventure",
                        latitude: -33.7125,
                        longitude: 150.3111,
                        type: .train,
                        estimatedStayDuration: 15,
                        order: 0
                    ),
                    Stop(
                        name: "Three Sisters Lookout",
                        description: "Iconic rock formations with stunning views",
                        latitude: -33.7320,
                        longitude: 150.3120,
                        type: .viewpoint,
                        estimatedStayDuration: 45,
                        order: 1
                    )
                ],
                interests: ["Nature", "Photography"],
                estimatedDuration: 300,
                totalDistance: 25.0,
                category: .nature,
                savedAt: Date().addingTimeInterval(-86400 * 2)
            ),
            SavedJourney(
                journeyId: UUID(),
                journeyName: "Northern Beaches Circuit",
                description: "Beautiful coastal journey along Sydney's northern beaches",
                stops: [
                    Stop(
                        name: "Manly Beach",
                        description: "Famous beach with great surf",
                        latitude: -33.7969,
                        longitude: 151.2873,
                        type: .beach,
                        estimatedStayDuration: 90,
                        order: 0
                    ),
                    Stop(
                        name: "Dee Why Beach",
                        description: "Local favorite with beautiful lagoon",
                        latitude: -33.7581,
                        longitude: 151.2961,
                        type: .beach,
                        estimatedStayDuration: 60,
                        order: 1
                    )
                ],
                interests: ["Beaches", "Swimming"],
                estimatedDuration: 240,
                totalDistance: 18.0,
                category: .beach,
                savedAt: Date().addingTimeInterval(-86400 * 5)
            )
        ]
    }
}
