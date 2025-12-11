import Foundation

class AppointmentService {
    static let shared = AppointmentService()
    private let apiClient = APIClient.shared
    
    // MARK: - Appointment Operations
    func fetchAppointments(userId: String) async throws -> [Appointment] {
        let endpoint = "/users/\(userId)/appointments"
        let appointments: [Appointment] = try await apiClient.request(endpoint: endpoint)
        return appointments
    }
    
    func fetchAppointment(appointmentId: String) async throws -> Appointment {
        let endpoint = "/appointments/\(appointmentId)"
        let appointment: Appointment = try await apiClient.request(endpoint: endpoint)
        return appointment
    }
    
    func createAppointment(appointmentData: [String: Any]) async throws -> Appointment {
        let endpoint = "/appointments"
        let appointment: Appointment = try await apiClient.request(
            endpoint: endpoint,
            method: .post,
            parameters: appointmentData
        )
        return appointment
    }
    
    func updateAppointment(appointmentId: String, appointmentData: [String: Any]) async throws -> Appointment {
        let endpoint = "/appointments/\(appointmentId)"
        let appointment: Appointment = try await apiClient.request(
            endpoint: endpoint,
            method: .put,
            parameters: appointmentData
        )
        return appointment
    }
    
    func cancelAppointment(appointmentId: String) async throws {
        let endpoint = "/appointments/\(appointmentId)/cancel"
        let _: EmptyResponse = try await apiClient.request(
            endpoint: endpoint,
            method: .post
        )
    }
    
    func fetchAvailableSlots(
        veterinarianId: String,
        date: Date
    ) async throws -> [TimeSlot] {
        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: date)
        let endpoint = "/veterinarians/\(veterinarianId)/available-slots?date=\(dateString)"
        let slots: [TimeSlot] = try await apiClient.request(endpoint: endpoint)
        return slots
    }
}

struct TimeSlot: Codable, Identifiable {
    let id: String
    let startTime: Date
    let endTime: Date
    let isAvailable: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case startTime = "start_time"
        case endTime = "end_time"
        case isAvailable = "is_available"
    }
}