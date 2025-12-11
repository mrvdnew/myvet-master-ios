import Foundation
import Security

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
        
        do {
            // TODO: Implement actual login API call
            // For now, this is a placeholder
            let response = try await loginWithAPI(email: email, password: password)
            
            // Store token in keychain
            try keychain.store(token: response.token, for: email)
            
            isAuthenticated = true
            currentUser = response.user
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
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
        
        do {
            // TODO: Implement actual registration API call
            let response = try await registerWithAPI(user: user, password: password)
            
            try keychain.store(token: response.token, for: user.email)
            
            isAuthenticated = true
            currentUser = response.user
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
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