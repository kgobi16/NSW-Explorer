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
                GeneratedTripResultsView(selectedInterests: Array(selectedInterests))
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isGenerating = false
            showResults = true
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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    successHeader
                    interestsSection
                    placeholderJourneys
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
            
            Text("Trip Generated!")
                .font(.displaymedium)
                .foregroundColor(.textPrimary)
            
            Text("Based on your interests:")
                .font(.bodyLarge)
                .foregroundColor(.textSecondary)
        }
    }
    
    private var interestsSection: some View {
        FlowLayout(spacing: 8) {
            ForEach(selectedInterests, id: \.self) { interest in
                InterestChip(text: interest)
            }
        }
        .padding(.horizontal)
    }
    
    private var placeholderJourneys: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Generated Journey")
                .font(.headingLarge)
                .foregroundColor(.textPrimary)
                .padding(.horizontal)
            
            // Placeholder - will show actual journey in next iteration
            VStack(alignment: .leading, spacing: 12) {
                Text("Your Personalized Adventure")
                    .font(.headingMedium)
                    .foregroundColor(.textPrimary)
                
                Text("A custom journey matching your interests will be generated using real NSW transport data and curated stops.")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .lineSpacing(4)
                
                HStack {
                    Label("3-4 hours", systemImage: "clock")
                    Label("5 stops", systemImage: "mappin.circle")
                    Label("12 km", systemImage: "location")
                }
                .font(.caption)
                .foregroundColor(.textSecondary)
            }
            .padding()
            .background(Color.SurfaceWhite)
            .cornerRadius(16)
            .padding(.horizontal)
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
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
