import Foundation
import CoreLocation

class GooglePlacesService {
    static let shared = GooglePlacesService()
    private let apiKey = "AIzaSyAyUsTPxnwUjcQJqcDFk6GYjyK7bjjbA_E"
    private let baseURL = "https://maps.googleapis.com/maps/api/place"
    
    private init() {}
    
    // Map interest types to Google Places types
    private func placeType(for interest: String) -> String {
        switch interest.lowercased() {
        case "beaches":
            return "beach"
        case "museums":
            return "museum"
        case "food & cafes":
            return "restaurant|cafe"
        case "hiking":
            return "park|hiking_area"
        case "historic sites":
            return "historical"
        case "entertainment":
            return "amusement_park|movie_theater|night_club"
        case "shopping":
            return "shopping_mall|store"
        case "parks":
            return "park"
        default:
            return "tourist_attraction"
        }
    }
    
    func searchPlaces(for interest: String, location: CLLocationCoordinate2D, radius: Int = 50000) async throws -> [PlaceResult] {
        let type = placeType(for: interest)
        let urlString = "\(baseURL)/nearbysearch/json?location=\(location.latitude),\(location.longitude)&radius=\(radius)&type=\(type)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw PlacesError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw PlacesError.invalidResponse
        }
        
        let result = try JSONDecoder().decode(PlacesResponse.self, from: data)
        
        if result.status != "OK" && result.status != "ZERO_RESULTS" {
            throw PlacesError.apiError(result.status)
        }
        
        return result.results
    }
    
    func getPlaceDetails(placeId: String) async throws -> PlaceDetails {
        let urlString = "\(baseURL)/details/json?place_id=\(placeId)&fields=name,formatted_address,geometry,rating,photos,types,opening_hours,website&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw PlacesError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw PlacesError.invalidResponse
        }
        
        let result = try JSONDecoder().decode(PlaceDetailsResponse.self, from: data)
        
        if result.status != "OK" {
            throw PlacesError.apiError(result.status)
        }
        
        guard let details = result.result else {
            throw PlacesError.noResults
        }
        
        return details
    }
}

// MARK: - Data Models
struct PlacesResponse: Codable {
    let results: [PlaceResult]
    let status: String
}

struct PlaceResult: Codable {
    let placeId: String
    let name: String
    let geometry: Geometry
    let rating: Double?
    let userRatingsTotal: Int?
    let vicinity: String?
    let types: [String]
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case name, geometry, rating
        case userRatingsTotal = "user_ratings_total"
        case vicinity, types
    }
}

struct Geometry: Codable {
    let location: Location
}

struct Location: Codable {
    let lat: Double
    let lng: Double
}

struct PlaceDetailsResponse: Codable {
    let result: PlaceDetails?
    let status: String
}

struct PlaceDetails: Codable {
    let name: String
    let formattedAddress: String?
    let geometry: Geometry
    let rating: Double?
    let photos: [Photo]?
    let types: [String]
    let openingHours: OpeningHours?
    let website: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case formattedAddress = "formatted_address"
        case geometry, rating, photos, types
        case openingHours = "opening_hours"
        case website
    }
}

struct Photo: Codable {
    let photoReference: String
    let height: Int
    let width: Int
    
    enum CodingKeys: String, CodingKey {
        case photoReference = "photo_reference"
        case height, width
    }
}

struct OpeningHours: Codable {
    let openNow: Bool?
    
    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}

// MARK: - Error Handling
enum PlacesError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case apiError(String)
    case noResults
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .apiError(let status):
            return "API Error: \(status)"
        case .noResults:
            return "No results found"
        }
    }
}
