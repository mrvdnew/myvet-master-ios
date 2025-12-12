import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var upcomingAppointments: [Appointment] = []
    @Published var recentPets: [Pet] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let appointmentService = AppointmentService.shared
    private let petService = PetService.shared
    
    func fetchDashboardData(userId: String) async {
        isLoading = true
        errorMessage = nil
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Mock upcoming appointments
        upcomingAppointments = [
            Appointment(
                id: UUID().uuidString,
                petId: UUID().uuidString,
                veterinarianId: UUID().uuidString,
                clinicId: UUID().uuidString,
                dateTime: Date().addingTimeInterval(86400 * 2),
                duration: 30,
                serviceType: "checkup",
                status: .scheduled,
                notes: "Chequeo general",
                reminderSent: false
            ),
            Appointment(
                id: UUID().uuidString,
                petId: UUID().uuidString,
                veterinarianId: UUID().uuidString,
                clinicId: UUID().uuidString,
                dateTime: Date().addingTimeInterval(86400 * 5),
                duration: 45,
                serviceType: "vaccination",
                status: .confirmed,
                notes: "Vacuna antirrábica",
                reminderSent: true
            )
        ]
        
        // Mock recent pets
        recentPets = [
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
            )
        ]
        
        isLoading = false
    }
    
    private func fetchUpcomingAppointments(userId: String) async throws -> [Appointment] {
        let allAppointments = try await appointmentService.fetchAppointments(userId: userId)
        let now = Date()
        return allAppointments
            .filter { $0.dateTime >= now && $0.status != .cancelled && $0.status != .completed }
            .sorted { $0.dateTime < $1.dateTime }
            .prefix(3)
            .map { $0 }
    }
    
    private func fetchRecentPets(userId: String) async throws -> [Pet] {
        let allPets = try await petService.fetchPets(userId: userId)
        return Array(allPets.prefix(4))
    }
}
