import Foundation

@MainActor
class AppointmentsViewModel: ObservableObject {
    @Published var appointments: [Appointment] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var availableSlots: [TimeSlot] = []
    
    private let appointmentService = AppointmentService.shared
    private var userId: String = ""
    
    init(userId: String = "") {
        self.userId = userId
    }
    
    func setUserId(_ userId: String) {
        self.userId = userId
    }
    
    @MainActor
    func fetchAppointments() async {
        isLoading = true
        errorMessage = nil
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Mock appointments for demo
        appointments = [
            Appointment(
                id: UUID().uuidString,
                petId: UUID().uuidString,
                veterinarianId: UUID().uuidString,
                clinicId: UUID().uuidString,
                dateTime: Date().addingTimeInterval(86400 * 2), // 2 days from now
                duration: 30,
                serviceType: "checkup",
                status: .scheduled,
                notes: "Chequeo general de rutina",
                reminderSent: false
            ),
            Appointment(
                id: UUID().uuidString,
                petId: UUID().uuidString,
                veterinarianId: UUID().uuidString,
                clinicId: UUID().uuidString,
                dateTime: Date().addingTimeInterval(86400 * 5), // 5 days from now
                duration: 45,
                serviceType: "vaccination",
                status: .confirmed,
                notes: "Vacuna antirrábica",
                reminderSent: true
            ),
            Appointment(
                id: UUID().uuidString,
                petId: UUID().uuidString,
                veterinarianId: UUID().uuidString,
                clinicId: UUID().uuidString,
                dateTime: Date().addingTimeInterval(-86400 * 3), // 3 days ago
                duration: 60,
                serviceType: "dental",
                status: .completed,
                notes: "Limpieza dental completa",
                reminderSent: true
            )
        ]
        
        isLoading = false
    }
    
    @MainActor
    func fetchAvailableSlots(veterinarianId: String, for date: Date) async {
        do {
            availableSlots = try await appointmentService.fetchAvailableSlots(
                veterinarianId: veterinarianId,
                date: date
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func bookAppointment(_ appointmentData: [String: Any]) async {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Create mock appointment
        let newAppointment = Appointment(
            id: UUID().uuidString,
            petId: UUID().uuidString,
            veterinarianId: UUID().uuidString,
            clinicId: UUID().uuidString,
            dateTime: Date().addingTimeInterval(86400 * 7), // 7 days from now
            duration: appointmentData["duration"] as? Int ?? 30,
            serviceType: appointmentData["service_type"] as? String ?? "checkup",
            status: .scheduled,
            notes: appointmentData["notes"] as? String,
            reminderSent: false
        )
        
        appointments.append(newAppointment)
    }
    
    @MainActor
    func cancelAppointment(_ appointmentId: String) async {
        do {
            try await appointmentService.cancelAppointment(appointmentId: appointmentId)
            appointments.removeAll { $0.id == appointmentId }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}