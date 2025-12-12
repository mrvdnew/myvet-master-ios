import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let keychain = KeychainManager.shared
    
    init() {
        restoreAuthenticationState()
    }
    
    @MainActor
    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock authentication - accept any email/password for demo
        if !email.isEmpty && !password.isEmpty {
            // Create mock user
            let mockUser = User(
                id: UUID().uuidString,
                firstName: "Juan",
                lastName: "Pérez",
                email: email,
                phoneNumber: "+52 555 123 4567",
                address: Address(
                    street: "Av. Principal 123",
                    city: "Ciudad de México",
                    state: "CDMX",
                    zipCode: "01000",
                    country: "México"
                ),
                profileImageUrl: nil,
                createdAt: Date(),
                updatedAt: Date()
            )
            
            // Store mock token
            try? keychain.store(token: "mock_token_\(UUID().uuidString)", for: email)
            
            isAuthenticated = true
            currentUser = mockUser
        } else {
            errorMessage = "Email y contraseña son requeridos"
        }
        
        isLoading = false
    }
    
    @MainActor
    func logout() {
        isAuthenticated = false
        currentUser = nil
        keychain.deleteAllTokens()
    }
    
    @MainActor
    func register(user: User, password: String) async {
        isLoading = true
        errorMessage = nil
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock registration - accept any valid data for demo
        if !user.email.isEmpty && !password.isEmpty {
            // Store mock token
            try? keychain.store(token: "mock_token_\(UUID().uuidString)", for: user.email)
            
            isAuthenticated = true
            currentUser = user
        } else {
            errorMessage = "Datos de registro inválidos"
        }
        
        isLoading = false
    }
    
    private func restoreAuthenticationState() {
        // TODO: Implement token restoration from keychain
        // and validate with backend
    }
    
    private func loginWithAPI(email: String, password: String) async throws -> (token: String, user: User) {
        // Placeholder for API call
        throw NSError(domain: "Not Implemented", code: -1)
    }
    
    private func registerWithAPI(user: User, password: String) async throws -> (token: String, user: User) {
        // Placeholder for API call
        throw NSError(domain: "Not Implemented", code: -1)
    }
}

class KeychainManager {
    static let shared = KeychainManager()
    private let service = "com.myvet.ios"
    
    func store(token: String, for email: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: email,
            kSecValueData as String: token.data(using: .utf8)!
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func retrieve(for email: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: email,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        
        if let data = result as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func deleteAllTokens() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}