//
//  CompletedTrip.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 3/10/2025.
//
//  Model representing a completed journey with all check-ins and memories
//  Created when user finishes an ActiveJourney
//

import Foundation

// MARK: - Completed Trip Model
struct CompletedTrip: Identifiable, Codable {
    // MARK: - Properties
    
    let id: UUID
    let journeyId: UUID
    let journeyName: String
    let stops: [Stop]
    let checkIns: [CheckIn]
    let startedAt: Date
    let completedAt: Date
    let interests: [String]
    let category: JourneyCategory
    let totalDistance: Double
    
    // MARK: - Computed Properties
    
    var durationMinutes: Int {
        let duration = completedAt.timeIntervalSince(startedAt)
        return Int(duration / 60)
    }
    
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
    
    var distanceString: String {
        String(format: "%.1f km", totalDistance)
    }
    
    var stopCount: Int {
        stops.count
    }
    
    var photoCount: Int {
        checkIns.filter { $0.hasPhoto }.count
    }
    
    var averageRating: Double? {
        let ratings = checkIns.compactMap { $0.rating }
        guard !ratings.isEmpty else { return nil }
        return Double(ratings.reduce(0, +)) / Double(ratings.count)
    }
    
    var formattedCompletedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: completedAt)
    }
    
    // MARK: - Initializer
    
    init(
        id: UUID = UUID(),
        journeyId: UUID,
        journeyName: String,
        stops: [Stop],
        checkIns: [CheckIn],
        startedAt: Date,
        completedAt: Date,
        interests: [String] = [],
        category: JourneyCategory = .mixed,
        totalDistance: Double = 0.0
    ) {
        self.id = id
        self.journeyId = journeyId
        self.journeyName = journeyName
        self.stops = stops
        self.checkIns = checkIns
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.interests = interests
        self.category = category
        self.totalDistance = totalDistance
    }
}

// MARK: - Sample Data
extension CompletedTrip {
    static var samples: [CompletedTrip] {
        [
            CompletedTrip(
                journeyId: UUID(),
                journeyName: "Sydney Harbour Explorer",
                stops: Array(Stop.sampleStops.prefix(3)),
                checkIns: Array(CheckIn.samples.prefix(3)),
                startedAt: Date().addingTimeInterval(-14400), // 4 hours ago
                completedAt: Date().addingTimeInterval(-3600), // 1 hour ago
                interests: ["Beaches", "History"],
                category: .beach,
                totalDistance: 12.5
            ),
            CompletedTrip(
                journeyId: UUID(),
                journeyName: "Cultural Heritage Walk",
                stops: Array(Stop.sampleStops.suffix(2)),
                checkIns: Array(CheckIn.samples.suffix(2)),
                startedAt: Date().addingTimeInterval(-86400 * 3), // 3 days ago
                completedAt: Date().addingTimeInterval(-86400 * 3 + 7200), // 3 days ago + 2 hours
                interests: ["Culture", "History"],
                category: .culture,
                totalDistance: 8.0
            ),
            CompletedTrip(
                journeyId: UUID(),
                journeyName: "Foodie Adventure",
                stops: Array(Stop.sampleStops.prefix(4)),
                checkIns: Array(CheckIn.samples.prefix(4)),
                startedAt: Date().addingTimeInterval(-86400 * 7), // 1 week ago
                completedAt: Date().addingTimeInterval(-86400 * 7 + 10800), // 1 week ago + 3 hours
                interests: ["Food", "Culture"],
                category: .food,
                totalDistance: 15.0
            )
        ]
    }
    
    // Single sample for preview usage
    static var sample: CompletedTrip {
        samples.first!
    }
}
