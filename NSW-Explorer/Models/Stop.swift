//
//  Stop.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 1/10/2025.
//
//  Data model representing a single stop/location on a journey
//  Stops are the building blocks of journeys - places to visit
//

import Foundation
import CoreLocation
import MapKit

// MARK: - Stop Model
/// Represents a single location/stop within a journey
struct Stop: Identifiable, Codable, Hashable {
    // MARK: - Properties
    
    /// Unique identifier for the stop
    let id: UUID
    
    /// Display name of the stop
    /// Example: "Circular Quay", "Manly Beach", "Three Sisters Lookout"
    let name: String
    
    /// Detailed description of what to see/do at this stop
    let description: String
    
    /// Latitude coordinate
    let latitude: Double
    
    /// Longitude coordinate
    let longitude: Double
    
    /// Type of transport used to reach this stop
    let type: StopType
    
    /// Suggested duration to spend at this stop (in minutes)
    let estimatedStayDuration: Int
    
    /// Order of this stop in the journey (0-based index)
    /// First stop is 0, second is 1, etc.
    var order: Int
    
    /// Optional notes or tips for this stop
    /// Example: "Best views in the morning", "Bring swimmers"
    var notes: String?
    
    /// Optional photo URL (for user-uploaded photos in later sections)
    var photoURL: String?
    
    /// Whether user has checked in at this stop
    var isCompleted: Bool
    
    /// Interest category this stop belongs to
    var category: String?
    
    /// Google Places rating (0-5)
    var rating: Double?
    
    /// Google Place ID for fetching additional details
    var placeId: String?
    
    /// Check-in status
    var isCheckedIn: Bool
    
    /// Time of check-in
    var checkInTime: Date?
    
    /// Estimated duration in minutes
    var estimatedDuration: Int {
        estimatedStayDuration
    }
    
    // MARK: - Computed Properties
    
    /// Convert lat/long to CLLocationCoordinate2D for MapKit
    /// This makes it easy to display stops on a map
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// Human-readable duration string
    var durationString: String {
        let hours = estimatedStayDuration / 60
        let minutes = estimatedStayDuration % 60
        
        if hours > 0 && minutes > 0 {
            return "\(hours)h \(minutes)m"
        } else if hours > 0 {
            return "\(hours) hour\(hours > 1 ? "s" : "")"
        } else {
            return "\(minutes) min"
        }
    }
    
    // MARK: - Initializer
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        latitude: Double,
        longitude: Double,
        type: StopType,
        estimatedStayDuration: Int = 60,
        order: Int,
        notes: String? = nil,
        photoURL: String? = nil,
        isCompleted: Bool = false,
        category: String? = nil,
        rating: Double? = nil,
        placeId: String? = nil,
        isCheckedIn: Bool = false,
        checkInTime: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.type = type
        self.estimatedStayDuration = estimatedStayDuration
        self.order = order
        self.notes = notes
        self.photoURL = photoURL
        self.isCompleted = isCompleted
        self.category = category
        self.rating = rating
        self.placeId = placeId
        self.isCheckedIn = isCheckedIn
        self.checkInTime = checkInTime
    }
}

// MARK: - Stop Type Enum
/// Type of transport or activity at this stop
/// This helps visualize the journey and provides appropriate icons
enum StopType: String, Codable, CaseIterable {
    case train = "Train"
    case bus = "Bus"
    case ferry = "Ferry"
    case lightRail = "Light Rail"
    case walk = "Walk"
    case attraction = "Attraction"
    case food = "Food"
    case viewpoint = "Viewpoint"
    case beach = "Beach"
    case museum = "Museum"
    case nature = "Nature"
    case landmark = "Landmark"
    case entertainment = "Entertainment"
    case shopping = "Shopping"
    case restaurant = "Restaurant"
    
    /// SF Symbol icon for this stop type
    var icon: String {
        switch self {
        case .train: return "train.side.front.car"
        case .bus: return "bus"
        case .ferry: return "ferry"
        case .lightRail: return "tram"
        case .walk: return "figure.walk"
        case .attraction: return "star"
        case .food: return "fork.knife"
        case .viewpoint: return "mountain.2"
        case .beach: return "beach.umbrella"
        case .museum: return "building.columns"
        case .nature: return "leaf"
        case .landmark: return "mappin.and.ellipse"
        case .entertainment: return "theatermasks"
        case .shopping: return "cart"
        case .restaurant: return "fork.knife"
        }
    }
    
    /// Color for this stop type
    var colorName: String {
        switch self {
        case .train: return "PrimaryTeal"
        case .bus: return "SunsetOrange"
        case .ferry: return "BeachBlue"
        case .lightRail: return "FreshGreen"
        case .walk: return "TextSecondary"
        case .attraction: return "DeepPurple"
        case .food: return "FoodRed"
        case .viewpoint: return "NatureGreen"
        case .beach: return "BeachBlue"
        case .museum: return "MeseumPurple"
        case .nature: return "NatureGreen"
        case .landmark: return "HistoryBrown"
        case .entertainment: return "EntertainmentPink"
        case .shopping: return "SunsetOrange"
        case .restaurant: return "FoodRed"
        }
    }
}

// MARK: - Preview Helpers
extension Stop {
    /// Sample stop for previews
    static var sample: Stop {
        Stop(
            name: "Circular Quay",
            description: "Iconic harbour hub with ferries, restaurants, and stunning Opera House views.",
            latitude: -33.8613,
            longitude: 151.2109,
            type: .ferry,
            estimatedStayDuration: 30,
            order: 0,
            notes: "Great photo opportunities!"
        )
    }
    
    /// Array of sample stops for testing
    static var sampleStops: [Stop] {
        [
            Stop(
                name: "Circular Quay",
                description: "Iconic harbour hub with ferries, restaurants, and stunning Opera House views.",
                latitude: -33.8613,
                longitude: 151.2109,
                type: .ferry,
                estimatedStayDuration: 30,
                order: 0,
                notes: "Great photo opportunities!"
            ),
            Stop(
                name: "Sydney Opera House",
                description: "World-famous performing arts centre and architectural masterpiece.",
                latitude: -33.8568,
                longitude: 151.2153,
                type: .walk,
                estimatedStayDuration: 45,
                order: 1,
                notes: "Book tours in advance"
            ),
            Stop(
                name: "Royal Botanic Garden",
                description: "Beautiful gardens with harbour views and diverse plant collections.",
                latitude: -33.8642,
                longitude: 151.2166,
                type: .walk,
                estimatedStayDuration: 60,
                order: 2
            ),
            Stop(
                name: "The Rocks Markets",
                description: "Historic precinct with weekend markets, galleries, and cafes.",
                latitude: -33.8594,
                longitude: 151.2089,
                type: .walk,
                estimatedStayDuration: 90,
                order: 3,
                notes: "Markets on weekends only"
            ),
            Stop(
                name: "Manly Beach",
                description: "Popular beach destination with great surf and beachside dining.",
                latitude: -33.7969,
                longitude: 151.2873,
                type: .ferry,
                estimatedStayDuration: 120,
                order: 4,
                notes: "Bring swimmers and sunscreen"
            )
        ]
    }
}

// MARK: - MapKit Annotation
/// Extension to use Stop as a map annotation
/// This allows stops to be displayed directly on MKMapView
extension Stop {
    /// Create an MKPointAnnotation from this stop
    /// Used for displaying on MapKit maps
    func toAnnotation() -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        annotation.subtitle = description
        return annotation
    }
}
