import SwiftUI
import MapKit

struct TripMapView: View {
    let journey: GeneratedJourney
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    var body: some View {
        VStack(spacing: 0) {
            // Map
            Map(coordinateRegion: $region, annotationItems: journey.stops) { stop in
                MapAnnotation(coordinate: stop.coordinate) {
                    StopMapAnnotation(stop: stop)
                }
            }
            .ignoresSafeArea(.container, edges: .top)
            .onAppear {
                setupMapRegion()
            }
            
            // Bottom panel with trip details
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(journey.title)
                            .font(.headingLarge)
                            .foregroundColor(.textPrimary)
                        
                        Text("\(journey.stops.count) stops • \(journey.distanceString) • \(journey.durationString)")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Start journey action
                    }) {
                        Image(systemName: "play.fill")
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.primaryTeal)
                            .clipShape(Circle())
                    }
                }
                
                // Stop list preview
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(Array(journey.stops.enumerated()), id: \.element.id) { index, stop in
                            MapStopPreviewCard(stop: stop, index: index + 1)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            .background(Color.SurfaceWhite)
            .cornerRadius(20, corners: [.topLeft, .topRight])
            .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {}) {
                        Label("Share Trip", systemImage: "square.and.arrow.up")
                    }
                    Button(action: {}) {
                        Label("Save to My Trips", systemImage: "heart")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.textPrimary)
                }
            }
        }
    }
    
    private func setupMapRegion() {
        guard !journey.stops.isEmpty else { return }
        
        let coordinates = journey.stops.map { $0.coordinate }
        let minLat = coordinates.map { $0.latitude }.min() ?? -33.8688
        let maxLat = coordinates.map { $0.latitude }.max() ?? -33.8688
        let minLon = coordinates.map { $0.longitude }.min() ?? 151.2093
        let maxLon = coordinates.map { $0.longitude }.max() ?? 151.2093
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: max(maxLat - minLat, 0.01) * 1.5,
            longitudeDelta: max(maxLon - minLon, 0.01) * 1.5
        )
        
        region = MKCoordinateRegion(center: center, span: span)
    }
}

struct StopMapAnnotation: View {
    let stop: Stop
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color(stop.type.colorName))
                    .frame(width: 30, height: 30)
                
                Image(systemName: stop.type.icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
            .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
            
            Text(stop.name)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.SurfaceWhite)
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.15), radius: 2, y: 1)
        }
    }
}

struct MapStopPreviewCard: View {
    let stop: Stop
    let index: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(index)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 20, height: 20)
                    .background(Color(stop.type.colorName))
                    .clipShape(Circle())
                
                Spacer()
                
                Image(systemName: stop.type.icon)
                    .font(.system(size: 16))
                    .foregroundColor(Color(stop.type.colorName))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(stop.name)
                    .font(.bodyMedium)
                    .fontWeight(.medium)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                
                Text(stop.durationString)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                
                if let rating = stop.rating {
                    HStack(spacing: 2) {
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
        }
        .frame(width: 120, height: 100)
        .padding()
        .background(Color.backgroundGray)
        .cornerRadius(12)
    }
}

// Extension for rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 10
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct TripMapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TripMapView(journey: GeneratedJourney.sample)
        }
    }
}
