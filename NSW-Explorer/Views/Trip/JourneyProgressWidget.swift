//
//  JourneyProgressWidget.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 3/10/2025.
//
//  Compact widget showing journey progress
//  Can be displayed in lists or as a floating overlay
//

import SwiftUI

// MARK: - Journey Progress Widget
/// Compact progress indicator for active journeys
/// Shows progress bar and quick stats
struct JourneyProgressWidget: View {
    // MARK: - Properties
    
    /// The active journey to display
    let activeJourney: ActiveJourney
    
    /// Optional tap action
    var onTap: (() -> Void)?
    
    /// Compact mode (smaller version)
    var compact: Bool = false
    
    var body: some View {
        Button(action: {
            onTap?()
        }) {
            VStack(alignment: .leading, spacing: compact ? 8 : 12) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Journey in Progress")
                            .font(compact ? .caption : .bodyMedium)
                            .fontWeight(.semibold)
                            .foregroundColor(.PrimaryTeal)
                        
                        Text(activeJourney.journeyName)
                            .font(compact ? .bodyMedium : .headingSmall)
                            .foregroundColor(.TextPrimary)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    if !compact {
                        Image(systemName: "chevron.right")
                            .font(.body)
                            .foregroundColor(.TextSecondary)
                    }
                }
                
                // Progress bar
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("\(activeJourney.completedStopsCount)/\(activeJourney.stops.count) stops")
                            .font(.caption)
                            .foregroundColor(.TextSecondary)
                        
                        Spacer()
                        
                        Text("\(Int(activeJourney.progress * 100))%")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.PrimaryTeal)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.PrimaryTeal.opacity(0.2))
                                .frame(height: 8)
                            
                            // Progress
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.PrimaryTeal)
                                .frame(
                                    width: geometry.size.width * activeJourney.progress,
                                    height: 8
                                )
                                .animation(.easeInOut, value: activeJourney.progress)
                        }
                    }
                    .frame(height: 8)
                }
                
                // Stats (only in full mode)
                if !compact {
                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .font(.caption)
                            Text(activeJourney.durationString)
                                .font(.caption)
                        }
                        .foregroundColor(.TextSecondary)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                            Text("\(activeJourney.completedStopsCount) completed")
                                .font(.caption)
                        }
                        .foregroundColor(.FreshGreen)
                        
                        Spacer()
                    }
                }
            }
            .padding(compact ? 12 : 16)
            .background(Color.SurfaceWhite)
            .cornerRadius(12)
            .shadow(color: Color.PrimaryTeal.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Mini Progress Ring
/// Circular progress indicator
/// Useful for compact displays like lists or cards
struct MiniProgressRing: View {
    let progress: Double // 0.0 to 1.0
    let color: Color
    var lineWidth: CGFloat = 4
    var size: CGFloat = 40
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
            
            // Progress arc
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
            
            // Percentage text
            Text("\(Int(progress * 100))%")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Stop Progress Indicator
/// Visual indicator for stop completion in lists
/// Shows checkmark for completed, number for pending
struct StopProgressIndicator: View {
    let stop: Stop
    let isCompleted: Bool
    let isCurrent: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: 32, height: 32)
            
            if isCompleted {
                Image(systemName: "checkmark")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            } else {
                Text("\(stop.order + 1)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(isCurrent ? .white : Color(stop.type.colorName))
            }
        }
    }
    
    private var backgroundColor: Color {
        if isCompleted {
            return .FreshGreen
        } else if isCurrent {
            return .SunsetOrange
        } else {
            return Color(stop.type.colorName).opacity(0.2)
        }
    }
}

// MARK: - Timeline Connector
/// Visual line connecting stops in a timeline
struct TimelineConnector: View {
    let isCompleted: Bool
    let height: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(isCompleted ? Color.FreshGreen.opacity(0.3) : Color.TextSecondary.opacity(0.2))
            .frame(width: 2, height: height)
    }
}

// MARK: - Preview Provider
struct JourneyProgressWidget_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Full widget
            JourneyProgressWidget(
                activeJourney: ActiveJourney.sample,
                onTap: {
                    print("Widget tapped")
                }
            )
            
            // Compact widget
            JourneyProgressWidget(
                activeJourney: ActiveJourney.sample,
                compact: true
            )
            
            // Progress ring examples
            HStack(spacing: 20) {
                MiniProgressRing(progress: 0.25, color: .PrimaryTeal)
                MiniProgressRing(progress: 0.5, color: .SunsetOrange)
                MiniProgressRing(progress: 0.75, color: .FreshGreen)
                MiniProgressRing(progress: 1.0, color: .DeepPurple)
            }
            
            // Stop indicators
            HStack(spacing: 16) {
                StopProgressIndicator(
                    stop: Stop.sample,
                    isCompleted: true,
                    isCurrent: false
                )
                
                StopProgressIndicator(
                    stop: Stop.sampleStops[1],
                    isCompleted: false,
                    isCurrent: true
                )
                
                StopProgressIndicator(
                    stop: Stop.sampleStops[2],
                    isCompleted: false,
                    isCurrent: false
                )
            }
        }
        .padding()
        .background(Color.BackgroundGray)
        .previewLayout(.sizeThatFits)
    }
}
