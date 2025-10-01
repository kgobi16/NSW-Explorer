//
//  GeneratorView.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 1/10/2025.
//

import SwiftUI

struct GeneratorView: View {
    
    // Tracks which interests the user has selected
    @State private var selectedInterests: Set<String> = []
    // Controls whether we're showing the loading animation
    @State private var isGenerating: Bool = false
    // Controls whether to show the generated trip results
    @State private var showResults: Bool = false
    
    // Available interest categories
    private let interests: [(String, String, Color)] = [
        ("Beaches", "beach.umbrella", .BeachBlue),
        ("Museums", "building.columns", .MeseumPurple),
        ("Food & Cafes", "fork.knife", .FoodRed),
        ("Hiking", "figure.hiking", .NatureGreen),
        ("Historic Sites", "building.2", .HistoryBrown),
        ("Entertainment", "theatermasks", .EntertainmentPink),
        ("Shopping", "bag", .SunsetOrange),
        ("Parks", "leaf", .FreshGreen)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    
                    // MARK: - All the seperated sections
                    headerSection
                    
                    interestSelectionSection
                    
                    generateButtonSection
                    
                    tipsSection
                }
                .padding()
            }
            .background(Color.backgroundGray)
            .navigationTitle("Generate Trip")
            .navigationBarTitleDisplayMode(.large)
            
            //Results Sheet - Present generated results as a modal sheet
            .sheet(isPresented: $showResults) {
                GeneratedTripResultsView(selectedInterests: Array(selectedInterests))
            }
        }
    }
    
    // MARK: - Header Section
    /// Explains what this feature does
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Icon
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundColor(.primaryTeal)
            
            // Title
            Text("Create Your Perfect Journey")
                .font(.displaymedium)
                .foregroundColor(.textPrimary)
            
            // Description
            Text("Select your interests and we'll generate a personalized day trip using NSW's public transport network.")
                .font(.bodyLarge)
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Interest Selection Section
    /// Grid of interest cards that users can tap to select
    private var interestSelectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header with count
            HStack {
                Text("Select Your Interests")
                    .font(.headingLarge)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                // Show count of selected interests
                if !selectedInterests.isEmpty {
                    Text("\(selectedInterests.count) selected")
                        .font(.bodyMedium)
                        .foregroundColor(.primaryTeal)
                }
            }
            
            // Grid of interest cards
            // LazyVGrid creates a responsive grid layout
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
                        // Toggle selection when tapped
                        toggleInterest(interest.0)
                    }
                }
            }
        }
    }
    
    // MARK: - Generate Button Section
    private var generateButtonSection: some View {
        VStack(spacing: 16) {
            // Show the button only if at least one interest is selected
            if !selectedInterests.isEmpty {
                // Main generate button
                PrimaryButton(
                    isGenerating ? "Generating..." : "Generate My Trip",
                    icon: "sparkles"
                ) {
                    generateTrip()
                }
                .disabled(isGenerating) // Disable while loading
                .opacity(isGenerating ? 0.6 : 1.0) // Visual feedback
                
                // Clear selection button
                SecondaryButton("Clear Selection") {
                    selectedInterests.removeAll()
                }
            } else {
                // Placeholder when no interests selected
                Text("Select at least one interest to continue")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.SurfaceWhite)
                    .cornerRadius(12)
            }
        }
    }
    
    // MARK: - Tips Section
    /// Helpful tips for getting the best results
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Pro Tips", systemImage: "lightbulb.fill")
                .font(.headingMedium)
                .foregroundColor(.sunsetOrange)
            
            VStack(alignment: .leading, spacing: 8) {
                TipRow(text: "Select 2-4 interests for the best results")
                TipRow(text: "Mix different categories for variety")
                TipRow(text: "Generated trips work with real transport schedules")
            }
        }
        .padding()
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
    
    // MARK: - Helper Methods
    
    /// Toggle an interest's selection state
    /// Uses Set for efficient add/remove operations
    private func toggleInterest(_ interest: String) {
        if selectedInterests.contains(interest) {
            selectedInterests.remove(interest)
        } else {
            selectedInterests.insert(interest)
        }
    }
    
    /// Simulate trip generation (will be replaced with API Call)
    private func generateTrip() {
        // Show loading state
        isGenerating = true
        
        // Simulate network delay (2 seconds)
        // In Section 10, this will be replaced with actual API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isGenerating = false
            showResults = true
        }
    }
}

// MARK: - Interest Card Component
/// Interactive card for selecting an interest category
struct InterestCard: View {
    let name: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Icon with colored background
                ZStack {
                    Circle()
                        .fill(color.opacity(isSelected ? 0.2 : 0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 28))
                        .foregroundColor(color)
                }
                
                // Name
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

// MARK: - Tip Row Component
/// Single tip row with bullet point
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

// MARK: - Generated Results View
/// Modal sheet showing the generated trip results
struct GeneratedTripResultsView: View {
    @Environment(\.dismiss) var dismiss
    let selectedInterests: [String]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    successHeader
                    interestsSection
                    tripDetailsPlaceholder
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
    
    // MARK: - Success Header
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
    
    // MARK: - Interests Section
    private var interestsSection: some View {
        FlowLayout(spacing: 8) {
            ForEach(selectedInterests, id: \.self) { interest in
                InterestChip(text: interest)
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Trip Details Placeholder
    private var tripDetailsPlaceholder: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Journey")
                .font(.headingLarge)
                .foregroundColor(.textPrimary)
            
            Text("Detailed trip itinerary will appear here with stops, transport options, and estimated times.")
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
        .padding(.horizontal)
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        VStack(spacing: 12) {
            PrimaryButton("Save Trip") {
                dismiss()
            }
            
            SecondaryButton("Generate Again") {
                dismiss()
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Interest Chip Component
/// Small chip displaying an interest
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

// MARK: - Preview Provider
struct GeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        GeneratorView()
    }
}
