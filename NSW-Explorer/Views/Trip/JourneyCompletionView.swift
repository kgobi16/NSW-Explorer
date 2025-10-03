//
//  JourneyCompletionView.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 3/10/2025.
//
//  Celebration view shown when a journey is completed
//  Shows summary, stats, and options to share or view log
//

import SwiftUI

struct JourneyCompletionView: View {
    let activeJourney: ActiveJourney
    
    @Environment(\.dismiss) var dismiss
    @State private var showConfetti: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    celebrationHeader
                    journeySummary
                    statisticsSection
                    highlightsSection
                    actionButtons
                }
                .padding()
            }
            .background(Color.BackgroundGray)
            .navigationTitle("Journey Complete!")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showConfetti = true
                }
            }
        }
    }
    
    private var celebrationHeader: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.FreshGreen, Color.PrimaryTeal],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(showConfetti ? 1.0 : 0.5)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6), value: showConfetti)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(showConfetti ? 1.0 : 0.5)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1), value: showConfetti)
            }
            .shadow(color: Color.FreshGreen.opacity(0.3), radius: 20, x: 0, y: 10)
            
            VStack(spacing: 8) {
                Text("Congratulations!")
                    .font(.displaylarge)
                    .foregroundColor(.TextPrimary)
                    .opacity(showConfetti ? 1 : 0)
                    .animation(.easeIn(duration: 0.5).delay(0.3), value: showConfetti)
                
                Text("You've completed your journey")
                    .font(.bodyLarge)
                    .foregroundColor(.TextSecondary)
                    .opacity(showConfetti ? 1 : 0)
                    .animation(.easeIn(duration: 0.5).delay(0.4), value: showConfetti)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
    
    private var journeySummary: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(activeJourney.journeyName)
                        .font(.headingLarge)
                        .foregroundColor(.TextPrimary)
                    
                    HStack(spacing: 8) {
                        Image(systemName: activeJourney.category.icon)
                        Text(activeJourney.category.rawValue)
                    }
                    .font(.bodyMedium)
                    .foregroundColor(Color(activeJourney.category.colorName))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(activeJourney.category.colorName).opacity(0.1))
                    .cornerRadius(12)
                }
                
                Spacer()
            }
            
            Divider()
            
            HStack {
                Label("Completed", systemImage: "calendar")
                    .font(.bodyMedium)
                    .foregroundColor(.TextSecondary)
                
                Spacer()
                
                Text(formattedDate(activeJourney.completedAt ?? Date()))
                    .font(.bodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(.TextPrimary)
            }
        }
        .padding()
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
    
    private var statisticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Stats")
                .font(.headingMedium)
                .foregroundColor(.TextPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatCard(
                    icon: "clock.fill",
                    value: activeJourney.durationString,
                    label: "Total Time",
                    color: .PrimaryTeal
                )
                
                StatCard(
                    icon: "mappin.circle.fill",
                    value: "\(activeJourney.stops.count)",
                    label: "Stops Visited",
                    color: .SunsetOrange
                )
                
                StatCard(
                    icon: "location.fill",
                    value: activeJourney.distanceString,
                    label: "Distance",
                    color: .DeepPurple
                )
                
                StatCard(
                    icon: "photo.fill",
                    value: "\(activeJourney.checkIns.filter { $0.hasPhoto }.count)",
                    label: "Photos",
                    color: .FreshGreen
                )
            }
        }
        .padding()
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
    
    private var highlightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Journey Highlights")
                .font(.headingMedium)
                .foregroundColor(.TextPrimary)
            
            if !activeJourney.checkIns.isEmpty {
                VStack(spacing: 12) {
                    ForEach(activeJourney.checkIns) { checkIn in
                        if checkIn.hasNotes || checkIn.hasRating {
                            HighlightCard(
                                checkIn: checkIn,
                                stop: activeJourney.stops.first { $0.id == checkIn.stopId }
                            )
                        }
                    }
                }
            } else {
                Text("No highlights recorded")
                    .font(.bodyMedium)
                    .foregroundColor(.TextSecondary)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
        .padding()
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            PrimaryButton("Share Journey", icon: "square.and.arrow.up") {
                print("Share journey")
            }
            
            SecondaryButton("View Full Log", icon: "book") {
                print("View log")
                dismiss()
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
            
            Text(value)
                .font(.headingLarge)
                .foregroundColor(.TextPrimary)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.TextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct HighlightCard: View {
    let checkIn: CheckIn
    let stop: Stop?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let stop = stop {
                    Text(stop.name)
                        .font(.headingSmall)
                        .foregroundColor(.TextPrimary)
                }
                
                Spacer()
                
                Text(checkIn.timeString)
                    .font(.caption)
                    .foregroundColor(.TextSecondary)
            }
            
            if checkIn.hasRating {
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= (checkIn.rating ?? 0) ? "star.fill" : "star")
                            .font(.caption)
                            .foregroundColor(.SunsetOrange)
                    }
                }
            }
            
            if checkIn.hasNotes {
                Text(checkIn.notes ?? "")
                    .font(.bodyMedium)
                    .foregroundColor(.TextSecondary)
                    .lineLimit(3)
            }
            
            if checkIn.hasPhoto {
                HStack(spacing: 4) {
                    Image(systemName: "photo.fill")
                        .font(.caption)
                    Text("Photo attached")
                        .font(.caption)
                }
                .foregroundColor(.PrimaryTeal)
            }
        }
        .padding()
        .background(Color.BackgroundGray)
        .cornerRadius(12)
    }
}

struct JourneyCompletionView_Previews: PreviewProvider {
    static var previews: some View {
        JourneyCompletionView(activeJourney: {
            var journey = ActiveJourney.sample
            journey.completedAt = Date()
            return journey
        }())
    }
}
