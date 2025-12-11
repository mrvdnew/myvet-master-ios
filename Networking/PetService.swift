import Foundation

class PetService {
    static let shared = PetService()
    private let apiClient = APIClient.shared
    
    // MARK: - Pet Operations
    func fetchPets(userId: String) async throws -> [Pet] {
        let endpoint = "/users/\(userId)/pets"
        let pets: [Pet] = try await apiClient.request(endpoint: endpoint)
        return pets
    }
    
    func fetchPet(petId: String) async throws -> Pet {
        let endpoint = "/pets/\(petId)"
        let pet: Pet = try await apiClient.request(endpoint: endpoint)
        return pet
    }
    
    func createPet(userId: String, petData: [String: Any]) async throws -> Pet {
        let endpoint = "/users/\(userId)/pets"
        let pet: Pet = try await apiClient.request(
            endpoint: endpoint,
            method: .post,
            parameters: petData
        )
        return pet
    }
    
    func updatePet(petId: String, petData: [String: Any]) async throws -> Pet {
        let endpoint = "/pets/\(petId)"
        let pet: Pet = try await apiClient.request(
            endpoint: endpoint,
            method: .put,
            parameters: petData
        )
        return pet
    }
    
    func deletePet(petId: String) async throws {
        let endpoint = "/pets/\(petId)"
        let _: EmptyResponse = try await apiClient.request(
            endpoint: endpoint,
            method: .delete
        )
    }
    
    // MARK: - Medical Records
    func fetchMedicalRecords(petId: String) async throws -> [MedicalRecord] {
        let endpoint = "/pets/\(petId)/medical-records"
        let records: [MedicalRecord] = try await apiClient.request(endpoint: endpoint)
        return records
    }
    
    func addMedicalRecord(petId: String, recordData: [String: Any]) async throws -> MedicalRecord {
        let endpoint = "/pets/\(petId)/medical-records"
        let record: MedicalRecord = try await apiClient.request(
            endpoint: endpoint,
            method: .post,
            parameters: recordData
        )
        return record
    }
}

struct EmptyResponse: Decodable {}