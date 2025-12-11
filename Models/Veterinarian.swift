import Foundation

struct Veterinarian: Codable, Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let licenseNumber: String
    let specializations: [String]
    let clinicId: String
    let email: String
    let phoneNumber: String
    let profileImageUrl: String?
    let bio: String?
    let yearsOfExperience: Int
    let rating: Double
    let reviewCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case licenseNumber = "license_number"
        case specializations
        case clinicId = "clinic_id"
        case email
        case phoneNumber = "phone_number"
        case profileImageUrl = "profile_image_url"
        case bio
        case yearsOfExperience = "years_of_experience"
        case rating
        case reviewCount = "review_count"
    }
}