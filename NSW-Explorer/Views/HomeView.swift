//
//  HomeView.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 1/10/2025.
//

import SwiftUI

struct HomeView: View {
    
    // Currently selected category filter
    @State private var selectedCategory: String? = nil
    
    // Array of available category filters
    private let categories = ["All", "Beach", "Cultural", "Food", "Nature", "Historic"]
    
    var body: some View {
       
        NavigationStack {
            ScrollView {
                VStack(spacing: 24){
                    
                    heroSection
                    
                    categoryFilterSection
                    
                    featuredJourneysSection
                    
                    popularDestinationsSection
                }
                
                .padding()
            }
            
            .background(Color.BackgroundGray)
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.large)
            .toolbar{
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    IconButton(icon: "bell"){
                        print("Notifications tapped")
                    }
                }
            }
                             
        }
    }
    
    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 16) {
        
            Text("Explore NSW")
                .font(.displaylarge)
                .foregroundColor(.white)
            
            Text("Discover curated adventures across\nNew South Wales")
                .font(.bodyLarge)
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(2)
            
            HStack {
                            Spacer()
                            
                            Button(action: {
                                print("Start exploring tapped")
                            }) {
                                HStack {
                                    Text("Start Exploring")
                                        .font(.buttonMedium)
                                    Image(systemName: "arrow.right")
                                }
                                .foregroundColor(.primaryTeal)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.white)
                                .cornerRadius(20)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(24)
                    .background(
                        // Use our hero gradient for visual interest
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.heroGradient)
                    )
                    .padding(.horizontal)
                }
                
                // MARK: - Category Filter Section
                // Horizontal scrolling chips for category selection
                // This allows users to filter journeys by type
                private var categoryFilterSection: some View {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            // Create a chip button for each category
                            ForEach(categories, id: \.self) { category in
                                ChipButton(
                                    category,
                                    isSelected: selectedCategory == category || (category == "All" && selectedCategory == nil)
                                ) {
                                    // Handle category selection
                                    if category == "All" {
                                        selectedCategory = nil
                                    } else {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // MARK: - Featured Journeys Section
                // Main section showing curated journey cards
                // For now, we show placeholder cards until we build the data layer
                private var featuredJourneysSection: some View {
                    VStack(alignment: .leading, spacing: 16) {
                        // Section header
                        HStack {
                            Text("Featured Journeys")
                                .font(.headingLarge)
                                .foregroundColor(.textPrimary)
                            
                            Spacer()
                            
                            // "See All" button
                            Button(action: {
                                print("See all journeys tapped")
                            }) {
                                Text("See All")
                                    .font(.bodyMedium)
                                    .foregroundColor(.primaryTeal)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Placeholder journey cards
                        // These will be replaced with real data in Section 3
                        VStack(spacing: 16) {
                            JourneyCardPlaceholder(
                                title: "Manly Ferry Adventure",
                                category: "Beach",
                                duration: "3 hours",
                                difficulty: "Easy"
                            )
                            
                            JourneyCardPlaceholder(
                                title: "Blue Mountains Explorer",
                                category: "Nature",
                                duration: "Full day",
                                difficulty: "Moderate"
                            )
                            
                            JourneyCardPlaceholder(
                                title: "Inner West Food Trail",
                                category: "Food",
                                duration: "4 hours",
                                difficulty: "Easy"
                            )
                        }
                        .padding(.horizontal)
                    }
                }
                
                // MARK: - Popular Destinations Section
                // Horizontal scrolling cards showing trending locations
                // This provides additional discovery options
                private var popularDestinationsSection: some View {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Popular Destinations")
                            .font(.headingLarge)
                            .foregroundColor(.textPrimary)
                            .padding(.horizontal)
                        
                        // Horizontal scrolling cards
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(0..<5) { index in
                                    DestinationCardPlaceholder(
                                        name: "Destination \(index + 1)"
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }

            // MARK: - Placeholder Components
            // These are temporary components that will be replaced on  later stage

            // Temporary placeholder for journey cards
            struct JourneyCardPlaceholder: View {
                let title: String
                let category: String
                let duration: String
                let difficulty: String
                
                var body: some View {
                    VStack(alignment: .leading, spacing: 12) {
                        // Image placeholder
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.primaryTeal.opacity(0.3))
                            .frame(height: 180)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundColor(.primaryTeal.opacity(0.5))
                            )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            // Title
                            Text(title)
                                .font(.headingMedium)
                                .foregroundColor(.textPrimary)
                            
                            // Metadata
                            HStack {
                                Label(category, systemImage: "tag")
                                Spacer()
                                Label(duration, systemImage: "clock")
                                Spacer()
                                Label(difficulty, systemImage: "figure.hiking")
                            }
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.bottom, 12)
                    }
                    .background(Color.SurfaceWhite)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
            }

            // Temporary placeholder for destination cards
            struct DestinationCardPlaceholder: View {
                let name: String
                
                var body: some View {
                    VStack(spacing: 0) {
                        // Image placeholder
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.deepPurple.opacity(0.3))
                            .frame(width: 160, height: 120)
                            .overlay(
                                Image(systemName: "map")
                                    .font(.title)
                                    .foregroundColor(.deepPurple.opacity(0.5))
                            )
                        
                        Text(name)
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                            .padding(8)
                    }
                    .background(Color.SurfaceWhite)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                }
            }

            // MARK: - Preview Provider
            struct HomeView_Previews: PreviewProvider {
                static var previews: some View {
                    HomeView()
                }
            }
