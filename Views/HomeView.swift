import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var appointmentsViewModel: AppointmentsViewModel
    @StateObject private var petsViewModel: PetsViewModel
    
    init(userId: String) {
        _appointmentsViewModel = StateObject(wrappedValue: AppointmentsViewModel(userId: userId))
        _petsViewModel = StateObject(wrappedValue: PetsViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    // Welcome Header
                    WelcomeHeader(user: authViewModel.currentUser)
                    
                    // Quick Actions
                    QuickActionsSection()
                    
                    // Upcoming Appointments
                    UpcomingAppointmentsSection(appointments: upcomingAppointments)
                    
                    // My Pets Summary
                    PetsSummarySection(pets: petsViewModel.pets)
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle("MyVet")
            .onAppear {
                Task {
                    await appointmentsViewModel.fetchAppointments()
                    await petsViewModel.fetchPets()
                }
            }
        }
    }
    
    private var upcomingAppointments: [Appointment] {
        appointmentsViewModel.appointments
            .filter { $0.dateTime >= Date() && $0.status != .cancelled }
            .sorted { $0.dateTime < $1.dateTime }
            .prefix(3)
            .map { $0 }
    }
}

struct WelcomeHeader: View {
    let user: User?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text("Welcome back,")
                    .font(AppTheme.Typography.callout)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                
                Text(user?.firstName ?? "User")
                    .font(AppTheme.Typography.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.Colors.text)
            }
            
            Spacer()
            
            Image(systemName: "person.circle.fill")
                .font(.system(size: 48))
                .foregroundColor(AppTheme.Colors.primary)
        }
        .padding()
        .background(Color.white)
        .cornered(AppTheme.CornerRadius.lg)
        .shadowMedium()
    }
}

struct QuickActionsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Quick Actions")
                .font(AppTheme.Typography.title3)
                .fontWeight(.semibold)
            
            HStack(spacing: AppTheme.Spacing.md) {
                QuickActionCard(
                    icon: "calendar.badge.plus",
                    title: "Book Appointment",
                    color: AppTheme.Colors.primary
                )
                
                QuickActionCard(
                    icon: "pawprint.circle.fill",
                    title: "Add Pet",
                    color: AppTheme.Colors.secondary
                )
            }
            
            HStack(spacing: AppTheme.Spacing.md) {
                QuickActionCard(
                    icon: "heart.text.square",
                    title: "Medical Records",
                    color: AppTheme.Colors.accent
                )
                
                QuickActionCard(
                    icon: "bell.fill",
                    title: "Reminders",
                    color: AppTheme.Colors.warning
                )
            }
        }
    }
}

struct QuickActionCard: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
            
            Text(title)
                .font(AppTheme.Typography.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(AppTheme.Colors.text)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornered(AppTheme.CornerRadius.lg)
        .shadowSmall()
    }
}

struct UpcomingAppointmentsSection: View {
    let appointments: [Appointment]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                Text("Upcoming Appointments")
                    .font(AppTheme.Typography.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                NavigationLink(destination: Text("All Appointments")) {
                    Text("See All")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.primary)
                }
            }
            
            if appointments.isEmpty {
                EmptyStateCard(
                    icon: "calendar",
                    message: "No upcoming appointments"
                )
            } else {
                ForEach(appointments) { appointment in
                    AppointmentCard(appointment: appointment)
                }
            }
        }
    }
}

struct AppointmentCard: View {
    let appointment: Appointment
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(appointment.serviceType.capitalized)
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.text)
                
                Text(formatDate(appointment.dateTime))
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: AppTheme.Spacing.xs) {
                Text(formatTime(appointment.dateTime))
                    .font(AppTheme.Typography.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.Colors.primary)
                
                StatusBadgeSmall(status: appointment.status)
            }
        }
        .padding()
        .background(Color.white)
        .cornered(AppTheme.CornerRadius.md)
        .shadowSmall()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct StatusBadgeSmall: View {
    let status: AppointmentStatus
    
    var body: some View {
        Text(status.rawValue.capitalized)
            .font(AppTheme.Typography.caption2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(statusColor)
            .cornered(AppTheme.CornerRadius.sm)
    }
    
    private var statusColor: Color {
        switch status {
        case .scheduled:
            return AppTheme.Colors.info
        case .confirmed:
            return AppTheme.Colors.success
        case .completed:
            return AppTheme.Colors.secondary
        case .cancelled:
            return AppTheme.Colors.error
        case .noShow:
            return AppTheme.Colors.warning
        }
    }
}

struct PetsSummarySection: View {
    let pets: [Pet]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                Text("My Pets")
                    .font(AppTheme.Typography.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                NavigationLink(destination: Text("All Pets")) {
                    Text("See All")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.primary)
                }
            }
            
            if pets.isEmpty {
                EmptyStateCard(
                    icon: "pawprint",
                    message: "No pets added yet"
                )
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppTheme.Spacing.md) {
                        ForEach(pets.prefix(5)) { pet in
                            PetCard(pet: pet)
                        }
                    }
                }
            }
        }
    }
}

struct PetCard: View {
    let pet: Pet
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: "pawprint.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(AppTheme.Colors.primary)
            
            Text(pet.name)
                .font(AppTheme.Typography.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(AppTheme.Colors.text)
            
            Text(pet.type.capitalized)
                .font(AppTheme.Typography.caption2)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .frame(width: 100)
        .padding()
        .background(Color.white)
        .cornered(AppTheme.CornerRadius.lg)
        .shadowSmall()
    }
}

struct EmptyStateCard: View {
    let icon: String
    let message: String
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(AppTheme.Colors.textSecondary)
            
            Text(message)
                .font(AppTheme.Typography.callout)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(AppTheme.Spacing.xl)
        .background(Color.white)
        .cornered(AppTheme.CornerRadius.lg)
        .shadowSmall()
    }
}

#Preview {
    HomeView(userId: "user123")
        .environmentObject(AuthViewModel())
}
