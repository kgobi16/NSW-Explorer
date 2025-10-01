//
//  JourneyViewModel.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 1/10/2025.
//  ViewModel managing journey data and business logic
//  This follows MVVM pattern - separates data/logic from UI
//  In Section 7, this will connect to SQLite database
//

import Foundation
import SwiftUI

// ObservableObject allows SwiftUI views to react to changes
// This class manages all journey-related data and operations
class JourneyViewModel: ObservableObject {
    
    // Published Properties
    // @Published means SwiftUI views will update when these change
    
    /// All available journeys
    @Published var journeys: [Journey] = []
    /// Currently selected category filter (nil = show all)
    @Published var selectedCategory: JourneyCategory? = nil
    /// Search query for filtering journeys
    @Published var searchText: String = ""
    /// Loading state for async operations
    @Published var isLoading: Bool = false
    
    /// Filtered journeys based on current filters
    /// This automatically updates when journeys, selectedCategory, or searchText change
    var filteredJourneys: [Journey] {
        var result = journeys
        
        // Filter by category if one is selected
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        // Filter by search text if not empty
        if !searchText.isEmpty {
            result = result.filter { journey in
                journey.name.localizedCaseInsensitiveContains(searchText) ||
                journey.description.localizedCaseInsensitiveContains(searchText) ||
                journey.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        return result
    }
    
    /// Only featured journeys
    var featuredJourneys: [Journey] {
        journeys.filter { $0.isFeatured }
    }
    
    /// Only favorited journeys
    var favoritedJourneys: [Journey] {
        journeys.filter { $0.isFavorited }
    }
    
    /// Journeys grouped by category
    /// Dictionary where key is category and value is array of journeys
    var journeysByCategory: [JourneyCategory: [Journey]] {
        Dictionary(grouping: journeys) { $0.category }
    }
    
    // MARK: - Initializer
    
    init() {
        // Load mock data on initialization
        // In Section 7, this will load from database
        loadMockData()
    }
    
    // MARK: - Data Loading Methods
    
    /// Load mock journey data
    /// This simulates loading from a database
    /// Will be replaced with real database queries in Section 7
    func loadMockData() {
        // Simulate network/database delay
        isLoading = true
        
        // In a real app, this would be an async database call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.journeys = self?.createMockJourneys() ?? []
            self?.isLoading = false
        }
    }
    
    /// Create comprehensive mock journey data
    /// This provides realistic test data for development
    private func createMockJourneys() -> [Journey] {
        [
            // Journey 1: Manly Ferry Adventure
            Journey(
                name: "Manly Ferry Adventure",
                description: "Experience Sydney's most iconic ferry ride from Circular Quay to Manly. Enjoy stunning harbour views, visit the beach, and explore the bustling Corso.",
                category: .beach,
                stops: [
                    Stop(
                        name: "Circular Quay",
                        description: "Start your journey at this iconic harbour hub",
                        latitude: -33.8613,
                        longitude: 151.2109,
                        type: .ferry,
                        estimatedStayDuration: 15,
                        order: 0
                    ),
                    Stop(
                        name: "Manly Wharf",
                        description: "Arrive at beautiful Manly after a scenic 30-min ferry ride",
                        latitude: -33.7969,
                        longitude: 151.2873,
                        type: .ferry,
                        estimatedStayDuration: 30,
                        order: 1
                    ),
                    Stop(
                        name: "Manly Beach",
                        description: "Iconic beach perfect for swimming and surfing",
                        latitude: -33.7985,
                        longitude: 151.2890,
                        type: .walk,
                        estimatedStayDuration: 120,
                        order: 2,
                        notes: "Bring swimmers and sunscreen!"
                    ),
                    Stop(
                        name: "The Corso",
                        description: "Pedestrian mall with shops, cafes, and restaurants",
                        latitude: -33.7978,
                        longitude: 151.2863,
                        type: .walk,
                        estimatedStayDuration: 45,
                        order: 3
                    )
                ],
                estimatedDuration: 210,
                totalDistance: 15.5,
                difficulty: .easy,
                imageName: "journey_manly",
                tags: ["family-friendly", "scenic", "popular", "instagram-worthy"],
                isFeatured: true
            ),
            
            // Journey 2: Blue Mountains Explorer
            Journey(
                name: "Blue Mountains Explorer",
                description: "Full day adventure to the spectacular Blue Mountains. Take the scenic train journey, visit Echo Point for Three Sisters views, and explore charming mountain villages.",
                category: .nature,
                stops: [
                    Stop(
                        name: "Central Station",
                        description: "Board the Blue Mountains Line train",
                        latitude: -33.8832,
                        longitude: 151.2061,
                        type: .train,
                        estimatedStayDuration: 10,
                        order: 0
                    ),
                    Stop(
                        name: "Katoomba Station",
                        description: "Arrive in the heart of the Blue Mountains",
                        latitude: -33.7127,
                        longitude: 150.3117,
                        type: .train,
                        estimatedStayDuration: 20,
                        order: 1
                    ),
                    Stop(
                        name: "Echo Point",
                        description: "Spectacular views of the Three Sisters rock formation",
                        latitude: -33.7326,
                        longitude: 150.3124,
                        type: .bus,
                        estimatedStayDuration: 90,
                        order: 2,
                        notes: "Best photo spot in the morning"
                    ),
                    Stop(
                        name: "Katoomba Street",
                        description: "Charming main street with cafes and galleries",
                        latitude: -33.7143,
                        longitude: 150.3117,
                        type: .walk,
                        estimatedStayDuration: 60,
                        order: 3
                    )
                ],
                estimatedDuration: 480,
                totalDistance: 120.0,
                difficulty: .moderate,
                imageName: "journey_bluemountains",
                tags: ["nature", "hiking", "full-day", "scenic"],
                isFeatured: true
            ),
            
            // Journey 3: Inner West Food Trail
            Journey(
                name: "Inner West Food Trail",
                description: "Discover Sydney's diverse food scene in the trendy Inner West. Visit hip cafes, artisan markets, and multicultural restaurants in Newtown and Marrickville.",
                category: .food,
                stops: [
                    Stop(
                        name: "Newtown Station",
                        description: "Start in Sydney's alternative culture hub",
                        latitude: -33.8978,
                        longitude: 151.1797,
                        type: .train,
                        estimatedStayDuration: 10,
                        order: 0
                    ),
                    Stop(
                        name: "King Street",
                        description: "Vibrant street filled with cafes and vintage shops",
                        latitude: -33.8987,
                        longitude: 151.1809,
                        type: .walk,
                        estimatedStayDuration: 90,
                        order: 1,
                        notes: "Try the famous Thai food!"
                    ),
                    Stop(
                        name: "Marrickville Metro",
                        description: "Diverse shopping center with international cuisines",
                        latitude: -33.9115,
                        longitude: 151.1551,
                        type: .bus,
                        estimatedStayDuration: 60,
                        order: 2
                    ),
                    Stop(
                        name: "Marrickville Organic Markets",
                        description: "Sunday markets with fresh produce and artisan goods",
                        latitude: -33.9103,
                        longitude: 151.1557,
                        type: .walk,
                        estimatedStayDuration: 60,
                        order: 3,
                        notes: "Open Sundays 9am-2pm"
                    )
                ],
                estimatedDuration: 240,
                totalDistance: 8.5,
                difficulty: .easy,
                imageName: "journey_innerwest",
                tags: ["food", "culture", "trendy", "budget-friendly"],
                isFeatured: false
            ),
            
            // Journey 4: Harbour Heritage Discovery
            Journey(
                name: "Harbour Heritage Discovery",
                description: "Step back in time exploring Sydney's colonial history. Visit The Rocks, historic buildings, and museums around the beautiful harbour.",
                category: .historic,
                stops: [
                    Stop(
                        name: "Circular Quay",
                        description: "Historic arrival point for early settlers",
                        latitude: -33.8613,
                        longitude: 151.2109,
                        type: .ferry,
                        estimatedStayDuration: 15,
                        order: 0
                    ),
                    Stop(
                        name: "The Rocks",
                        description: "Sydney's oldest surviving neighbourhood",
                        latitude: -33.8594,
                        longitude: 151.2089,
                        type: .walk,
                        estimatedStayDuration: 90,
                        order: 1,
                        notes: "Weekend markets are fantastic"
                    ),
                    Stop(
                        name: "Museum of Sydney",
                        description: "Learn about Sydney's colonial past",
                        latitude: -33.8641,
                        longitude: 151.2113,
                        type: .walk,
                        estimatedStayDuration: 75,
                        order: 2
                    ),
                    Stop(
                        name: "Hyde Park Barracks",
                        description: "UNESCO World Heritage convict site",
                        latitude: -33.8695,
                        longitude: 151.2131,
                        type: .walk,
                        estimatedStayDuration: 60,
                        order: 3
                    )
                ],
                estimatedDuration: 300,
                totalDistance: 12.0,
                difficulty: .easy,
                imageName: "journey_heritage",
                tags: ["history", "educational", "museums", "family-friendly"],
                isFeatured: false
            ),
            
            // Journey 5: Northern Beaches Coastal Walk
            Journey(
                name: "Northern Beaches Coastal Walk",
                description: "Scenic coastal walk connecting Sydney's stunning northern beaches. Combine bus travel with beautiful beach walks and ocean pools.",
                category: .beach,
                stops: [
                    Stop(
                        name: "Manly Beach",
                        description: "Start at this iconic beach destination",
                        latitude: -33.7985,
                        longitude: 151.2890,
                        type: .ferry,
                        estimatedStayDuration: 45,
                        order: 0
                    ),
                    Stop(
                        name: "Shelly Beach",
                        description: "Protected cove perfect for snorkeling",
                        latitude: -33.7981,
                        longitude: 151.2932,
                        type: .walk,
                        estimatedStayDuration: 60,
                        order: 1,
                        notes: "Bring snorkel gear!"
                    ),
                    Stop(
                        name: "Freshwater Beach",
                        description: "Where surfing was introduced to Australia",
                        latitude: -33.7799,
                        longitude: 151.2883,
                        type: .walk,
                        estimatedStayDuration: 45,
                        order: 2
                    ),
                    Stop(
                        name: "Curl Curl Beach",
                        description: "Popular surf beach with ocean pool",
                        latitude: -33.7694,
                        longitude: 151.2914,
                        type: .bus,
                        estimatedStayDuration: 60,
                        order: 3
                    ),
                    Stop(
                        name: "Dee Why Beach",
                        description: "Large beach with great cafes and ocean pool",
                        latitude: -33.7548,
                        longitude: 151.2990,
                        type: .walk,
                        estimatedStayDuration: 90,
                        order: 4
                    )
                ],
                estimatedDuration: 360,
                totalDistance: 18.0,
                difficulty: .moderate,
                imageName: "journey_northernbeaches",
                tags: ["beach", "hiking", "scenic", "active"],
                isFeatured: false
            ),
            
            // Journey 6: Art & Culture Circuit
            Journey(
                name: "Art & Culture Circuit",
                description: "Immerse yourself in Sydney's vibrant art scene. Visit world-class galleries, street art, and cultural precincts.",
                category: .culture,
                stops: [
                    Stop(
                        name: "Art Gallery of NSW",
                        description: "Major art museum with Australian and international collections",
                        latitude: -33.8688,
                        longitude: 151.2173,
                        type: .train,
                        estimatedStayDuration: 90,
                        order: 0
                    ),
                    Stop(
                        name: "Walsh Bay Arts Precinct",
                        description: "Converted wharves hosting theatres and galleries",
                        latitude: -33.8578,
                        longitude: 151.2047,
                        type: .walk,
                        estimatedStayDuration: 60,
                        order: 1
                    ),
                    Stop(
                        name: "Barangaroo",
                        description: "Modern waterfront with public art installations",
                        latitude: -33.8616,
                        longitude: 151.2013,
                        type: .walk,
                        estimatedStayDuration: 45,
                        order: 2
                    )
                ],
                estimatedDuration: 240,
                totalDistance: 6.5,
                difficulty: .easy,
                imageName: "journey_culture",
                tags: ["art", "culture", "indoor", "educational"],
                isFeatured: false
            ),
            
            // Journey 7: Harbour Islands Adventure
            Journey(
                name: "Harbour Islands Adventure",
                description: "Discover Sydney Harbour's hidden island gems. Visit Fort Denison, Cockatoo Island, and Shark Island by ferry.",
                category: .entertainment,
                stops: [
                    Stop(
                        name: "Circular Quay",
                        description: "Ferry hub for harbour island adventures",
                        latitude: -33.8613,
                        longitude: 151.2109,
                        type: .ferry,
                        estimatedStayDuration: 15,
                        order: 0
                    ),
                    Stop(
                        name: "Cockatoo Island",
                        description: "UNESCO heritage site with convict history",
                        latitude: -33.8476,
                        longitude: 151.1716,
                        type: .ferry,
                        estimatedStayDuration: 120,
                        order: 1,
                        notes: "Bring a picnic!"
                    ),
                    Stop(
                        name: "Fort Denison",
                        description: "Historic fort with harbour views",
                        latitude: -33.8561,
                        longitude: 151.2256,
                        type: .ferry,
                        estimatedStayDuration: 60,
                        order: 2
                    )
                ],
                estimatedDuration: 300,
                totalDistance: 14.0,
                difficulty: .easy,
                imageName: "journey_islands",
                tags: ["ferry", "history", "unique", "family-friendly"],
                isFeatured: true
            ),
            
            // Journey 8: Parramatta River Discovery
            Journey(
                name: "Parramatta River Discovery",
                description: "Journey along the historic Parramatta River, visiting heritage sites and parklands.",
                category: .historic,
                stops: [
                    Stop(
                        name: "Circular Quay",
                        description: "Begin your river journey here",
                        latitude: -33.8613,
                        longitude: 151.2109,
                        type: .ferry,
                        estimatedStayDuration: 10,
                        order: 0
                    ),
                    Stop(
                        name: "Parramatta Wharf",
                        description: "Australia's second oldest settlement",
                        latitude: -33.8124,
                        longitude: 151.0048,
                        type: .ferry,
                        estimatedStayDuration: 90,
                        order: 1
                    ),
                    Stop(
                        name: "Old Government House",
                        description: "Australia's oldest public building",
                        latitude: -33.8149,
                        longitude: 151.0054,
                        type: .walk,
                        estimatedStayDuration: 60,
                        order: 2
                    )
                ],
                estimatedDuration: 270,
                totalDistance: 22.0,
                difficulty: .easy,
                imageName: "journey_parramatta",
                tags: ["history", "ferry", "scenic", "relaxing"],
                isFeatured: false
            )
        ]
    }
    
    // MARK: - CRUD Operations
    
    /// Toggle favorite status for a journey
    /// This will update the database in Section 7
    func toggleFavorite(for journey: Journey) {
        if let index = journeys.firstIndex(where: { $0.id == journey.id }) {
            journeys[index].isFavorited.toggle()
            // In Section 7, this will save to database
        }
    }
    
    /// Get a journey by its ID
    func getJourney(by id: UUID) -> Journey? {
        journeys.first { $0.id == id }
    }
    
    /// Filter journeys by category
    func filterByCategory(_ category: JourneyCategory?) {
        selectedCategory = category
    }
    
    /// Clear all filters
    func clearFilters() {
        selectedCategory = nil
        searchText = ""
    }
    
    /// Get journeys by difficulty level
    func getJourneys(byDifficulty difficulty: Difficulty) -> [Journey] {
        journeys.filter { $0.difficulty == difficulty }
    }
    
    /// Get journeys by tag
    func getJourneys(byTag tag: String) -> [Journey] {
        journeys.filter { $0.tags.contains(tag) }
    }
}
