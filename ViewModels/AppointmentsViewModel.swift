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
        
        do {
            appointments = try await appointmentService.fetchAppointments(userId: userId)
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
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
        do {
            let newAppointment = try await appointmentService.createAppointment(appointmentData: appointmentData)
            appointments.append(newAppointment)
        } catch {
            errorMessage = error.localizedDescription
        }
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