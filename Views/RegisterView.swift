import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var validationError: String?
    
    var body: some View {
        ZStack {
            // Background color
            AppTheme.Colors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "pawprint.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(AppTheme.Colors.primary)
                        
                        Text("Crear Cuenta")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(AppTheme.Colors.text)
                        
                        Text("Completa los datos para registrarte")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    .padding(.top, 20)
                    
                    // Registration Form
                    VStack(spacing: 16) {
                        // First Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nombre")
                                .font(.subheadline)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                            
                            TextField("Juan", text: $firstName)
                                .textContentType(.givenName)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        // Last Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Apellido")
                                .font(.subheadline)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                            
                            TextField("Pérez", text: $lastName)
                                .textContentType(.familyName)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        // Email
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.subheadline)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                            
                            TextField("correo@ejemplo.com", text: $email)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        // Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Contraseña")
                                .font(.subheadline)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                            
                            HStack {
                                if showPassword {
                                    TextField("Contraseña", text: $password)
                                } else {
                                    SecureField("Contraseña", text: $password)
                                }
                                
                                Button(action: { showPassword.toggle() }) {
                                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(AppTheme.Colors.textSecondary)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                        }
                        
                        // Confirm Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirmar Contraseña")
                                .font(.subheadline)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                            
                            HStack {
                                if showConfirmPassword {
                                    TextField("Confirmar contraseña", text: $confirmPassword)
                                } else {
                                    SecureField("Confirmar contraseña", text: $confirmPassword)
                                }
                                
                                Button(action: { showConfirmPassword.toggle() }) {
                                    Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(AppTheme.Colors.textSecondary)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                        }
                        
                        // Validation Error
                        if let error = validationError {
                            HStack {
                                Image(systemName: "exclamationmark.circle.fill")
                                Text(error)
                                    .font(.caption)
                            }
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        // Error Message from ViewModel
                        if let errorMessage = authViewModel.errorMessage {
                            HStack {
                                Image(systemName: "exclamationmark.circle.fill")
                                Text(errorMessage)
                                    .font(.caption)
                            }
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        // Register Button
                        Button(action: handleRegister) {
                            if authViewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                            } else {
                                Text("Registrarse")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                            }
                        }
                        .background(AppTheme.Colors.primary)
                        .cornerRadius(8)
                        .disabled(authViewModel.isLoading || !isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.6)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Atrás")
                    }
                    .foregroundColor(AppTheme.Colors.primary)
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty
    }
    
    private func handleRegister() {
        validationError = nil
        
        // Validate email format
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: email) {
            validationError = "Email inválido"
            return
        }
        
        // Validate password length
        if password.count < 6 {
            validationError = "La contraseña debe tener al menos 6 caracteres"
            return
        }
        
        // Validate passwords match
        if password != confirmPassword {
            validationError = "Las contraseñas no coinciden"
            return
        }
        
        // Create user object
        let user = User(
            id: UUID().uuidString,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phoneNumber: "",
            address: Address(street: "", city: "", state: "", zipCode: "", country: ""),
            profileImageUrl: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        Task {
            await authViewModel.register(user: user, password: password)
        }
    }
}

#Preview {
    NavigationView {
        RegisterView()
            .environmentObject(AuthViewModel())
    }
}
