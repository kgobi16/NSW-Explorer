//
//  ColorTheme.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 1/10/2025.
//

import SwiftUI

/// ColorTheme provides a centralized way to access all brand colors

extension Color{
    
    // MARK: - Primary Brand Colors
    // These are the main colors that define our app's personality
    // Each color references a Color Set in Assets
    
    static let PrimaryTeal = Color("PrimaryTeal")
    static let SunsetOrange = Color("SunsetOrange")
    static let DeepPurple = Color("DeepPurple")
    static let FreshGreen = Color("FreshGreen")
    
    // MARK: - Neutral Colors
    // These provide structure and hierarchy to our interface
    
    static let BackgroundGray = Color("BackgroundGray")
    static let SurfaceWhite = Color.white
    static let TextPrimary = Color("TextPrimary")
    static let TextSecondary = Color("TextSecondary")
    
    // MARK: - Category Colors
    // Specific colors for different journey categories
    // These help users quickly identify journey types
    
    static let BeachBlue = Color("BeachBlue")
    static let MeseumPurple = Color("MeseumPurple")
    static let FoodRed = Color("FoodRed")
    static let NatureGreen = Color("NatureGreen")
    static let HistoryBrown = Color("HistoryBrown")
    static let EntertainmentPink = Color("EntertainmentPink")
    
    // MARK: - Gradient Sets
    // Pre-defined gradients for visual interest
    
    /// Hero gradient for splash screens and featured content
    static let heroGradient = LinearGradient(
        colors: [primaryTeal, deepPurple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    /// Sunset gradient for adventure-themed content
    static let adventureGradient = LinearGradient(
        colors: [sunsetOrange, Color("FF8F00")],
        startPoint: .leading,
        endPoint: .trailing
    )
    
}

// MARK: - Preview Provider
// This allows us to see all our colors in Xcode's preview pane
struct ColorTheme_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Display each color with its name
                ColorSwatch(color: .PrimaryTeal, name: "Primary Teal")
                ColorSwatch(color: .SunsetOrange, name: "Sunset Orange")
                ColorSwatch(color: .DeepPurple, name: "Deep Purple")
                ColorSwatch(color: .FreshGreen, name: "Fresh Green")
                ColorSwatch(color: .BeachBlue, name: "Beach Blue")
                ColorSwatch(color: .MeseumPurple, name: "Museum Purple")
                ColorSwatch(color: .FoodRed, name: "Food Red")
                ColorSwatch(color: .NatureGreen, name: "Nature Green")
                
                // Show gradient examples
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.heroGradient)
                    .frame(height: 100)
                    .overlay(
                        Text("Hero Gradient")
                            .font(.headline)
                            .foregroundColor(.white)
                    )
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.adventureGradient)
                    .frame(height: 100)
                    .overlay(
                        Text("Adventure Gradient")
                            .font(.headline)
                            .foregroundColor(.white)
                    )
            }
            .padding()
        }
        .background(Color.backgroundGray)
    }
}

/// Helper view to display a color swatch with its name
/// This is only used in previews to visualize our color system
struct ColorSwatch: View {
    let color: Color
    let name: String
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 60, height: 60)
            
            Text(name)
                .font(.headline)
                .foregroundColor(.TextPrimary)
            
            Spacer()
        }
        .padding()
        .background(Color.SurfaceWhite)
        .cornerRadius(12)
    }
}
