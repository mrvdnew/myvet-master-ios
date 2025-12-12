import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingLogoutAlert = false
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    // Profile Header
                    ProfileHeaderCard(user: authViewModel.currentUser)
                    
                    // Account Section
                    ProfileSection(title: "Account") {
                        ProfileMenuItem(
                            icon: "person.circle",
                            title: "Edit Profile",
                            action: { showingEditProfile = true }
                        )
                        
                        ProfileMenuItem(
                            icon: "key.fill",
                            title: "Change Password",
                            action: { }
                        )
                        
                        ProfileMenuItem(
                            icon: "bell.fill",
                            title: "Notifications",
                            action: { }
                        )
                    }
                    
                    // Preferences Section
                    ProfileSection(title: "Preferences") {
                        ProfileMenuItem(
                            icon: "moon.fill",
                            title: "Dark Mode",
                            action: { }
                        )
                        
                        ProfileMenuItem(
                            icon: "globe",
                            title: "Language",
                            subtitle: "English",
                            action: { }
                        )
                    }
                    
                    // About Section
                    ProfileSection(title: "About") {
                        ProfileMenuItem(
                            icon: "info.circle",
                            title: "About MyVet",
                            action: { }
                        )
                        
                        ProfileMenuItem(
                            icon: "doc.text",
                            title: "Terms & Conditions",
                            action: { }
                        )
                        
                        ProfileMenuItem(
                            icon: "hand.raised.fill",
                            title: "Privacy Policy",
                            action: { }
                        )
                    }
                    
                    // Logout Button
                    Button(action: { showingLogoutAlert = true }) {
                        HStack {
                            Image(systemName: "arrow.right.square")
                            Text("Logout")
                        }
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.Colors.error)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornered(AppTheme.CornerRadius.lg)
                        .shadowMedium()
                    }
                    
                    // Version info
                    Text("Version 1.0.0")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .padding(.top, AppTheme.Spacing.md)
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle("Profile")
            .alert("Logout", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Logout", role: .destructive) {
                    authViewModel.logout()
                }
            } message: {
                Text("Are you sure you want to logout?")
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(user: authViewModel.currentUser)
            }
        }
    }
}

struct ProfileHeaderCard: View {
    let user: User?
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            // Profile image
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(AppTheme.Colors.primary)
            
            // User info
            VStack(spacing: AppTheme.Spacing.xs) {
                Text("\(user?.firstName ?? "") \(user?.lastName ?? "")")
                    .font(AppTheme.Typography.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.Colors.text)
                
                Text(user?.email ?? "")
                    .font(AppTheme.Typography.callout)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                
                if let phone = user?.phoneNumber {
                    Label(phone, systemImage: "phone.fill")
                        .font(AppTheme.Typography.callout)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
            }
            
            // Address
            if let address = user?.address {
                VStack(spacing: AppTheme.Spacing.xs) {
                    Divider()
                        .padding(.vertical, AppTheme.Spacing.xs)
                    
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(AppTheme.Colors.primary)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(address.street)
                                .font(AppTheme.Typography.caption)
                            Text("\(address.city), \(address.state) \(address.zipCode)")
                                .font(AppTheme.Typography.caption)
                        }
                        .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornered(AppTheme.CornerRadius.lg)
        .shadowMedium()
    }
}

struct ProfileSection: View {
    let title: String
    let content: () -> AnyView
    
    init(title: String, @ViewBuilder content: @escaping () -> some View) {
        self.title = title
        self.content = { AnyView(content()) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text(title)
                .font(AppTheme.Typography.headline)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .padding(.horizontal)
            
            VStack(spacing: 1) {
                content()
            }
            .background(Color.white)
            .cornered(AppTheme.CornerRadius.lg)
            .shadowMedium()
        }
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    var subtitle: String?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppTheme.Colors.primary)
                    .frame(width: 30)
                
                Text(title)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.text)
                
                Spacer()
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(AppTheme.Typography.callout)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            .padding()
            .background(Color.white)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    let user: User?
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var street = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }
                
                Section(header: Text("Address")) {
                    TextField("Street", text: $street)
                    TextField("City", text: $city)
                    TextField("State", text: $state)
                    TextField("ZIP Code", text: $zipCode)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                    }
                }
            }
            .onAppear {
                loadUserData()
            }
        }
    }
    
    private func loadUserData() {
        firstName = user?.firstName ?? ""
        lastName = user?.lastName ?? ""
        email = user?.email ?? ""
        phoneNumber = user?.phoneNumber ?? ""
        street = user?.address.street ?? ""
        city = user?.address.city ?? ""
        state = user?.address.state ?? ""
        zipCode = user?.address.zipCode ?? ""
    }
    
    private func saveProfile() {
        // TODO: Implement profile update
        dismiss()
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
