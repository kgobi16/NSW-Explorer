//
//  Journey.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 3/10/2025.
//
//  Journey model that represents a complete journey with all its properties
//  This is the unified model used throughout the app
//

import Foundation

// MARK: - Journey Model
/// Represents a complete journey with metadata and stops
struct Journey: Identifiable, Codable {
    // MARK: - Properties
    
    let id: UUID
    let name: String
    let description: String
    let stops: [Stop]
    let estimatedDuration: Int // minutes
    let totalDistance: Double // kilometers
    let createdAt: Date
    var interests: [String]
    let category: JourneyCategory
    
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
        description: String = "",
        stops: [Stop],
        estimatedDuration: Int,
        totalDistance: Double,
        createdAt: Date = Date(),
        interests: [String] = [],
        category: JourneyCategory = .mixed
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.stops = stops
        self.estimatedDuration = estimatedDuration
        self.totalDistance = totalDistance
        self.createdAt = createdAt
        self.interests = interests
        self.category = category
    }
}

// MARK: - Journey Category
enum JourneyCategory: String, Codable, CaseIterable {
    case beach = "Beach"
    case culture = "Culture"
    case food = "Food"
    case nature = "Nature"
    case history = "History"
    case entertainment = "Entertainment"
    case mixed = "Mixed"
    
    var icon: String {
        switch self {
        case .beach: return "beach.umbrella"
        case .culture: return "building.columns"
        case .food: return "fork.knife"
        case .nature: return "tree"
        case .history: return "clock"
        case .entertainment: return "theatermasks"
        case .mixed: return "sparkles"
        }
    }
    
    var colorName: String {
        switch self {
        case .beach: return "BeachBlue"
        case .culture: return "MeseumPurple"
        case .food: return "FoodRed"
        case .nature: return "NatureGreen"
        case .history: return "HistoryBrown"
        case .entertainment: return "EntertainmentPink"
        case .mixed: return "PrimaryTeal"
        }
    }
}

// MARK: - Preview Helpers
extension Journey {
    /// Sample journey for previews
    static var sample: Journey {
        Journey(
            name: "Beach & Culture Adventure",
            description: "Experience the best of Sydney's beaches and cultural attractions",
            stops: Stop.sampleStops,
            estimatedDuration: 240,
            totalDistance: 18.5,
            interests: ["Beaches", "Museums"],
            category: .mixed
        )
    }
}
