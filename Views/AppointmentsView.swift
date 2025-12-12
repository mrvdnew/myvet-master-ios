import SwiftUI

struct AppointmentsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = AppointmentsViewModel()
    @State private var showingBookingSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.primary))
                } else if viewModel.appointments.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 64))
                            .foregroundColor(AppTheme.Colors.textSecondary)
                        
                        Text("No hay citas")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(AppTheme.Colors.text)
                        
                        Text("Agenda una cita con un veterinario")
                            .foregroundColor(AppTheme.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        Button(action: { showingBookingSheet = true }) {
                            Text("Agendar Cita")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppTheme.Colors.primary)
                                .cornerRadius(8)
                        }
                        .padding(.top, 16)
                        .padding(.horizontal, 40)
                    }
                    .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.appointments) { appointment in
                                AppointmentItemCard(appointment: appointment)
                                    .padding(.horizontal, 16)
                            }
                        }
                        .padding(.vertical, 16)
                    }
                }
                
                if let error = viewModel.errorMessage {
                    VStack {
                        HStack {
                            Image(systemName: "exclamationmark.circle")
                                .foregroundColor(.red)
                            Text(error)
                                .foregroundColor(.red)
                        }
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                        .padding()
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle("Citas")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingBookingSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(AppTheme.Colors.primary)
                    }
                }
            }
            .sheet(isPresented: $showingBookingSheet) {
                CreateAppointmentView(viewModel: viewModel)
            }
            .onAppear {
                if let userId = authViewModel.currentUser?.id {
                    viewModel.setUserId(userId)
                    Task {
                        await viewModel.fetchAppointments()
                    }
                }
            }
        }
    }
}

// MARK: - Appointment Item Card
struct AppointmentItemCard: View {
    let appointment: Appointment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.serviceType.capitalized)
                        .font(.headline)
                        .foregroundColor(AppTheme.Colors.text)
                    
                    HStack {
                        Image(systemName: "calendar")
                            .font(.caption)
                        Text(formatDate(appointment.dateTime))
                            .font(.caption)
                    }
                    .foregroundColor(AppTheme.Colors.textSecondary)
                }
                
                Spacer()
                
                AppointmentStatusBadge(status: appointment.status)
            }
            
            HStack {
                Image(systemName: "clock")
                    .font(.caption)
                Text("\(formatTime(appointment.dateTime)) - \(formatEndTime(appointment.dateTime, duration: appointment.duration))")
                    .font(.caption)
                
                Spacer()
                
                Text("\(appointment.duration) min")
                    .font(.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            .foregroundColor(AppTheme.Colors.textSecondary)
            
            if let notes = appointment.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .lineLimit(2)
            }
        }
        .padding()
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
    
    private func formatEndTime(_ date: Date, duration: Int) -> String {
        let endDate = Calendar.current.date(byAdding: .minute, value: duration, to: date) ?? date
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: endDate)
    }
}

// MARK: - Appointment Status Badge
struct AppointmentStatusBadge: View {
    let status: AppointmentStatus
    
    var body: some View {
        Text(statusText)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(statusColor)
            .cornerRadius(12)
    }
    
    private var statusText: String {
        switch status {
        case .scheduled:
            return "Programada"
        case .confirmed:
            return "Confirmada"
        case .completed:
            return "Completada"
        case .cancelled:
            return "Cancelada"
        case .noShow:
            return "No asistió"
        }
    }
    
    private var statusColor: Color {
        switch status {
        case .scheduled:
            return AppTheme.Colors.scheduled // Green
        case .confirmed:
            return AppTheme.Colors.confirmed // Cyan
        case .completed:
            return AppTheme.Colors.completed // Gray
        case .cancelled:
            return AppTheme.Colors.cancelled // Red
        case .noShow:
            return AppTheme.Colors.secondary // Orange
        }
    }
}

// MARK: - Create Appointment View
struct CreateAppointmentView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AppointmentsViewModel
    
    @State private var selectedDate = Date()
    @State private var selectedServiceType = "checkup"
    @State private var duration = 30
    @State private var notes = ""
    
    let serviceTypes = [
        ("checkup", "Chequeo"),
        ("vaccination", "Vacunación"),
        ("dental", "Limpieza Dental"),
        ("surgery", "Cirugía"),
        ("consultation", "Consulta")
    ]
    
    let durations = [15, 30, 45, 60, 90, 120]
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                Form {
                    Section(header: Text("Detalles de la Cita")) {
                        DatePicker("Fecha y Hora", selection: $selectedDate, in: Date()...)
                        
                        Picker("Tipo de Servicio", selection: $selectedServiceType) {
                            ForEach(serviceTypes, id: \.0) { type in
                                Text(type.1).tag(type.0)
                            }
                        }
                        
                        Picker("Duración", selection: $duration) {
                            ForEach(durations, id: \.self) { dur in
                                Text("\(dur) minutos").tag(dur)
                            }
                        }
                    }
                    
                    Section(header: Text("Notas (Opcional)")) {
                        TextEditor(text: $notes)
                            .frame(height: 100)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Nueva Cita")
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
                        createAppointment()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.Colors.primary)
                }
            }
        }
    }
    
    private func createAppointment() {
        let formatter = ISO8601DateFormatter()
        let appointmentData: [String: Any] = [
            "date_time": formatter.string(from: selectedDate),
            "service_type": selectedServiceType,
            "duration": duration,
            "notes": notes
        ]
        
        Task {
            await viewModel.bookAppointment(appointmentData)
            dismiss()
        }
    }
}

#Preview {
    AppointmentsView()
        .environmentObject(AuthViewModel())
}
