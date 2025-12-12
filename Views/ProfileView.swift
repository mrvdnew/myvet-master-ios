import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingEditProfile = false
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile Header
                        VStack(spacing: 16) {
                            // Avatar
                            ZStack {
                                Circle()
                                    .fill(AppTheme.Colors.primary.opacity(0.2))
                                    .frame(width: 100, height: 100)
                                
                                if let profileImageUrl = authViewModel.currentUser?.profileImageUrl {
                                    AsyncImage(url: URL(string: profileImageUrl)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(AppTheme.Colors.primary)
                                    }
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(AppTheme.Colors.primary)
                                }
                            }
                            
                            // User Info
                            VStack(spacing: 4) {
                                Text("\(authViewModel.currentUser?.firstName ?? "") \(authViewModel.currentUser?.lastName ?? "")")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppTheme.Colors.text)
                                
                                Text(authViewModel.currentUser?.email ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(AppTheme.Colors.textSecondary)
                            }
                            
                            // Edit Button
                            Button(action: { showingEditProfile = true }) {
                                Text("Editar Perfil")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(AppTheme.Colors.primary)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 8)
                                    .background(AppTheme.Colors.primary.opacity(0.1))
                                    .cornerRadius(20)
                            }
                        }
                        .padding(.top, 20)
                        
                        // Personal Information Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Información Personal")
                                .font(.headline)
                                .foregroundColor(AppTheme.Colors.text)
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 0) {
                                ProfileInfoRow(
                                    icon: "phone.fill",
                                    title: "Teléfono",
                                    value: authViewModel.currentUser?.phoneNumber ?? "No especificado"
                                )
                                
                                Divider()
                                    .padding(.leading, 56)
                                
                                ProfileInfoRow(
                                    icon: "envelope.fill",
                                    title: "Email",
                                    value: authViewModel.currentUser?.email ?? ""
                                )
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 16)
                        }
                        
                        // Settings Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Configuración")
                                .font(.headline)
                                .foregroundColor(AppTheme.Colors.text)
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 0) {
                                ProfileMenuItem(
                                    icon: "bell.fill",
                                    title: "Notificaciones",
                                    iconColor: AppTheme.Colors.secondary,
                                    action: {}
                                )
                                
                                Divider()
                                    .padding(.leading, 56)
                                
                                ProfileMenuItem(
                                    icon: "lock.fill",
                                    title: "Privacidad",
                                    iconColor: Color.blue,
                                    action: {}
                                )
                                
                                Divider()
                                    .padding(.leading, 56)
                                
                                ProfileMenuItem(
                                    icon: "questionmark.circle.fill",
                                    title: "Ayuda",
                                    iconColor: Color.purple,
                                    action: {}
                                )
                                
                                Divider()
                                    .padding(.leading, 56)
                                
                                ProfileMenuItem(
                                    icon: "info.circle.fill",
                                    title: "Acerca de",
                                    iconColor: Color.gray,
                                    action: {}
                                )
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 16)
                        }
                        
                        // Logout Button
                        Button(action: { showingLogoutAlert = true }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Cerrar Sesión")
                                    .fontWeight(.semibold)
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        
                        Spacer()
                            .frame(height: 24)
                    }
                }
            }
            .navigationTitle("Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(viewModel: viewModel, currentUser: authViewModel.currentUser)
            }
            .alert("Cerrar Sesión", isPresented: $showingLogoutAlert) {
                Button("Cancelar", role: .cancel) {}
                Button("Cerrar Sesión", role: .destructive) {
                    authViewModel.logout()
                }
            } message: {
                Text("¿Estás seguro de que quieres cerrar sesión?")
            }
            .onAppear {
                viewModel.loadUserProfile(user: authViewModel.currentUser)
            }
        }
    }
}

// MARK: - Profile Info Row
struct ProfileInfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(AppTheme.Colors.primary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.Colors.text)
            }
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Profile Menu Item
struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(iconColor)
                    .frame(width: 24)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.Colors.text)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            .padding()
        }
    }
}

// MARK: - Edit Profile View
struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ProfileViewModel
    let currentUser: User?
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phoneNumber = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                Form {
                    Section(header: Text("Información Personal")) {
                        TextField("Nombre", text: $firstName)
                        TextField("Apellido", text: $lastName)
                        TextField("Teléfono", text: $phoneNumber)
                            .keyboardType(.phonePad)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Editar Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.Colors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        saveProfile()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.Colors.primary)
                    .disabled(firstName.isEmpty || lastName.isEmpty)
                }
            }
            .onAppear {
                firstName = currentUser?.firstName ?? ""
                lastName = currentUser?.lastName ?? ""
                phoneNumber = currentUser?.phoneNumber ?? ""
            }
        }
    }
    
    private func saveProfile() {
        Task {
            await viewModel.updateProfile(
                firstName: firstName,
                lastName: lastName,
                phoneNumber: phoneNumber
            )
            dismiss()
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
