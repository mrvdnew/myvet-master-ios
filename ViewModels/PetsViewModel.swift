import Foundation

@MainActor
class PetsViewModel: ObservableObject {
    @Published var pets: [Pet] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let petService = PetService.shared
    private var userId: String = ""
    
    init(userId: String = "") {
        self.userId = userId
    }
    
    func setUserId(_ userId: String) {
        self.userId = userId
    }
    
    @MainActor
    func fetchPets() async {
        isLoading = true
        errorMessage = nil
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Mock pets for demo
        pets = [
            Pet(
                id: UUID().uuidString,
                name: "Max",
                type: "dog",
                breed: "Golden Retriever",
                age: 3,
                weight: 28.5,
                dateOfBirth: Date().addingTimeInterval(-86400 * 365 * 3),
                microchipId: "123456789",
                medicalHistory: []
            ),
            Pet(
                id: UUID().uuidString,
                name: "Luna",
                type: "cat",
                breed: "Siamés",
                age: 2,
                weight: 4.2,
                dateOfBirth: Date().addingTimeInterval(-86400 * 365 * 2),
                microchipId: "987654321",
                medicalHistory: []
            ),
            Pet(
                id: UUID().uuidString,
                name: "Rocky",
                type: "dog",
                breed: "Labrador",
                age: 5,
                weight: 32.0,
                dateOfBirth: Date().addingTimeInterval(-86400 * 365 * 5),
                microchipId: nil,
                medicalHistory: []
            )
        ]
        
        isLoading = false
    }
    
    @MainActor
    func deletePet(_ petId: String) async {
        do {
            try await petService.deletePet(petId: petId)
            pets.removeAll { $0.id == petId }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func createPet(_ petData: [String: Any]) async {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Create mock pet
        let newPet = Pet(
            id: UUID().uuidString,
            name: petData["name"] as? String ?? "New Pet",
            type: petData["type"] as? String ?? "dog",
            breed: petData["breed"] as? String ?? "Mixed",
            age: petData["age"] as? Int ?? 0,
            weight: petData["weight"] as? Double ?? 0.0,
            dateOfBirth: Date(),
            microchipId: nil,
            medicalHistory: []
        )
        
        pets.append(newPet)
    }
}