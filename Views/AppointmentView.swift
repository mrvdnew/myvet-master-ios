import SwiftUI

struct AppointmentView: View {
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
                    VStack(spacing: 16) {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 64))
                            .foregroundColor(.gray)
                        
                        Text("No Appointments")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Book an appointment with a veterinarian")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button(action: { showingBookingSheet = true }) {
                            Text("Book Appointment")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .padding(.top, 16)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(groupedAppointments(), id: \.self) { date in
                            Section(header: Text(formatDate(date))) {
                                ForEach(appointmentsFor(date: date)) { appointment in
                                    AppointmentRow(appointment: appointment)
                                }
                                .onDelete { offsets in
                                    deleteAppointments(offsets, for: date)
                                }
                            }
                        }
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
            .navigationTitle("Appointments")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingBookingSheet = true }) {
                        Image(systemName: "plus")
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
    
    private func deleteAppointments(_ offsets: IndexSet, for date: Date) {
        let appointmentsForDate = appointmentsFor(date: date)
        offsets.forEach { index in
            let appointment = appointmentsForDate[index]
            Task {
                await viewModel.cancelAppointment(appointment.id)
            }
        }
    }
}

struct AppointmentRow: View {
    let appointment: Appointment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(formatTime(appointment.dateTime)) - \(formatEndTime(appointment.dateTime, duration: appointment.duration))")
                    .fontWeight(.semibold)
                
                Spacer()
                
                StatusBadge(status: appointment.status)
            }
            
            Text(appointment.serviceType.capitalized)
                .font(.caption)
                .foregroundColor(.secondary)
            
            if let notes = appointment.notes {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
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

struct StatusBadge: View {
    let status: AppointmentStatus
    
    var body: some View {
        Text(status.rawValue.capitalized)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor)
            .cornerRadius(4)
    }
    
    private var statusColor: Color {
        switch status {
        case .scheduled:
            return .blue
        case .confirmed:
            return .green
        case .completed:
            return .gray
        case .cancelled:
            return .red
        case .noShow:
            return .orange
        }
    }
}

struct BookAppointmentView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AppointmentsViewModel
    
    @State private var selectedDate = Date()
    @State private var selectedVeterinarian = ""
    @State private var selectedServiceType = "checkup"
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appointment Details")) {
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    
                    Picker("Service Type", selection: $selectedServiceType) {
                        Text("Check-up").tag("checkup")
                        Text("Vaccination").tag("vaccination")
                        Text("Dental Cleaning").tag("dental")
                        Text("Surgery").tag("surgery")
                        Text("Consultation").tag("consultation")
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Book Appointment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Book") {
                        bookAppointment()
                    }
                }
            }
        }
    }
    
    private func bookAppointment() {
        let appointmentData: [String: Any] = [
            "date_time": selectedDate,
            "service_type": selectedServiceType,
            "notes": notes
        ]
        
        Task {
            await viewModel.bookAppointment(appointmentData)
            dismiss()
        }
    }
}

#Preview {
    AppointmentView(userId: "user123")
}