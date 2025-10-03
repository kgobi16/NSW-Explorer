//
//  GeneratorView.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 1/10/2025.
//
//
//  GeneratorView.swift
//  NSW-Explorer
//
//  MAIN PAGE - Trip generator where users select interests and get personalized journeys
//

import SwiftUI

struct GeneratorView: View {
    // MARK: - State Properties
    
    /// Tracks which interests the user has selected
    @State private var selectedInterests: Set<String> = []
    
    /// Controls loading animation
    @State private var isGenerating: Bool = false
    
    /// Controls results display
    @State private var showResults: Bool = false
    
    /// Generated journey from API
    @State private var generatedJourney: GeneratedJourney?
    
    /// Error message if generation fails
    @State private var errorMessage: String?
    
    /// Show error alert
    @State private var showError: Bool = false
    
    /// Available interest categories
    private let interests: [(String, String, Color)] = [
        ("Beaches", "beach.umbrella", .beachBlue),
        ("Museums", "building.columns", .meseumPurple),
        ("Food & Cafes", "fork.knife", .foodRed),
        ("Hiking", "figure.hiking", .natureGreen),
        ("Historic Sites", "building.2", .historyBrown),
        ("Entertainment", "theatermasks", .entertainmentPink),
        ("Shopping", "bag", .sunsetOrange),
        ("Parks", "leaf", .freshGreen)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    
                    // MARK: - Hero Section
                    heroSection
                    
                    // MARK: - Interest Selection
                    interestSelectionSection
                    
                    // MARK: - Generate Button
                    generateButtonSection
                    
                    // MARK: - How It Works
                    howItWorksSection
                }
                .padding()
            }
            .background(Color.backgroundGray)
            .navigationTitle("NSW Explorer")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showResults) {
                if let journey = generatedJourney {
                    GeneratedTripResultsView(
                        selectedInterests: Array(selectedInterests),
                        generatedJourney: journey
                    )
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "Failed to generate trip. Please try again.")
            }
        }
    }
    
    // MARK: - Hero Section
    /// Eye-catching welcome with app branding
    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // App icon/logo area
            HStack {
                Image(systemName: "map.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("NSW Explorer")
                        .font(.displaymedium)
                        .foregroundColor(.white)
                    
                    Text("AI-Powered Trip Planning")
                        .font(.bodyMedium)
                        .foregroundColor(.white.opacity(0.9))
                }
            }
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            // Value proposition
            VStack(alignment: .leading, spacing: 8) {
                FeatureBullet(
                    icon: "sparkles",
                    text: "Generate personalized journeys"
                )
                FeatureBullet(
                    icon: "bus.fill",
                    text: "Real NSW transport schedules"
                )
                FeatureBullet(
                    icon: "map.fill",
                    text: "Curated stops & attractions"
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.heroGradient)
        )
    }
    
    // MARK: - Interest Selection Section
    private var interestSelectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("What interests you?")
                        .font(.headingLarge)
                        .foregroundColor(.textPrimary)
                    
                    Text("Select 2-4 categories for best results")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                if !selectedInterests.isEmpty {
                    Text("\(selectedInterests.count)")
                        .font(.headingMedium)
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(Color.primaryTeal)
                        .clipShape(Circle())
                }
            }
            
            // Grid of interest cards
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(interests, id: \.0) { interest in
                    InterestCard(
                        name: interest.0,
                        icon: interest.1,
                        color: interest.2,
                        isSelected: selectedInterests.contains(interest.0)
                    ) {
                        toggleInterest(interest.0)
                    }
                }
            }
        }
    }
    
    // MARK: - Generate Button Section
    private var generateButtonSection: some View {
        VStack(spacing: 16) {
            if !selectedInterests.isEmpty {
                PrimaryButton(
                    isGenerating ? "Generating..." : "Generate My Trip",
                    icon: "sparkles"
                ) {
                    generateTrip()
                }
                .disabled(isGenerating)
                .opacity(isGenerating ? 0.6 : 1.0)
                
                SecondaryButton("Clear Selection") {
                    selectedInterests.removeAll()
                }
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "hand.tap")
                        .font(.largeTitle)
                        .foregroundColor(.primaryTeal.opacity(0.5))
                    
                    Text("Select at least one interest to begin")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
                .background(Color.SurfaceWhite)
                .cornerRadius(16)
            }
        }
    }
    
    // MARK: - How It Works Section
    private var howItWorksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("How it works")
                .font(.headingMedium)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 16) {
                StepCard(
                    number: 1,
                    title: "Choose Your Interests",
                    description: "Select the types of experiences you enjoy",
                    icon: "hand.tap.fill",
                    color: .primaryTeal
                )
                
                StepCard(
                    number: 2,
                    title: "AI Generates Your Trip",
                    description: "Our algorithm creates a personalized journey using real transport data",
                    icon: "sparkles",
                    color: .sunsetOrange
                )
                
                StepCard(
                    number: 3,
                    title: "Start Exploring",
                    description: "Follow your journey, check in at stops, and create memories",
                    icon: "location.fill",
                    color: .freshGreen
                )
            }
        }
        .padding()
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
    
    // MARK: - Helper Methods
    
    private func toggleInterest(_ interest: String) {
        if selectedInterests.contains(interest) {
            selectedInterests.remove(interest)
        } else {
            selectedInterests.insert(interest)
        }
    }
    
    private func generateTrip() {
        isGenerating = true
        errorMessage = nil
        
        Task {
            do {
                let journey = try await JourneyGeneratorService.shared.generateJourney(
                    for: Array(selectedInterests),
                    duration: 1
                )
                
                await MainActor.run {
                    generatedJourney = journey
                    isGenerating = false
                    showResults = true
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isGenerating = false
                    showError = true
                }
            }
        }
    }
}

// MARK: - Feature Bullet Component
struct FeatureBullet: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.bodyMedium)
                .foregroundColor(.white)
            
            Text(text)
                .font(.bodyMedium)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Step Card Component
struct StepCard: View {
    let number: Int
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Step number
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headingSmall)
                    .foregroundColor(.textPrimary)
                
                Text(description)
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .lineSpacing(4)
            }
        }
        .padding()
        .background(Color.backgroundGray)
        .cornerRadius(12)
    }
}

// MARK: - Interest Card Component
struct InterestCard: View {
    let name: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(isSelected ? 0.2 : 0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 28))
                        .foregroundColor(color)
                }
                
                Text(name)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.SurfaceWhite)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? color : Color.clear,
                        lineWidth: 3
                    )
            )
            .shadow(
                color: isSelected ? color.opacity(0.3) : Color.black.opacity(0.05),
                radius: isSelected ? 8 : 4,
                x: 0,
                y: isSelected ? 4 : 2
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Generated Results View
struct GeneratedTripResultsView: View {
    @Environment(\.dismiss) var dismiss
    let selectedInterests: [String]
    let generatedJourney: GeneratedJourney
    @State private var showFullJourney = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    successHeader
                    interestsSection
                    journeyDetailsSection
                    stopsPreviewSection
                    actionButtons
                }
                .padding(.vertical)
            }
            .background(Color.backgroundGray)
            .navigationTitle("Your Trip")
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
    
    private var successHeader: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.freshGreen)
            
            Text(generatedJourney.title)
                .font(.displaymedium)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(generatedJourney.description)
                .font(.bodyLarge)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
    
    private var interestsSection: some View {
        HStack {
            ForEach(selectedInterests.sorted(), id: \.self) { interest in
                InterestChip(text: interest)
            }
        }
        .padding(.horizontal)
    }
    
    private var journeyDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Journey Details")
                .font(.headingLarge)
                .foregroundColor(.textPrimary)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Label("\(generatedJourney.stops.count) stops", systemImage: "mappin.circle.fill")
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                    Spacer()
                }
                
                HStack {
                    Label(String(format: "%.1f km total", generatedJourney.estimatedDistance), systemImage: "location.fill")
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                    Spacer()
                }
                
                HStack {
                    Label("\(generatedJourney.estimatedTotalTime / 60) hours", systemImage: "clock.fill")
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                    Spacer()
                }
            }
            .padding()
            .background(Color.SurfaceWhite)
            .cornerRadius(16)
            .padding(.horizontal)
        }
    }
    
    private var stopsPreviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Stops")
                .font(.headingLarge)
                .foregroundColor(.textPrimary)
                .padding(.horizontal)
            
            ForEach(Array(generatedJourney.stops.prefix(5)), id: \.id) { stop in
                StopPreviewCard(stop: stop)
                    .padding(.horizontal)
            }
            
            if generatedJourney.stops.count > 5 {
                Text("+ \(generatedJourney.stops.count - 5) more stops")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .padding(.horizontal)
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            NavigationLink(destination: TripMapView(journey: generatedJourney)) {
                HStack {
                    Image(systemName: "map.fill")
                    Text("View on Map")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primaryTeal)
                .foregroundColor(.white)
                .cornerRadius(12)
                .font(.headingSmall)
            }
            
            PrimaryButton("Start Journey") {
                // Will connect to actual journey start
                dismiss()
            }
            
            SecondaryButton("Generate Different Trip") {
                dismiss()
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Stop Preview Card
struct StopPreviewCard: View {
    let stop: Stop
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color(stop.type.colorName).opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: stop.type.icon)
                    .foregroundColor(Color(stop.type.colorName))
            }
            
            // Details
            VStack(alignment: .leading, spacing: 4) {
                Text(stop.name)
                    .font(.headingSmall)
                    .foregroundColor(.textPrimary)
                
                Text(stop.description)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)
                
                if let rating = stop.rating {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.sunsetOrange)
                        Text(String(format: "%.1f", rating))
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            
            Spacer()
            
            // Duration
            Text(stop.durationString)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .padding()
        .background(Color.SurfaceWhite)
        .cornerRadius(12)
    }
}

// MARK: - Interest Chip Component
struct InterestChip: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.bodyMedium)
            .foregroundColor(.primaryTeal)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.primaryTeal.opacity(0.1))
            .cornerRadius(16)
    }
}

// MARK: - Tip Row Component (for backwards compatibility)
struct TipRow: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.bodyMedium)
                .foregroundColor(.freshGreen)
            
            Text(text)
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
        }
    }
}

// MARK: - Preview Provider
struct GeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        GeneratorView()
    }
}
