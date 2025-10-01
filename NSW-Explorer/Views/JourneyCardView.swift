//
//  JourneyCardView.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 1/10/2025.
//
//  Beautiful card component for displaying journey previews
//  Used in lists and grids throughout the app
//

import SwiftUI

// MARK: - Journey Card View
/// Main card component for displaying journey information
/// This is a reusable component that can be used in various contexts
struct JourneyCardView: View {
    // MARK: - Properties
    
    /// The journey to display
    let journey: Journey
    
    /// Optional callback when favorite button is tapped
    var onFavorite: (() -> Void)?
    
    /// Card style variant (compact or full)
    var style: CardStyle = .full
    
    // MARK: - Card Style Enum
    /// Defines different card presentation styles
    enum CardStyle {
        case full      // Full-height card with all details
        case compact   // Smaller card for grids
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // MARK: - Image Section
            imageSection
            
            // MARK: - Content Section
            contentSection
        }
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Image Section
    /// Top image area with category badge and favorite button
    private var imageSection: some View {
        ZStack(alignment: .topTrailing) {
            // Image placeholder with gradient overlay
            // In a real app, this would load the actual image
            ZStack(alignment: .bottomLeading) {
                // Placeholder colored rectangle
                // Uses category color for variety
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(journey.category.colorName),
                                Color(journey.category.colorName).opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: style == .full ? 200 : 160)
                
                // Gradient overlay for better text readability
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.black.opacity(0.5)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: style == .full ? 200 : 160)
                
                // Category badge at bottom left
                HStack(spacing: 6) {
                    Image(systemName: journey.category.icon)
                        .font(.caption)
                    Text(journey.category.rawValue)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)
                .padding(12)
            }
            
            // Favorite button at top right
            if let onFavorite = onFavorite {
                Button(action: onFavorite) {
                    Image(systemName: journey.isFavorited ? "heart.fill" : "heart")
                        .font(.title3)
                        .foregroundColor(journey.isFavorited ? .foodRed : .white)
                        .padding(8)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
                .padding(12)
            }
            
            // Featured badge if applicable
            if journey.isFeatured {
                VStack {
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.caption2)
                            Text("Featured")
                                .font(.caption2)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.sunsetOrange)
                        .cornerRadius(12)
                        .padding(.leading, 12)
                        .padding(.top, 12)
                        
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Content Section
    /// Bottom content area with journey details
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: style == .full ? 12 : 8) {
            // Title
            Text(journey.name)
                .font(style == .full ? .headingMedium : .headingSmall)
                .foregroundColor(.textPrimary)
                .lineLimit(2)
            
            // Description (only in full style)
            if style == .full {
                Text(journey.description)
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)
            }
            
            // Metadata row
            HStack(spacing: style == .full ? 16 : 12) {
                // Duration
                Label(journey.durationString, systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                
                // Distance
                Label(journey.distanceString, systemImage: "location")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                
                Spacer()
                
                // Difficulty badge
                DifficultyBadge(difficulty: journey.difficulty, compact: style == .compact)
            }
            
            // Tags row (only in full style)
            if style == .full && !journey.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(journey.tags.prefix(3), id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.caption)
                                .foregroundColor(.primaryTeal)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.primaryTeal.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .padding(style == .full ? 16 : 12)
    }
}

// MARK: - Difficulty Badge Component
/// Small badge showing difficulty level with icon
struct DifficultyBadge: View {
    let difficulty: Difficulty
    var compact: Bool = false
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: difficulty.icon)
                .font(compact ? .caption2 : .caption)
            
            if !compact {
                Text(difficulty.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
        }
        .foregroundColor(Color(difficulty.colorName))
        .padding(.horizontal, compact ? 6 : 8)
        .padding(.vertical, compact ? 3 : 4)
        .background(Color(difficulty.colorName).opacity(0.15))
        .cornerRadius(8)
    }
}

// MARK: - Preview Provider
struct JourneyCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Full style card
            JourneyCardView(
                journey: Journey.sample,
                onFavorite: {
                    print("Favorite tapped")
                },
                style: .full
            )
            
            // Compact style card
            JourneyCardView(
                journey: Journey.samples[1],
                onFavorite: {
                    print("Favorite tapped")
                },
                style: .compact
            )
        }
        .padding()
        .background(Color.backgroundGray)
        .previewLayout(.sizeThatFits)
    }
}
