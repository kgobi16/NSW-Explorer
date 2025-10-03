//
//  ButtonComponents.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 1/10/2025.
//

import SwiftUI

// MARK: - Primary Button
/// Primary action button with bold styling
/// Use this for the main CTA (Call-to-Action) on each screen
/// Example: "Start Journey", "Generate Trip", "Save"
struct PrimaryButton: View {
    // The text displayed on the button
    let title: String
    // Optional icon to display before text
    let icon: String?
    // Action to perform when tapped
    let action: () -> Void
    
    /// Initialize with title and action, no icon
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.icon = nil
        self.action = action
    }
    
    /// Initialize with title, icon, and action
    init(_ title: String, icon: String, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                // Display icon if provided
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.buttonLarge)
                }
                
                Text(title)
                    .font(.buttonLarge)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity) // Full width button
            .padding(.vertical, 16)
            .background(Color.PrimaryTeal)
            .cornerRadius(14)
            // Add shadow for depth and tactile feel
            .shadow(color: Color.PrimaryTeal.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        // Scale animation on tap for feedback
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Secondary Button
/// Secondary action button with outline style
/// Use for less important actions or when paired with a primary button
/// Example: "Cancel", "View Details", "Skip"
struct SecondaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.icon = nil
        self.action = action
    }
    
    init(_ title: String, icon: String, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.buttonMedium)
                }
                
                Text(title)
                    .font(.buttonMedium)
            }
            .foregroundColor(.PrimaryTeal)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.PrimaryTeal.opacity(0.1)) // Light tint background
            .cornerRadius(12)
            // Subtle border for definition
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.PrimaryTeal.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Icon Button
/// Compact circular button with just an icon
/// Perfect for toolbars, navigation bars, and compact interfaces
/// Example: Share button, favorite button, settings button
struct IconButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    /// Initialize with icon and action, uses primary teal color
    init(icon: String, action: @escaping () -> Void) {
        self.icon = icon
        self.color = .primaryTeal
        self.action = action
    }
    
    /// Initialize with icon, custom color, and action
    init(icon: String, color: Color, action: @escaping () -> Void) {
        self.icon = icon
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 44, height: 44) // Standard touch target size
                .background(color.opacity(0.1))
                .clipShape(Circle())
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Chip Button
/// Pill-shaped button for tags, categories, and filters
/// Useful for multi-select interfaces and category selections
/// Example: Interest categories, filter options
struct ChipButton: View {
    let title: String
    let icon: String?
    let isSelected: Bool
    let action: () -> Void
    
    /// Initialize without icon
    init(_ title: String, isSelected: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = nil
        self.isSelected = isSelected
        self.action = action
    }
    
    /// Initialize with icon
    init(_ title: String, icon: String, isSelected: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold))
                }
                
                Text(title)
                    .font(.bodyMedium)
            }
            .foregroundColor(isSelected ? .white : .primaryTeal)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? Color.primaryTeal : Color.primaryTeal.opacity(0.1))
            .cornerRadius(20) // Full pill shape
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.primaryTeal.opacity(isSelected ? 0 : 0.3), lineWidth: 1)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Floating Action Button (FAB)
/// Large circular floating button, typically positioned at bottom-right
/// Used for primary screen actions that float above content
/// Example: "Add new journey", "Start navigation"
struct FloatingActionButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(
                    // Gradient background for visual interest
                    LinearGradient(
                        colors: [Color.primaryTeal, Color.primaryTeal.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())
                .shadow(color: Color.primaryTeal.opacity(0.4), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Custom Button Style
/// Custom button style that adds a scale animation on press
/// This provides tactile feedback to users when they tap buttons
/// Applied to all button types above for consistent interaction
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Slightly shrink when pressed
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Preview Provider
struct ButtonComponents_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Primary buttons section
                Group {
                    Text("Primary Buttons")
                        .headingLargeStyle()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    PrimaryButton("Start Journey") {
                        print("Primary button tapped")
                    }
                    
                    PrimaryButton("Generate Trip", icon: "sparkles") {
                        print("Primary button with icon tapped")
                    }
                }
                
                Divider()
                
                // Secondary buttons section
                Group {
                    Text("Secondary Buttons")
                        .headingLargeStyle()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    SecondaryButton("View Details") {
                        print("Secondary button tapped")
                    }
                    
                    SecondaryButton("Add to Favorites", icon: "heart") {
                        print("Secondary button with icon tapped")
                    }
                }
                
                Divider()
                
                // Icon buttons section
                Group {
                    Text("Icon Buttons")
                        .headingLargeStyle()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 16) {
                        IconButton(icon: "heart") {
                            print("Heart tapped")
                        }
                        
                        IconButton(icon: "square.and.arrow.up") {
                            print("Share tapped")
                        }
                        
                        IconButton(icon: "bookmark", color: .sunsetOrange) {
                            print("Bookmark tapped")
                        }
                        
                        IconButton(icon: "ellipsis", color: .deepPurple) {
                            print("More tapped")
                        }
                    }
                }
                
                Divider()
                
                // Chip buttons section
                Group {
                    Text("Chip Buttons")
                        .headingLargeStyle()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Create a wrapped layout of chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ChipButton("Beach", icon: "beach.umbrella", isSelected: true) {
                                print("Beach selected")
                            }
                            
                            ChipButton("Museum", icon: "building.columns") {
                                print("Museum tapped")
                            }
                            
                            ChipButton("Food", icon: "fork.knife", isSelected: true) {
                                print("Food selected")
                            }
                            
                            ChipButton("Nature", icon: "leaf") {
                                print("Nature tapped")
                            }
                            
                            ChipButton("Historic", icon: "building.2") {
                                print("Historic tapped")
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Divider()
                
                // Floating action button
                Group {
                    Text("Floating Action Button")
                        .headingLargeStyle()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    FloatingActionButton(icon: "plus") {
                        print("FAB tapped")
                    }
                }
            }
            .padding()
        }
        .background(Color.backgroundGray)
    }
}
