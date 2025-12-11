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
        
        do {
            pets = try await petService.fetchPets(userId: userId)
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
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
        do {
            let newPet = try await petService.createPet(userId: userId, petData: petData)
            pets.append(newPet)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}