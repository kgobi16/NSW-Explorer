//
//  JourneyDetailView.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 1/10/2025.
//
//  Detailed view of a journey showing all stops and information
//  This is where users decide whether to start a journey
//

import SwiftUI
import MapKit

struct JourneyDetailView: View {
    // MARK: - Properties
    
    /// The journey to display
    let journey: Journey
    
    /// ViewModel for managing favorites
    @StateObject private var viewModel = JourneyViewModel()
    
    /// Environment dismiss action for closing the view
    @Environment(\.dismiss) var dismiss
    
    /// Track selected stop for detail expansion
    @State private var selectedStop: Stop?
    
    /// Show map view
    @State private var showMap: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MARK: - Hero Image
                heroImage
                
                // MARK: - Content
                VStack(spacing: 24) {
                    // Header info
                    headerSection
                    
                    Divider()
                    
                    // Quick stats
                    statsSection
                    
                    Divider()
                    
                    // Description
                    descriptionSection
                    
                    Divider()
                    
                    // Stops list
                    stopsSection
                    
                    // Action buttons
                    actionButtons
                }
                .padding()
            }
        }
        .background(Color.backgroundGray)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // MARK: - Toolbar Items
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 12) {
                    // Share button
                    Button(action: {
                        print("Share journey")
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.primaryTeal)
                    }
                    
                    // Favorite button
                    Button(action: {
                        viewModel.toggleFavorite(for: journey)
                    }) {
                        Image(systemName: journey.isFavorited ? "heart.fill" : "heart")
                            .foregroundColor(journey.isFavorited ? .foodRed : .primaryTeal)
                    }
                }
            }
        }
        .sheet(isPresented: $showMap) {
            JourneyMapView(journey: journey)
        }
    }
    
    // MARK: - Hero Image
    /// Large hero image at the top
    private var heroImage: some View {
        ZStack(alignment: .bottomLeading) {
            // Placeholder image with gradient
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
                .frame(height: 300)
            
            // Dark gradient overlay for text readability
            LinearGradient(
                colors: [Color.clear, Color.black.opacity(0.7)],
                startPoint: .center,
                endPoint: .bottom
            )
            .frame(height: 300)
            
            // Category badge
            HStack(spacing: 8) {
                Image(systemName: journey.category.icon)
                Text(journey.category.rawValue)
            }
            .font(.bodyMedium)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.4))
            .cornerRadius(20)
            .padding(16)
        }
    }
    
    // MARK: - Header Section
    /// Title and quick info
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title
            Text(journey.name)
                .font(.displaymedium)
                .foregroundColor(.textPrimary)
            
            // Tags
            if !journey.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(journey.tags, id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.caption)
                                .foregroundColor(.primaryTeal)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.primaryTeal.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Stats Section
    /// Quick statistics in a grid
    private var statsSection: some View {
        HStack(spacing: 0) {
            // Duration stat
            StatColumn(
                icon: "clock.fill",
                value: journey.durationString,
                label: "Duration",
                color: .primaryTeal
            )
            
            Divider()
                .frame(height: 60)
            
            // Distance stat
            StatColumn(
                icon: "location.fill",
                value: journey.distanceString,
                label: "Distance",
                color: .sunsetOrange
            )
            
            Divider()
                .frame(height: 60)
            
            // Stops stat
            StatColumn(
                icon: "mappin.circle.fill",
                value: "\(journey.stopCount)",
                label: "Stops",
                color: .deepPurple
            )
            
            Divider()
                .frame(height: 60)
            
            // Difficulty stat
            VStack(spacing: 8) {
                Image(systemName: journey.difficulty.icon)
                    .font(.title2)
                    .foregroundColor(Color(journey.difficulty.colorName))
                
                Text(journey.difficulty.rawValue)
                    .font(.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                
                Text("Difficulty")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Description Section
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About This Journey")
                .font(.headingMedium)
                .foregroundColor(.textPrimary)
            
            Text(journey.description)
                .font(.bodyLarge)
                .foregroundColor(.textSecondary)
                .lineSpacing(6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Stops Section
    /// List of all stops in this journey
    private var stopsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            HStack {
                Text("Journey Stops")
                    .font(.headingMedium)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button(action: {
                    showMap = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "map")
                        Text("View Map")
                    }
                    .font(.bodyMedium)
                    .foregroundColor(.primaryTeal)
                }
            }
            
            // Stops list
            VStack(spacing: 12) {
                ForEach(Array(journey.stops.enumerated()), id: \.element.id) { index, stop in
                    StopRow(
                        stop: stop,
                        isLast: index == journey.stops.count - 1
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        VStack(spacing: 12) {
            PrimaryButton("Start Journey", icon: "location.fill") {
                print("Start journey tapped")
                // Will navigate to active journey view in Section 5
            }
            
            SecondaryButton("Save for Later", icon: "bookmark") {
                viewModel.toggleFavorite(for: journey)
            }
        }
        .padding(.top, 8)
    }
}

// MARK: - Stat Column Component
/// Reusable stat display column
struct StatColumn: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.bodyMedium)
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Stop Row Component
/// Individual stop in the journey list
struct StopRow: View {
    let stop: Stop
    var isLast: Bool = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Timeline indicator
            VStack(spacing: 0) {
                // Stop number circle
                ZStack {
                    Circle()
                        .fill(Color(stop.type.colorName))
                        .frame(width: 32, height: 32)
                    
                    Text("\(stop.order + 1)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                // Connecting line (if not last stop)
                if !isLast {
                    Rectangle()
                        .fill(Color(stop.type.colorName).opacity(0.3))
                        .frame(width: 2)
                        .frame(minHeight: 40)
                }
            }
            
            // Stop content
            VStack(alignment: .leading, spacing: 8) {
                // Stop name and type
                HStack {
                    Text(stop.name)
                        .font(.headingSmall)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    // Transport type badge
                    HStack(spacing: 4) {
                        Image(systemName: stop.type.icon)
                            .font(.caption)
                        Text(stop.type.rawValue)
                            .font(.caption)
                    }
                    .foregroundColor(Color(stop.type.colorName))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(stop.type.colorName).opacity(0.1))
                    .cornerRadius(8)
                }
                
                // Description
                Text(stop.description)
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)
                
                // Duration
                Label(stop.durationString, systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                
                // Notes if available
                if let notes = stop.notes {
                    HStack(alignment: .top, spacing: 6) {
                        Image(systemName: "lightbulb.fill")
                            .font(.caption)
                            .foregroundColor(.sunsetOrange)
                        
                        Text(notes)
                            .font(.caption)
                            .foregroundColor(.sunsetOrange)
                    }
                    .padding(8)
                    .background(Color.sunsetOrange.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding(.bottom, isLast ? 0 : 8)
        }
    }
}

// MARK: - Journey Map View (Placeholder)
/// Map view showing journey route
/// Will be enhanced in Section 8 with full MapKit implementation
struct JourneyMapView: View {
    let journey: Journey
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundGray.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Image(systemName: "map")
                        .font(.system(size: 80))
                        .foregroundColor(.primaryTeal.opacity(0.5))
                    
                    Text("Map View")
                        .font(.headingLarge)
                        .foregroundColor(.textPrimary)
                    
                    Text("Full MapKit implementation\ncoming in Section 8")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .navigationTitle("Journey Map")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview Provider
struct JourneyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            JourneyDetailView(journey: Journey.sample)
        }
    }
}
