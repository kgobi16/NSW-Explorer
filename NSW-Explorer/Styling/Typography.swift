//
//  Typography.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 1/10/2025.
//

import SwiftUI

extension Font {
    
    // MARK: - Heading Styles
    // Large, bold text for major headings and hero sections
    static let displaylarge = Font.system(size: 34, weight: .bold, design: .rounded)
    static let displaymedium = Font.system(size: 28, weight: .bold, design: .rounded)
    
    // MARK: - Heading Styles
    // For content hierarchy and subsection titles
    static let headingLarge = Font.system(size: 22, weight: .semibold, design: .rounded)
    static let headingMedium = Font.system(size: 18, weight: .semibold, design: .rounded)
    static let headingSmall = Font.system(size: 16, weight: .semibold, design: .rounded)
    
    // MARK: - Body Styles
    // Standard readable text for main content
    
    static let bodyLarge = Font.system(size: 16, weight: .regular, design: .default)
    static let bodyMedium = Font.system(size: 14, weight: .regular, design: .default)
    static let bodySmall = Font.system(size: 12, weight: .regular, design: .default)
    
    // MARK: - Caption Styles
    // Small text for metadata and supporting information
    
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
    static let captionSmall = Font.system(size: 10, weight: .regular, design: .default)
    
    // MARK: - Button Styles
    // Text styles specifically for buttons and CTAs
    
    static let buttonLarge = Font.system(size: 16, weight: .medium, design: .default)
    static let buttonMedium = Font.system(size: 14, weight: .medium, design: .default)
    static let buttonSmall = Font.system(size: 12, weight: .medium, design: .default)
    
}

extension View {
    
    func displayLargeStyle() -> some View {
        self
            .font(Font.displaylarge)
            .foregroundColor(Color.black)
            .lineLimit(2)
            .minimumScaleFactor(0.8)
    }
    
    // Apply medium display styling
       func displayMediumStyle() -> some View {
           self
               .font(Font.displaymedium)
               .foregroundColor(.TextPrimary)
               .lineLimit(2)
               .minimumScaleFactor(0.9)
       }
       
       // MARK: - Heading Modifiers
       
       /// Apply large heading style
       /// Used for prominent content titles
       func headingLargeStyle() -> some View {
           self
               .font(.headingLarge)
               .foregroundColor(.TextPrimary)
               .lineLimit(3)
       }
       
       /// Apply medium heading style
       func headingMediumStyle() -> some View {
           self
               .font(.headingMedium)
               .foregroundColor(.TextPrimary)
               .lineLimit(2)
       }
       
       /// Apply small heading style
       func headingSmallStyle() -> some View {
           self
               .font(.headingSmall)
               .foregroundColor(.TextPrimary)
               .lineLimit(1)
       }
       
       // MARK: - Body Modifiers
       
       /// Apply primary body text style
       /// Used for main readable content
       func bodyLargeStyle() -> some View {
           self
               .font(.bodyLarge)
               .foregroundColor(.TextPrimary)
               .lineSpacing(4) // Extra spacing for readability
       }
       
       /// Apply secondary body text style
       func bodyMediumStyle() -> some View {
           self
               .font(.bodyMedium)
               .foregroundColor(.TextSecondary)
               .lineSpacing(2)
       }
       
       /// Apply small body text style
       func bodySmallStyle() -> some View {
           self
               .font(.bodySmall)
               .foregroundColor(.TextSecondary)
       }
       
       // MARK: - Caption Modifiers
       
       /// Apply caption style with secondary color
       /// Perfect for metadata and timestamps
       func captionStyle() -> some View {
           self
               .font(.caption)
               .foregroundColor(.TextSecondary)
               .lineLimit(1)
       }
       
       /// Apply small caption style
       func captionSmallStyle() -> some View {
           self
               .font(.captionSmall)
               .foregroundColor(.TextSecondary)
               .lineLimit(1)
       }
   }

   // MARK: - Preview Provider
   // Displays all typography styles for easy reference
   struct Typography_Previews: PreviewProvider {
       static var previews: some View {
           ScrollView {
               VStack(alignment: .leading, spacing: 24) {
                   // Display styles
                   Group {
                       Text("Display Large")
                           .displayLargeStyle()
                       
                       Text("Display Medium")
                           .displayMediumStyle()
                   }
                   
                   Divider()
                   
                   // Heading styles
                   Group {
                       Text("Heading Large - Perfect for Journey Titles")
                           .headingLargeStyle()
                       
                       Text("Heading Medium - For Stop Names")
                           .headingMediumStyle()
                       
                       Text("Heading Small - Category Labels")
                           .headingSmallStyle()
                   }
                   
                   Divider()
                   
                   // Body styles
                   Group {
                       Text("Body Large - This is your main readable content. It's comfortable to read and works well for descriptions and longer text passages.")
                           .bodyLargeStyle()
                       
                       Text("Body Medium - Secondary information that's still important but doesn't need as much emphasis.")
                           .bodyMediumStyle()
                       
                       Text("Body Small - For compact displays where space is limited.")
                           .bodySmallStyle()
                   }
                   
                   Divider()
                   
                   // Caption styles
                   Group {
                       Text("Caption - 2.5km • 45 min • Moderate")
                           .captionStyle()
                       
                       Text("Caption Small - Fine print")
                           .captionSmallStyle()
                   }
                   
                   Divider()
                   
                   // Button examples
                   Group {
                       Text("Start Journey")
                           .font(.buttonLarge)
                           .foregroundColor(.white)
                           .padding(.horizontal, 32)
                           .padding(.vertical, 14)
                           .background(Color.PrimaryTeal)
                           .cornerRadius(12)
                       
                       Text("View Details")
                           .font(.buttonMedium)
                           .foregroundColor(.PrimaryTeal)
                           .padding(.horizontal, 24)
                           .padding(.vertical, 10)
                           .background(Color.PrimaryTeal.opacity(0.1))
                           .cornerRadius(10)
                   }
               }
               .padding()
           }
           .background(Color.BackgroundGray)
       }
   }


