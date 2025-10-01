//
//  Journey.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 1/10/2025.
//
//  Data model representing a curated journey/adventure
//  This is the core model for our app - a journey is a collection of stops
//  connected by public transport, themed around specific interests
//

import Foundation
import CoreLocation
import SwiftUICore


// Represents a complete journey with multiple stops
/// Identifiable allows us to use it in ForEach loops
/// Codable will allow us to save/load from database later
struct Journey: Identifiable, Codable, Hashable {
    
    // Unique identifier for the journey
    let id: UUID
    // Display name of the journey
    let name: String
    // Detailed description of what makes this journey special
    let description: String
    
    // Category/theme of the journey
    let category: JourneyCategory
    
    // Array of stops that make up this journey
    let stops: [Stop]
    
    // Estimated total duration in minutes, Includes travel time and suggested stay time at each stop
    let estimatedDuration: Int
    
    // Total distance covered in kilometers
    let totalDistance: Double
    
    // Difficulty level for this journey
    let difficulty: Difficulty
    
    // Name of the image asset for this journey
    let imageName: String
    
    // Tags for additional filtering and search
    let tags: [String]
    
    // Whether this journey is currently featured/promoted
    let isFeatured: Bool
    
    // Whether user has favorited this journey (will be saved to DB later)
    var isFavorited: Bool
    
    // Date when this journey was created/added
    let createdAt: Date
    
    // Computed Properties
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
    
    /// Formatted distance string with unit
    var distanceString: String {
        String(format: "%.1f km", totalDistance)
    }
    
    /// Number of stops in this journey
    var stopCount: Int {
        stops.count
    }
    
    /// First stop's location (journey starting point)
    var startLocation: CLLocationCoordinate2D? {
        stops.first?.coordinate
    }
    
    /// Last stop's location (journey ending point)
    var endLocation: CLLocationCoordinate2D? {
        stops.last?.coordinate
    }
    
    //Initializer
    /// Create a new journey
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        category: JourneyCategory,
        stops: [Stop],
        estimatedDuration: Int,
        totalDistance: Double,
        difficulty: Difficulty,
        imageName: String,
        tags: [String] = [],
        isFeatured: Bool = false,
        isFavorited: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.stops = stops
        self.estimatedDuration = estimatedDuration
        self.totalDistance = totalDistance
        self.difficulty = difficulty
        self.imageName = imageName
        self.tags = tags
        self.isFeatured = isFeatured
        self.isFavorited = isFavorited
        self.createdAt = createdAt
    }
}

//Journey Category Enum
/// Each category has associated color and icon for UI display
enum JourneyCategory: String, Codable, CaseIterable {
    case beach = "Beach"
    case culture = "Culture"
    case food = "Food"
    case nature = "Nature"
    case historic = "Historic"
    case entertainment = "Entertainment"
    
    /// SF Symbol icon name for this category
    var icon: String {
        switch self {
        case .beach: return "beach.umbrella"
        case .culture: return "building.columns"
        case .food: return "fork.knife"
        case .nature: return "leaf"
        case .historic: return "building.2"
        case .entertainment: return "theatermasks"
        }
    }
    
    /// Color associated with this category (from our ColorTheme)
    var colorName: String {
        switch self {
        case .beach: return "BeachBlue"
        case .culture: return "MuseumPurple"
        case .food: return "FoodRed"
        case .nature: return "NatureGreen"
        case .historic: return "HistoryBrown"
        case .entertainment: return "EntertainmentPink"
        }
    }
}

//Difficulty Enum
/// Journey difficulty levels - Helps users choose journeys matching their fitness/experience level
enum Difficulty: String, Codable, CaseIterable {
    case easy = "Easy"
    case moderate = "Moderate"
    case challenging = "Challenging"
    
    /// SF Symbol icon for this difficulty level
    var icon: String {
        switch self {
        case .easy: return "figure.walk"
        case .moderate: return "figure.hiking"
        case .challenging: return "figure.climbing"
        }
    }
    
    /// Color hint for difficulty (green = easy, orange = moderate, red = challenging)
    var colorName: String {
        switch self {
        case .easy: return "FreshGreen"
        case .moderate: return "SunsetOrange"
        case .challenging: return "FoodRed"
        }
    }
}

//Preview Helpers
extension Journey {
    /// Sample journey for previews and testing
    /// This creates realistic mock data without needing a database
    static var sample: Journey {
        Journey(
            name: "Manly Ferry Adventure",
            description: "Experience Sydney's most iconic ferry ride from Circular Quay to Manly, followed by beach time and coastal walks.",
            category: .beach,
            stops: [
                Stop.sample,
                Stop(
                    id: UUID(),
                    name: "Manly Wharf",
                    description: "Arrive at beautiful Manly",
                    latitude: -33.7969,
                    longitude: 151.2873,
                    type: .ferry,
                    estimatedStayDuration: 60,
                    order: 1
                )
            ],
            estimatedDuration: 180,
            totalDistance: 15.5,
            difficulty: .easy,
            imageName: "journey_manly",
            tags: ["family-friendly", "scenic", "popular"],
            isFeatured: true
        )
    }
    
    /// Array of sample journeys for testing lists
    static var samples: [Journey] {
        [
            Journey(
                name: "Manly Ferry Adventure",
                description: "Experience Sydney's most iconic ferry ride from Circular Quay to Manly, followed by beach time and coastal walks.",
                category: .beach,
                stops: Stop.sampleStops,
                estimatedDuration: 180,
                totalDistance: 15.5,
                difficulty: .easy,
                imageName: "journey_manly",
                tags: ["family-friendly", "scenic", "popular"],
                isFeatured: true
            ),
            Journey(
                name: "Blue Mountains Explorer",
                description: "Full day adventure to the spectacular Blue Mountains with train travel, stunning views, and bushwalking.",
                category: .nature,
                stops: Stop.sampleStops,
                estimatedDuration: 480,
                totalDistance: 120.0,
                difficulty: .moderate,
                imageName: "journey_bluemountains",
                tags: ["nature", "hiking", "full-day"],
                isFeatured: true
            ),
            Journey(
                name: "Inner West Food Trail",
                description: "Discover Sydney's diverse food scene with stops at trendy cafes, markets, and restaurants in the Inner West.",
                category: .food,
                stops: Stop.sampleStops,
                estimatedDuration: 240,
                totalDistance: 8.5,
                difficulty: .easy,
                imageName: "journey_innerwest",
                tags: ["food", "culture", "trendy"],
                isFeatured: false
            ),
            Journey(
                name: "Harbour Heritage Discovery",
                description: "Step back in time exploring Sydney's colonial history through historic sites around the harbour.",
                category: .historic,
                stops: Stop.sampleStops,
                estimatedDuration: 300,
                totalDistance: 12.0,
                difficulty: .easy,
                imageName: "journey_heritage",
                tags: ["history", "educational", "museums"],
                isFeatured: false
            ),
            Journey(
                name: "Northern Beaches Coastal Walk",
                description: "Scenic coastal walk connecting Sydney's northern beaches via public transport and walking trails.",
                category: .beach,
                stops: Stop.sampleStops,
                estimatedDuration: 360,
                totalDistance: 18.0,
                difficulty: .moderate,
                imageName: "journey_northernbeaches",
                tags: ["beach", "hiking", "scenic"],
                isFeatured: false
            )
        ]
    }
}
