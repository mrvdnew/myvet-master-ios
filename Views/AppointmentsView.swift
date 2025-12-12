import SwiftUI

struct AppointmentsView: View {
    @StateObject private var viewModel: AppointmentsViewModel
    @State private var showingBookingSheet = false
    
    init(userId: String) {
        _viewModel = StateObject(wrappedValue: AppointmentsViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if viewModel.appointments.isEmpty {
                    EmptyAppointmentsView(showingBookingSheet: $showingBookingSheet)
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppTheme.Spacing.md) {
                            ForEach(groupedAppointments(), id: \.self) { date in
                                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                                    Text(formatDate(date))
                                        .font(AppTheme.Typography.headline)
                                        .foregroundColor(AppTheme.Colors.text)
                                        .padding(.horizontal)
                                    
                                    ForEach(appointmentsFor(date: date)) { appointment in
                                        AppointmentRowCard(
                                            appointment: appointment,
                                            onDelete: {
                                                Task {
                                                    await viewModel.cancelAppointment(appointment.id)
                                                }
                                            }
                                        )
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .background(Color.appBackground)
                }
                
                if let error = viewModel.errorMessage {
                    VStack {
                        ErrorBanner(message: error)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Appointments")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingBookingSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AppTheme.Colors.primary)
                    }
                }
            }
            .sheet(isPresented: $showingBookingSheet) {
                BookAppointmentView(viewModel: viewModel)
            }
            .onAppear {
                Task {
                    await viewModel.fetchAppointments()
                }
            }
        }
    }
    
    private func groupedAppointments() -> [Date] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: viewModel.appointments) { appointment in
            calendar.startOfDay(for: appointment.dateTime)
        }
        return grouped.keys.sorted()
    }
    
    private func appointmentsFor(date: Date) -> [Appointment] {
        let calendar = Calendar.current
        return viewModel.appointments.filter { appointment in
            calendar.isDate(appointment.dateTime, inSameDayAs: date)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

struct EmptyAppointmentsView: View {
    @Binding var showingBookingSheet: Bool
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 80))
                .foregroundColor(AppTheme.Colors.primary)
            
            VStack(spacing: AppTheme.Spacing.xs) {
                Text("No Appointments")
                    .font(AppTheme.Typography.title2)
                    .fontWeight(.bold)
                
                Text("Book an appointment with a veterinarian")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingBookingSheet = true }) {
                HStack {
                    Image(systemName: "calendar.badge.plus")
                    Text("Book Appointment")
                }
                .font(AppTheme.Typography.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppTheme.Colors.primary)
                .cornered(AppTheme.CornerRadius.md)
            }
            .padding(.top, AppTheme.Spacing.md)
        }
        .padding(AppTheme.Spacing.xl)
    }
}

struct AppointmentRowCard: View {
    let appointment: Appointment
    let onDelete: () -> Void
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            // Time indicator
            VStack(spacing: AppTheme.Spacing.xs) {
                Text(formatTime(appointment.dateTime))
                    .font(AppTheme.Typography.headline)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.Colors.primary)
                
                Text("\(appointment.duration) min")
                    .font(AppTheme.Typography.caption2)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            .frame(width: 70)
            
            // Divider
            Rectangle()
                .fill(AppTheme.Colors.primary)
                .frame(width: 2)
            
            // Appointment details
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(appointment.serviceType.capitalized)
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.text)
                
                if let notes = appointment.notes, !notes.isEmpty {
                    Text(notes)
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .lineLimit(2)
                }
                
                StatusBadge(status: appointment.status)
            }
            
            Spacer()
            
            // Actions
            Button(action: { showDeleteConfirmation = true }) {
                Image(systemName: "trash")
                    .foregroundColor(AppTheme.Colors.error)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color.white)
        .cornered(AppTheme.CornerRadius.lg)
        .shadowMedium()
        .padding(.horizontal)
        .confirmationDialog("Cancel Appointment", isPresented: $showDeleteConfirmation) {
            Button("Cancel Appointment", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to cancel this appointment?")
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct StatusBadge: View {
    let status: AppointmentStatus
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            
            Text(status.rawValue.capitalized)
                .font(AppTheme.Typography.caption)
                .fontWeight(.semibold)
                .foregroundColor(statusColor)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(statusColor.opacity(0.1))
        .cornered(AppTheme.CornerRadius.sm)
    }
    
    private var statusColor: Color {
        switch status {
        case .scheduled:
            return AppTheme.Colors.info
        case .confirmed:
            return AppTheme.Colors.success
        case .completed:
            return AppTheme.Colors.textSecondary
        case .cancelled:
            return AppTheme.Colors.error
        case .noShow:
            return AppTheme.Colors.warning
        }
    }
}

struct ErrorBanner: View {
    let message: String
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(AppTheme.Colors.error)
            Text(message)
                .font(AppTheme.Typography.callout)
                .foregroundColor(AppTheme.Colors.error)
        }
        .padding()
        .background(AppTheme.Colors.error.opacity(0.1))
        .cornered(AppTheme.CornerRadius.md)
        .padding()
    }
}

#Preview {
    AppointmentsView(userId: "user123")
}
