//
//  ProfileView.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 1/10/2025.
//

import SwiftUI

struct ProfileView: View {
    
    
    /// Toggle for push notifications
    @State private var notificationsEnabled: Bool = true
    
    /// Toggle for location services
    @State private var locationEnabled: Bool = true
    
    
    /// Show alert for logout confirmation
    @State private var showLogoutAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Work in Progress Notice
                    workInProgressNotice
                    
                    // MARK: - Profile Header
                    profileHeader
                    
                    // MARK: - Quick Stats
                    quickStats
                    
                    // MARK: - Settings Sections
                    VStack(spacing: 16) {
                        preferencesSection
                        accountSection
                        aboutSection
                    }
                }
                .padding()
            }
            .background(Color.backgroundGray)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .alert("Sign Out", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    print("User signed out")
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }
    
    // MARK: - Work in Progress Notice
    private var workInProgressNotice: some View {
        VStack(spacing: 16) {
            Image(systemName: "hammer.fill")
                .font(.system(size: 48))
                .foregroundColor(.sunsetOrange)
            
            VStack(spacing: 8) {
                Text("🚧 Work in Progress")
                    .font(.headingLarge)
                    .foregroundColor(.textPrimary)
                
                Text("Profile Settings Coming Soon!")
                    .font(.headingMedium)
                    .foregroundColor(.sunsetOrange)
                
                Text("We're working hard to bring you comprehensive profile management features. This section will include account settings, preferences, achievements, and much more in future updates.")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                
                HStack(spacing: 4) {
                    Text("Expected in:")
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                    
                    Text("Next Update")
                        .font(.bodySmall)
                        .fontWeight(.medium)
                        .foregroundColor(.primaryTeal)
                }
                .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .padding(.horizontal, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.SurfaceWhite)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.sunsetOrange.opacity(0.3), lineWidth: 2)
                )
        )
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Profile Header
    // User's profile information at the top
    private var profileHeader: some View {
        VStack(spacing: 16) {
            // Profile picture placeholder
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.primaryTeal, Color.deepPurple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                // User initials or icon
                Text("JD")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
            }
            .shadow(color: Color.primaryTeal.opacity(0.3), radius: 10, x: 0, y: 5)
            
            // User name and email
            VStack(spacing: 4) {
                Text("John Doe")
                    .font(.headingLarge)
                    .foregroundColor(.textPrimary)
                
                Text("john.doe@example.com")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
            }
            
            // Edit profile button
            SecondaryButton("Edit Profile", icon: "pencil") {
                print("Edit profile tapped")
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
    
    // MARK: - Quick Stats
    // Achievement badges and statistics
    private var quickStats: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Achievements")
                .font(.headingMedium)
                .foregroundColor(.textPrimary)
            
            HStack(spacing: 12) {
                // Badge 1
                AchievementBadge(
                    icon: "star.fill",
                    title: "Explorer",
                    color: .sunsetOrange
                )
                
                // Badge 2
                AchievementBadge(
                    icon: "flag.fill",
                    title: "Adventurer",
                    color: .freshGreen
                )
                
                // Badge 3
                AchievementBadge(
                    icon: "medal.fill",
                    title: "Pioneer",
                    color: .deepPurple
                )
                
                // Badge 4 (locked)
                AchievementBadge(
                    icon: "lock.fill",
                    title: "Master",
                    color: .textSecondary,
                    isLocked: true
                )
            }
        }
        .padding()
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
    
    // MARK: - Preferences Section
    /// App preferences and toggles
    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Section header
            Text("Preferences")
                .font(.headingMedium)
                .foregroundColor(.textPrimary)
                .padding(.horizontal)
                .padding(.top)
            
            Divider()
                .padding(.vertical, 8)
            
            // Settings rows
            SettingsToggleRow(
                icon: "bell.fill",
                title: "Push Notifications",
                subtitle: "Get updates about your trips",
                isOn: $notificationsEnabled,
                color: .sunsetOrange
            )
            
            Divider()
                .padding(.leading, 60)
            
            SettingsToggleRow(
                icon: "location.fill",
                title: "Location Services",
                subtitle: "For nearby recommendations",
                isOn: $locationEnabled,
                color: .primaryTeal
            )
            
            
            Divider()
                .padding(.leading, 60)
            
            // Navigation rows
            SettingsNavigationRow(
                icon: "map.fill",
                title: "Default Transport Modes",
                color: .freshGreen
            ) {
                print("Transport modes tapped")
            }
            
            Divider()
                .padding(.leading, 60)
            
            SettingsNavigationRow(
                icon: "clock.fill",
                title: "Saved Locations",
                color: .beachBlue
            ) {
                print("Saved locations tapped")
            }
        }
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
    
    // MARK: - Account Section
    // Account management options
    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Section header
            Text("Account")
                .font(.headingMedium)
                .foregroundColor(.textPrimary)
                .padding(.horizontal)
                .padding(.top)
            
            Divider()
                .padding(.vertical, 8)
            
            SettingsNavigationRow(
                icon: "person.fill",
                title: "Personal Information",
                color: .primaryTeal
            ) {
                print("Personal info tapped")
            }
            
            Divider()
                .padding(.leading, 60)
            
            SettingsNavigationRow(
                icon: "lock.fill",
                title: "Privacy & Security",
                color: .deepPurple
            ) {
                print("Privacy tapped")
            }
            
            Divider()
                .padding(.leading, 60)
            
            SettingsNavigationRow(
                icon: "arrow.down.circle.fill",
                title: "Download My Data",
                color: .freshGreen
            ) {
                print("Download data tapped")
            }
            
            Divider()
                .padding(.leading, 60)
            
            // Sign out button (different style - destructive)
            Button(action: {
                showLogoutAlert = true
            }) {
                HStack(spacing: 16) {
                    Image(systemName: "arrow.right.square.fill")
                        .font(.title3)
                        .foregroundColor(.foodRed)
                        .frame(width: 32)
                    
                    Text("Sign Out")
                        .font(.bodyLarge)
                        .foregroundColor(.foodRed)
                    
                    Spacer()
                }
                .padding()
            }
        }
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
    
    // MARK: - About Section
    // App information and support
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Section header
            Text("About")
                .font(.headingMedium)
                .foregroundColor(.textPrimary)
                .padding(.horizontal)
                .padding(.top)
            
            Divider()
                .padding(.vertical, 8)
            
            SettingsNavigationRow(
                icon: "questionmark.circle.fill",
                title: "Help & Support",
                color: .primaryTeal
            ) {
                print("Help tapped")
            }
            
            Divider()
                .padding(.leading, 60)
            
            SettingsNavigationRow(
                icon: "star.fill",
                title: "Rate the App",
                color: .sunsetOrange
            ) {
                print("Rate app tapped")
            }
            
            Divider()
                .padding(.leading, 60)
            
            SettingsNavigationRow(
                icon: "doc.text.fill",
                title: "Terms & Conditions",
                color: .textSecondary
            ) {
                print("Terms tapped")
            }
            
            Divider()
                .padding(.leading, 60)
            
            // Version info (no navigation)
            HStack(spacing: 16) {
                Image(systemName: "info.circle.fill")
                    .font(.title3)
                    .foregroundColor(.textSecondary)
                    .frame(width: 32)
                
                Text("Version")
                    .font(.bodyLarge)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("1.0.0")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
            }
            .padding()
        }
        .background(Color.SurfaceWhite)
        .cornerRadius(16)
    }
}

// MARK: - Achievement Badge Component
// Individual achievement badge display
struct AchievementBadge: View {
    let icon: String
    let title: String
    let color: Color
    var isLocked: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Icon with colored circle background
            ZStack {
                Circle()
                    .fill(color.opacity(isLocked ? 0.2 : 0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isLocked ? color.opacity(0.5) : color)
            }
            
            // Title
            Text(title)
                .font(.captionSmall)
                .foregroundColor(isLocked ? .textSecondary : .textPrimary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Settings Toggle Row Component
// Row with a toggle switch for settings
struct SettingsToggleRow: View {
    let icon: String
    let title: String
    let subtitle: String?
    @Binding var isOn: Bool
    let color: Color
    
    init(icon: String, title: String, subtitle: String? = nil, isOn: Binding<Bool>, color: Color) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self._isOn = isOn
        self.color = color
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 32)
            
            // Text content
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.bodyLarge)
                    .foregroundColor(.textPrimary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.captionSmall)
                        .foregroundColor(.textSecondary)
                }
            }
            
            Spacer()
            
            // Toggle switch
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(color)
        }
        .padding()
    }
}

// MARK: - Settings Navigation Row Component
/// Row that navigates to another screen when tapped
struct SettingsNavigationRow: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 32)
                
                // Title
                Text(title)
                    .font(.bodyLarge)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                // Chevron indicator
                Image(systemName: "chevron.right")
                    .font(.body)
                    .foregroundColor(.textSecondary)
            }
            .padding()
            .contentShape(Rectangle()) // Makes entire row tappable
        }
    }
}

// MARK: - Preview Provider
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
