import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with greeting
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Hola, \(authViewModel.currentUser?.firstName ?? "Usuario")")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(AppTheme.Colors.text)
                            
                            Text("Bienvenido a MyVet")
                                .font(.subheadline)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        
                        // Quick Actions
                        HStack(spacing: 16) {
                            QuickActionButton(
                                icon: "calendar",
                                title: "Mis Citas",
                                color: AppTheme.Colors.primary,
                                action: {}
                            )
                            
                            QuickActionButton(
                                icon: "pawprint.fill",
                                title: "Mis Mascotas",
                                color: AppTheme.Colors.secondary,
                                action: {}
                            )
                        }
                        .padding(.horizontal, 24)
                        
                        // Upcoming Appointments Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Próximas Citas")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.Colors.text)
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Text("Ver todas")
                                        .font(.subheadline)
                                        .foregroundColor(AppTheme.Colors.primary)
                                }
                            }
                            .padding(.horizontal, 24)
                            
                            if viewModel.upcomingAppointments.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "calendar.badge.plus")
                                        .font(.system(size: 40))
                                        .foregroundColor(AppTheme.Colors.textSecondary)
                                    
                                    Text("No hay citas programadas")
                                        .font(.subheadline)
                                        .foregroundColor(AppTheme.Colors.textSecondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                                .background(Color.white)
                                .cornerRadius(12)
                                .padding(.horizontal, 24)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(viewModel.upcomingAppointments) { appointment in
                                            AppointmentCard(appointment: appointment)
                                        }
                                    }
                                    .padding(.horizontal, 24)
                                }
                            }
                        }
                        
                        // Registered Pets Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Mascotas Registradas")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.Colors.text)
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Text("Ver todas")
                                        .font(.subheadline)
                                        .foregroundColor(AppTheme.Colors.primary)
                                }
                            }
                            .padding(.horizontal, 24)
                            
                            if viewModel.recentPets.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "pawprint.circle")
                                        .font(.system(size: 40))
                                        .foregroundColor(AppTheme.Colors.textSecondary)
                                    
                                    Text("No hay mascotas registradas")
                                        .font(.subheadline)
                                        .foregroundColor(AppTheme.Colors.textSecondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                                .background(Color.white)
                                .cornerRadius(12)
                                .padding(.horizontal, 24)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(viewModel.recentPets) { pet in
                                            PetCard(pet: pet)
                                        }
                                    }
                                    .padding(.horizontal, 24)
                                }
                            }
                        }
                        
                        Spacer()
                            .frame(height: 24)
                    }
                }
                
                if viewModel.isLoading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.primary))
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                if let userId = authViewModel.currentUser?.id {
                    Task {
                        await viewModel.fetchDashboardData(userId: userId)
                    }
                }
            }
        }
    }
}

// MARK: - Quick Action Button
struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.Colors.text)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Appointment Card
struct AppointmentCard: View {
    let appointment: Appointment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(AppTheme.Colors.primary)
                
                Text(formatDate(appointment.dateTime))
                    .font(.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            
            Text(appointment.serviceType.capitalized)
                .font(.headline)
                .foregroundColor(AppTheme.Colors.text)
            
            HStack {
                Image(systemName: "clock")
                    .font(.caption)
                Text(formatTime(appointment.dateTime))
                    .font(.caption)
                
                Spacer()
                
                Text("\(appointment.duration) min")
                    .font(.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            .foregroundColor(AppTheme.Colors.textSecondary)
            
            HStack {
                Spacer()
                StatusBadge(status: appointment.status)
            }
        }
        .padding()
        .frame(width: 250)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d, yyyy"
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Pet Card
struct PetCard: View {
    let pet: Pet
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "pawprint.fill")
                    .foregroundColor(AppTheme.Colors.secondary)
                    .font(.title2)
                
                Spacer()
                
                Text("\(pet.age) años")
                    .font(.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            
            Text(pet.name)
                .font(.headline)
                .foregroundColor(AppTheme.Colors.text)
            
            Text("\(pet.type.capitalized) • \(pet.breed)")
                .font(.caption)
                .foregroundColor(AppTheme.Colors.textSecondary)
            
            Text("\(String(format: "%.1f", pet.weight)) kg")
                .font(.caption)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .padding()
        .frame(width: 160)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}
