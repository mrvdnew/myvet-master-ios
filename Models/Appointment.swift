import Foundation

struct Appointment: Codable, Identifiable {
    let id: String
    let petId: String
    let veterinarianId: String
    let clinicId: String
    let dateTime: Date
    let duration: Int // in minutes
    let serviceType: String // "checkup", "vaccination", "surgery", etc.
    let status: AppointmentStatus
    let notes: String?
    let reminderSent: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case petId = "pet_id"
        case veterinarianId = "veterinarian_id"
        case clinicId = "clinic_id"
        case dateTime = "date_time"
        case duration
        case serviceType = "service_type"
        case status
        case notes
        case reminderSent = "reminder_sent"
    }
}

enum AppointmentStatus: String, Codable {
    case scheduled = "scheduled"
    case confirmed = "confirmed"
    case completed = "completed"
    case cancelled = "cancelled"
    case noShow = "no_show"
}