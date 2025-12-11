import Foundation

struct Pet: Codable, Identifiable {
    let id: String
    let name: String
    let type: String // "dog", "cat", "rabbit", etc.
    let breed: String
    let age: Int
    let weight: Double // in kg
    let dateOfBirth: Date
    let microchipId: String?
    let medicalHistory: [MedicalRecord]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case breed
        case age
        case weight
        case dateOfBirth = "date_of_birth"
        case microchipId = "microchip_id"
        case medicalHistory = "medical_history"
    }
}

struct MedicalRecord: Codable, Identifiable {
    let id: String
    let petId: String
    let date: Date
    let diagnosis: String
    let treatment: String
    let veterinarian: String
    let notes: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case petId = "pet_id"
        case date
        case diagnosis
        case treatment
        case veterinarian
        case notes
    }
}