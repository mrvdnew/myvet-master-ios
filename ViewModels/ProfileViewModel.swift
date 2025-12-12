import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadUserProfile(user: User?) {
        self.user = user
    }
    
    func updateProfile(firstName: String, lastName: String, phoneNumber: String) async {
        isLoading = true
        errorMessage = nil
        
        // TODO: Implement actual profile update API call
        // For now, update locally
        if var currentUser = user {
            let updatedUser = User(
                id: currentUser.id,
                firstName: firstName,
                lastName: lastName,
                email: currentUser.email,
                phoneNumber: phoneNumber,
                address: currentUser.address,
                profileImageUrl: currentUser.profileImageUrl,
                createdAt: currentUser.createdAt,
                updatedAt: Date()
            )
            user = updatedUser
        }
        
        isLoading = false
    }
}
