import Foundation

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
