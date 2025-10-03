//
//  CheckInView.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 3/10/2025.
//
//  Modal view for checking in at a stop
//  Allows users to add notes, photos, and ratings
//

import SwiftUI
import PhotosUI

struct CheckInView: View {
    let stop: Stop
    let onCheckIn: (String?, String?, Int?) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    @State private var notes: String = ""
    @State private var rating: Int? = nil
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoImage: UIImage?
    @State private var isUploadingPhoto: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    stopInfoSection
                    photoSection
                    ratingSection
                    notesSection
                    checkInButton
                }
                .padding()
            }
            .background(Color.BackgroundGray)
            .navigationTitle("Check In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onChange(of: selectedPhoto) { _, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    photoImage = uiImage
                }
            }
        }
    }
    
    private var stopInfoSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(stop.type.colorName).opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: stop.type.icon)
                    .font(.system(size: 36))
                    .foregroundColor(Color(stop.type.colorName))
            }
            
            Text(stop.name)
                .font(.headingLarge)
                .foregroundColor(.TextPrimary)
                .multilineTextAlignment(.center)
            
            Text(stop.description)
                .font(.bodyMedium)
                .foregroundColor(.TextSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
            
            HStack(spacing: 16) {
                Label(stop.type.rawValue, systemImage: stop.type.icon)
                    .font(.caption)
                    .foregroundColor(Color(stop.type.colorName))
                
                Label(stop.durationString, systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.TextSecondary)
            }
        }
        .padding()
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
    
    private var photoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add a Photo")
                .font(.headingMedium)
                .foregroundColor(.TextPrimary)
            
            if let image = photoImage {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Button(action: {
                        photoImage = nil
                        selectedPhoto = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding(8)
                }
            } else {
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    VStack(spacing: 12) {
                        Image(systemName: "camera.fill")
                            .font(.largeTitle)
                            .foregroundColor(.PrimaryTeal.opacity(0.5))
                        
                        Text("Tap to add photo")
                            .font(.bodyMedium)
                            .foregroundColor(.TextSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 150)
                    .background(Color.PrimaryTeal.opacity(0.1))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.PrimaryTeal.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [8]))
                    )
                }
            }
        }
        .padding()
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
    
    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Rate Your Experience")
                .font(.headingMedium)
                .foregroundColor(.TextPrimary)
            
            HStack(spacing: 12) {
                ForEach(1...5, id: \.self) { star in
                    Button(action: {
                        if rating == star {
                            rating = nil
                        } else {
                            rating = star
                        }
                    }) {
                        Image(systemName: star <= (rating ?? 0) ? "star.fill" : "star")
                            .font(.title)
                            .foregroundColor(star <= (rating ?? 0) ? .SunsetOrange : .TextSecondary.opacity(0.3))
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add Notes")
                .font(.headingMedium)
                .foregroundColor(.TextPrimary)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.BackgroundGray)
                
                if notes.isEmpty {
                    Text("Share your thoughts about this stop...")
                        .font(.bodyMedium)
                        .foregroundColor(.TextSecondary.opacity(0.5))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 16)
                }
                
                TextEditor(text: $notes)
                    .font(.bodyMedium)
                    .foregroundColor(.TextPrimary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
            }
            .frame(height: 120)
            
            HStack {
                Spacer()
                Text("\(notes.count)/500")
                    .font(.caption)
                    .foregroundColor(.TextSecondary)
            }
        }
        .padding()
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
    
    private var checkInButton: some View {
        VStack(spacing: 12) {
            PrimaryButton("Complete Check-In", icon: "checkmark.circle.fill") {
                performCheckIn()
            }
            
            Text("You can edit this later")
                .font(.caption)
                .foregroundColor(.TextSecondary)
        }
    }
    
    private func performCheckIn() {
        var photoFilename: String? = nil
        if photoImage != nil {
            photoFilename = "photo_\(UUID().uuidString).jpg"
        }
        
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalNotes = trimmedNotes.isEmpty ? nil : trimmedNotes
        
        onCheckIn(finalNotes, photoFilename, rating)
        dismiss()
    }
}

struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInView(
            stop: Stop.sample,
            onCheckIn: { notes, photo, rating in
                print("Check-in: \(notes ?? "no notes"), \(photo ?? "no photo"), \(rating?.description ?? "no rating")")
            }
        )
    }
}
