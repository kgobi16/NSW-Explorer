import Foundation
import CoreLocation

class JourneyGeneratorService {
    static let shared = JourneyGeneratorService()
    private let placesService = GooglePlacesService.shared
    
    // Default location: Sydney, NSW
    private let defaultLocation = CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093)
    
    private init() {}
    
    func generateJourney(for interests: [String], duration: Int = 1) async throws -> GeneratedJourney {
        var allStops: [Stop] = []
        
        // Search for top places for each interest
        for interest in interests {
            do {
                let places = try await placesService.searchPlaces(for: interest, location: defaultLocation)
                
                // Sort by rating and take top 3 per category
                let ratedPlaces = places.filter { $0.rating != nil && $0.userRatingsTotal ?? 0 > 10 }
                let sortedPlaces = ratedPlaces.sorted { place1, place2 in
                    let score1 = (place1.rating ?? 0) * Double(place1.userRatingsTotal ?? 0)
                    let score2 = (place2.rating ?? 0) * Double(place2.userRatingsTotal ?? 0)
                    return score1 > score2
                }
                let topPlaces = Array(sortedPlaces.prefix(3))
                
                // Convert to stops
                for (index, place) in topPlaces.enumerated() {
                    let stop = Stop(
                        id: UUID(),
                        name: place.name,
                        description: place.vicinity ?? "Explore this amazing \(interest.lowercased()) destination",
                        latitude: place.geometry.location.lat,
                        longitude: place.geometry.location.lng,
                        type: stopType(for: interest),
                        estimatedStayDuration: estimatedDuration(for: interest),
                        order: allStops.count + index,
                        category: interest,
                        rating: place.rating,
                        placeId: place.placeId,
                        isCheckedIn: false,
                        checkInTime: nil
                    )
                    allStops.append(stop)
                }
            } catch {
                print("Error fetching places for \(interest): \(error.localizedDescription)")
                // Continue with other interests even if one fails
            }
        }
        
        // If we couldn't fetch any places, throw an error
        guard !allStops.isEmpty else {
            throw JourneyGenerationError.noPlacesFound
        }
        
        // Optimize route based on location proximity
        let optimizedStops = optimizeRoute(stops: allStops)
        
        // Calculate total distance and duration
        let totalDistance = calculateTotalDistance(stops: optimizedStops)
        let totalDuration = optimizedStops.reduce(0) { $0 + $1.estimatedDuration }
        
        // Create journey title based on interests
        let title = createJourneyTitle(interests: interests)
        
        return GeneratedJourney(
            id: UUID(),
            title: title,
            description: "A personalized \(duration)-day adventure through NSW featuring the best of \(interests.joined(separator: ", "))",
            stops: optimizedStops,
            duration: duration,
            estimatedDistance: totalDistance,
            estimatedTotalTime: totalDuration,
            interests: interests,
            generatedDate: Date()
        )
    }
    
    private func stopType(for interest: String) -> StopType {
        switch interest.lowercased() {
        case "beaches":
            return .beach
        case "museums":
            return .museum
        case "food & cafes":
            return .restaurant
        case "hiking":
            return .nature
        case "historic sites":
            return .landmark
        case "entertainment":
            return .entertainment
        case "shopping":
            return .shopping
        case "parks":
            return .nature
        default:
            return .landmark
        }
    }
    
    private func estimatedDuration(for interest: String) -> Int {
        switch interest.lowercased() {
        case "beaches":
            return 120 // 2 hours
        case "museums":
            return 90  // 1.5 hours
        case "food & cafes":
            return 60  // 1 hour
        case "hiking":
            return 180 // 3 hours
        case "historic sites":
            return 60  // 1 hour
        case "entertainment":
            return 120 // 2 hours
        case "shopping":
            return 90  // 1.5 hours
        case "parks":
            return 90  // 1.5 hours
        default:
            return 60
        }
    }
    
    private func optimizeRoute(stops: [Stop]) -> [Stop] {
        // Simple nearest-neighbor optimization
        guard !stops.isEmpty else { return [] }
        
        var optimized: [Stop] = []
        var remaining = stops
        
        // Start with the first stop
        var current = remaining.removeFirst()
        current.order = 0
        optimized.append(current)
        
        // Find nearest next stop iteratively
        while !remaining.isEmpty {
            let currentLocation = CLLocation(latitude: current.latitude, longitude: current.longitude)
            
            let nearestIndex = remaining.indices.min(by: { i, j in
                let loc1 = CLLocation(latitude: remaining[i].latitude, longitude: remaining[i].longitude)
                let loc2 = CLLocation(latitude: remaining[j].latitude, longitude: remaining[j].longitude)
                return currentLocation.distance(from: loc1) < currentLocation.distance(from: loc2)
            })!
            
            var next = remaining.remove(at: nearestIndex)
            next.order = optimized.count
            optimized.append(next)
            current = next
        }
        
        return optimized
    }
    
    private func calculateTotalDistance(stops: [Stop]) -> Double {
        var totalDistance: Double = 0
        
        for i in 0..<(stops.count - 1) {
            let start = CLLocation(latitude: stops[i].latitude, longitude: stops[i].longitude)
            let end = CLLocation(latitude: stops[i + 1].latitude, longitude: stops[i + 1].longitude)
            totalDistance += start.distance(from: end) / 1000 // Convert to kilometers
        }
        
        return totalDistance
    }
    
    private func createJourneyTitle(interests: [String]) -> String {
        if interests.count == 1 {
            return "\(interests[0]) Explorer"
        } else if interests.count == 2 {
            return "\(interests[0]) & \(interests[1]) Adventure"
        } else {
            return "NSW Multi-Experience Journey"
        }
    }
}

enum JourneyGenerationError: Error, LocalizedError {
    case noPlacesFound
    case invalidInterests
    
    var errorDescription: String? {
        switch self {
        case .noPlacesFound:
            return "No places found for your selected interests"
        case .invalidInterests:
            return "Please select at least one interest"
        }
    }
}
