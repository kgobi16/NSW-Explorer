//
//  ActiveJourneyView.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 3/10/2025.
//
//  Main view for tracking an active journey
//  Shows progress, current stop, and allows check-ins
//

import SwiftUI

struct ActiveJourneyView: View {
    @StateObject private var viewModel: ActiveJourneyViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showCompletionSheet: Bool = false
    @State private var showCancelAlert: Bool = false
    
    init(activeJourney: ActiveJourney) {
        _viewModel = StateObject(wrappedValue: {
            let vm = ActiveJourneyViewModel()
            vm.activeJourney = activeJourney
            return vm
        }())
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                progressHeader
                
                if let currentStop = viewModel.activeJourney?.currentStop {
                    currentStopCard(currentStop)
                }
                
                stopsTimeline
                journeyInfoSection
            }
            .padding()
        }
        .background(Color.BackgroundGray)
        .navigationTitle(viewModel.activeJourney?.journeyName ?? "Journey")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        print("View on map")
                    }) {
                        Label("View Map", systemImage: "map")
                    }
                    
                    Button(action: {
                        print("Share journey")
                    }) {
                        Label("Share Progress", systemImage: "square.and.arrow.up")
                    }
                    
                    Divider()
                    
                    Button(role: .destructive, action: {
                        showCancelAlert = true
                    }) {
                        Label("Cancel Journey", systemImage: "xmark.circle")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.PrimaryTeal)
                }
            }
        }
        .sheet(isPresented: $viewModel.showCheckInSheet) {
            if let stop = viewModel.selectedStop {
                CheckInView(
                    stop: stop,
                    onCheckIn: { notes, photoFilename, rating in
                        viewModel.checkIn(
                            at: stop,
                            notes: notes,
                            photoFilename: photoFilename,
                            rating: rating
                        )
                    }
                )
            }
        }
        .sheet(isPresented: $showCompletionSheet) {
            if let journey = viewModel.activeJourney {
                JourneyCompletionView(activeJourney: journey)
            }
        }
        .alert("Cancel Journey?", isPresented: $showCancelAlert) {
            Button("Keep Going", role: .cancel) { }
            Button("Cancel Journey", role: .destructive) {
                viewModel.cancelJourney()
                dismiss()
            }
        } message: {
            Text("Your progress will be lost if you cancel this journey.")
        }
        .onChange(of: viewModel.activeJourney?.isCompleted) { _, isCompleted in
            if isCompleted == true {
                showCompletionSheet = true
            }
        }
    }
    
    private var progressHeader: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Journey Progress")
                        .font(.headingMedium)
                        .foregroundColor(.TextPrimary)
                    
                    Spacer()
                    
                    Text("\(viewModel.activeJourney?.completedStopsCount ?? 0)/\(viewModel.activeJourney?.stops.count ?? 0)")
                        .font(.bodyMedium)
                        .fontWeight(.semibold)
                        .foregroundColor(.PrimaryTeal)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.PrimaryTeal.opacity(0.2))
                            .frame(height: 12)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.PrimaryTeal)
                            .frame(
                                width: geometry.size.width * (viewModel.activeJourney?.progress ?? 0),
                                height: 12
                            )
                            .animation(.easeInOut, value: viewModel.activeJourney?.progress)
                    }
                }
                .frame(height: 12)
            }
            
            HStack(spacing: 0) {
                StatItem(
                    icon: "clock.fill",
                    value: viewModel.activeJourney?.durationString ?? "0m",
                    label: "Elapsed",
                    color: .PrimaryTeal
                )
                
                Divider()
                    .frame(height: 50)
                
                StatItem(
                    icon: "hourglass",
                    value: viewModel.timeRemainingString(),
                    label: "Remaining",
                    color: .SunsetOrange
                )
                
                Divider()
                    .frame(height: 50)
                
                StatItem(
                    icon: "checkmark.circle.fill",
                    value: "\(viewModel.activeJourney?.completedStopsCount ?? 0)",
                    label: "Completed",
                    color: .FreshGreen
                )
            }
            .frame(height: 80)
        }
        .padding()
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
    
    private func currentStopCard(_ stop: Stop) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("NEXT STOP")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.SunsetOrange)
                    
                    Text(stop.name)
                        .font(.headingLarge)
                        .foregroundColor(.TextPrimary)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color(stop.type.colorName))
                        .frame(width: 44, height: 44)
                    
                    Text("\(stop.order + 1)")
                        .font(.headingSmall)
                        .foregroundColor(.white)
                }
            }
            
            Text(stop.description)
                .font(.bodyMedium)
                .foregroundColor(.TextSecondary)
                .lineSpacing(4)
            
            HStack(spacing: 16) {
                Label(stop.type.rawValue, systemImage: stop.type.icon)
                    .font(.caption)
                    .foregroundColor(Color(stop.type.colorName))
                
                Label(stop.durationString, systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.TextSecondary)
            }
            
            if let notes = stop.notes {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .font(.caption)
                        .foregroundColor(.SunsetOrange)
                    
                    Text(notes)
                        .font(.caption)
                        .foregroundColor(.SunsetOrange)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.SunsetOrange.opacity(0.1))
                .cornerRadius(12)
            }
            
            if !viewModel.isStopCompleted(stop) {
                PrimaryButton("Check In Here", icon: "checkmark.circle.fill") {
                    viewModel.openCheckIn(for: stop)
                }
            } else {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.FreshGreen)
                    Text("Completed")
                        .font(.bodyLarge)
                        .fontWeight(.semibold)
                        .foregroundColor(.FreshGreen)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.FreshGreen.opacity(0.1))
                .cornerRadius(14)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.SurfaceWhite)
                .shadow(color: Color.SunsetOrange.opacity(0.2), radius: 12, x: 0, y: 4)
        )
    }
    
    private var stopsTimeline: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("All Stops")
                .font(.headingMedium)
                .foregroundColor(.TextPrimary)
            
            VStack(spacing: 0) {
                ForEach(Array((viewModel.activeJourney?.stops ?? []).enumerated()), id: \.element.id) { index, stop in
                    ActiveStopRow(
                        stop: stop,
                        isCompleted: viewModel.isStopCompleted(stop),
                        isCurrent: viewModel.activeJourney?.currentStop?.id == stop.id,
                        isLast: index == (viewModel.activeJourney?.stops.count ?? 0) - 1,
                        checkIn: viewModel.getCheckIn(for: stop)
                    ) {
                        viewModel.openCheckIn(for: stop)
                    }
                }
            }
        }
        .padding()
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
    
    private var journeyInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Journey Information")
                .font(.headingMedium)
                .foregroundColor(.TextPrimary)
            
            VStack(spacing: 12) {
                InfoRow(
                    icon: "calendar",
                    label: "Started",
                    value: formattedDate(viewModel.activeJourney?.startedAt ?? Date())
                )
                
                InfoRow(
                    icon: "map",
                    label: "Category",
                    value: viewModel.activeJourney?.category.rawValue ?? ""
                )
                
                InfoRow(
                    icon: "location",
                    label: "Distance",
                    value: viewModel.activeJourney?.distanceString ?? "0 km"
                )
            }
        }
        .padding()
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(.headingSmall)
                .foregroundColor(.TextPrimary)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.TextSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Label(label, systemImage: icon)
                .font(.bodyMedium)
                .foregroundColor(.TextSecondary)
            
            Spacer()
            
            Text(value)
                .font(.bodyMedium)
                .fontWeight(.semibold)
                .foregroundColor(.TextPrimary)
        }
    }
}

struct ActiveStopRow: View {
    let stop: Stop
    let isCompleted: Bool
    let isCurrent: Bool
    let isLast: Bool
    let checkIn: CheckIn?
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                VStack(spacing: 0) {
                    ZStack {
                        Circle()
                            .fill(isCompleted ? Color.FreshGreen : (isCurrent ? Color.SunsetOrange : Color.TextSecondary.opacity(0.3)))
                            .frame(width: 32, height: 32)
                        
                        if isCompleted {
                            Image(systemName: "checkmark")
                                .font(.caption)
                                .foregroundColor(.white)
                        } else {
                            Text("\(stop.order + 1)")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                    
                    if !isLast {
                        Rectangle()
                            .fill(isCompleted ? Color.FreshGreen.opacity(0.3) : Color.TextSecondary.opacity(0.2))
                            .frame(width: 2, height: 50)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(stop.name)
                            .font(.headingSmall)
                            .foregroundColor(.TextPrimary)
                        
                        Spacer()
                        
                        if isCurrent {
                            Text("CURRENT")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.SunsetOrange)
                                .cornerRadius(8)
                        }
                    }
                    
                    if isCompleted, let checkIn = checkIn {
                        VStack(alignment: .leading, spacing: 6) {
                            Label(checkIn.timeString, systemImage: "clock")
                                .font(.caption)
                                .foregroundColor(.FreshGreen)
                            
                            if checkIn.hasNotes {
                                Text(checkIn.notes ?? "")
                                    .font(.caption)
                                    .foregroundColor(.TextSecondary)
                                    .lineLimit(2)
                            }
                            
                            if checkIn.hasRating {
                                HStack(spacing: 2) {
                                    ForEach(1...5, id: \.self) { star in
                                        Image(systemName: star <= (checkIn.rating ?? 0) ? "star.fill" : "star")
                                            .font(.caption2)
                                            .foregroundColor(.SunsetOrange)
                                    }
                                }
                            }
                        }
                        .padding(8)
                        .background(Color.FreshGreen.opacity(0.1))
                        .cornerRadius(8)
                    } else {
                        Text(stop.description)
                            .font(.caption)
                            .foregroundColor(.TextSecondary)
                            .lineLimit(2)
                    }
                }
                .padding(.bottom, isLast ? 0 : 12)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ActiveJourneyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ActiveJourneyView(activeJourney: ActiveJourney.sample)
        }
    }
}
