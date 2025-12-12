import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showingRegister = false
    @State private var showingForgotPassword = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xl) {
                    // Logo and Title
                    VStack(spacing: AppTheme.Spacing.md) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(AppTheme.Colors.primary)
                        
                        Text("MyVet")
                            .font(AppTheme.Typography.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.Colors.text)
                        
                        Text("Veterinary Care Made Easy")
                            .font(AppTheme.Typography.callout)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    .padding(.top, AppTheme.Spacing.xxl)
                    
                    // Login Form
                    VStack(spacing: AppTheme.Spacing.md) {
                        // Email Field
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                            Label("Email", systemImage: "envelope.fill")
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                            
                            TextField("Enter your email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding()
                                .background(Color.white)
                                .cornered(AppTheme.CornerRadius.md)
                                .shadowSmall()
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                            Label("Password", systemImage: "lock.fill")
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                            
                            SecureField("Enter your password", text: $password)
                                .padding()
                                .background(Color.white)
                                .cornered(AppTheme.CornerRadius.md)
                                .shadowSmall()
                        }
                        
                        // Forgot Password
                        HStack {
                            Spacer()
                            Button(action: { showingForgotPassword = true }) {
                                Text("Forgot Password?")
                                    .font(AppTheme.Typography.caption)
                                    .foregroundColor(AppTheme.Colors.primary)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Login Button
                    Button(action: { login() }) {
                        HStack {
                            if authViewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Image(systemName: "arrow.right.circle.fill")
                                Text("Login")
                            }
                        }
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.Colors.primary)
                        .cornered(AppTheme.CornerRadius.md)
                        .shadowMedium()
                    }
                    .disabled(authViewModel.isLoading || email.isEmpty || password.isEmpty)
                    .padding(.horizontal)
                    
                    // Error Message
                    if let error = authViewModel.errorMessage {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text(error)
                        }
                        .font(AppTheme.Typography.callout)
                        .foregroundColor(AppTheme.Colors.error)
                        .padding()
                        .background(AppTheme.Colors.error.opacity(0.1))
                        .cornered(AppTheme.CornerRadius.md)
                        .padding(.horizontal)
                    }
                    
                    // Divider
                    HStack {
                        Rectangle()
                            .fill(AppTheme.Colors.textSecondary.opacity(0.3))
                            .frame(height: 1)
                        
                        Text("OR")
                            .font(AppTheme.Typography.caption)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                            .padding(.horizontal, AppTheme.Spacing.sm)
                        
                        Rectangle()
                            .fill(AppTheme.Colors.textSecondary.opacity(0.3))
                            .frame(height: 1)
                    }
                    .padding(.horizontal)
                    
                    // Register Button
                    Button(action: { showingRegister = true }) {
                        HStack {
                            Image(systemName: "person.badge.plus")
                            Text("Create New Account")
                        }
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.Colors.primary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornered(AppTheme.CornerRadius.md)
                        .shadowMedium()
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.vertical)
            }
            .background(Color.appBackground)
            .sheet(isPresented: $showingRegister) {
                RegisterView()
            }
            .sheet(isPresented: $showingForgotPassword) {
                ForgotPasswordView()
            }
        }
    }
    
    private func login() {
        Task {
            await authViewModel.login(email: email, password: password)
        }
    }
}

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var isLoading = false
    @State private var showSuccess = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: AppTheme.Spacing.xl) {
                VStack(spacing: AppTheme.Spacing.md) {
                    Image(systemName: "key.fill")
                        .font(.system(size: 60))
                        .foregroundColor(AppTheme.Colors.primary)
                    
                    Text("Forgot Password")
                        .font(AppTheme.Typography.title)
                        .fontWeight(.bold)
                    
                    Text("Enter your email address and we'll send you instructions to reset your password")
                        .font(AppTheme.Typography.callout)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, AppTheme.Spacing.xl)
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Label("Email", systemImage: "envelope.fill")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                    
                    TextField("Enter your email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.white)
                        .cornered(AppTheme.CornerRadius.md)
                        .shadowSmall()
                }
                .padding(.horizontal)
                
                Button(action: { resetPassword() }) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Send Reset Link")
                        }
                    }
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppTheme.Colors.primary)
                    .cornered(AppTheme.CornerRadius.md)
                    .shadowMedium()
                }
                .disabled(isLoading || email.isEmpty)
                .padding(.horizontal)
                
                if showSuccess {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Password reset link sent!")
                    }
                    .font(AppTheme.Typography.callout)
                    .foregroundColor(AppTheme.Colors.success)
                    .padding()
                    .background(AppTheme.Colors.success.opacity(0.1))
                    .cornered(AppTheme.CornerRadius.md)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func resetPassword() {
        isLoading = true
        // TODO: Implement password reset
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            showSuccess = true
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
