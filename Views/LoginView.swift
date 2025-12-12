import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var navigateToRegister = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        Spacer()
                            .frame(height: 60)
                        
                        // Logo and Title
                        VStack(spacing: 16) {
                            Image(systemName: "pawprint.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(AppTheme.Colors.primary)
                            
                            Text("MyVet")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(AppTheme.Colors.text)
                        }
                        .padding(.bottom, 40)
                        
                        // Login Form
                        VStack(spacing: 16) {
                            // Email Field
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
                            
                            // Password Field
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
                            
                            // Error Message
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
                            
                            // Login Button
                            Button(action: {
                                Task {
                                    await authViewModel.login(email: email, password: password)
                                }
                            }) {
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                } else {
                                    Text("Iniciar sesión")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                }
                            }
                            .background(AppTheme.Colors.primary)
                            .cornerRadius(8)
                            .disabled(authViewModel.isLoading || email.isEmpty || password.isEmpty)
                            .opacity((email.isEmpty || password.isEmpty) ? 0.6 : 1.0)
                            
                            // Register Link
                            HStack {
                                Text("¿No tienes cuenta?")
                                    .foregroundColor(AppTheme.Colors.textSecondary)
                                
                                NavigationLink(destination: RegisterView(), isActive: $navigateToRegister) {
                                    Button(action: { navigateToRegister = true }) {
                                        Text("Regístrate")
                                            .fontWeight(.semibold)
                                            .foregroundColor(AppTheme.Colors.primary)
                                    }
                                }
                            }
                            .font(.subheadline)
                            .padding(.top, 8)
                        }
                        .padding(.horizontal, 24)
                        
                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
