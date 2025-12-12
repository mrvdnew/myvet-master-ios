import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var street = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""
    @State private var country = ""
    @State private var acceptTerms = false
    
    @State private var currentStep = 1
    private let totalSteps = 3
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress Indicator
                ProgressIndicator(currentStep: currentStep, totalSteps: totalSteps)
                    .padding()
                
                // Form Content
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.lg) {
                        if currentStep == 1 {
                            PersonalInfoStep(
                                firstName: $firstName,
                                lastName: $lastName,
                                email: $email,
                                phoneNumber: $phoneNumber
                            )
                        } else if currentStep == 2 {
                            AddressStep(
                                street: $street,
                                city: $city,
                                state: $state,
                                zipCode: $zipCode,
                                country: $country
                            )
                        } else {
                            SecurityStep(
                                password: $password,
                                confirmPassword: $confirmPassword,
                                acceptTerms: $acceptTerms
                            )
                        }
                    }
                    .padding()
                }
                .background(Color.appBackground)
                
                // Navigation Buttons
                HStack(spacing: AppTheme.Spacing.md) {
                    if currentStep > 1 {
                        Button(action: { currentStep -= 1 }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .font(AppTheme.Typography.headline)
                            .foregroundColor(AppTheme.Colors.primary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornered(AppTheme.CornerRadius.md)
                            .shadowSmall()
                        }
                    }
                    
                    Button(action: { handleNext() }) {
                        HStack {
                            if authViewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text(currentStep == totalSteps ? "Create Account" : "Next")
                                if currentStep < totalSteps {
                                    Image(systemName: "chevron.right")
                                }
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
                    .disabled(!canProceed || authViewModel.isLoading)
                }
                .padding()
                .background(Color.white)
                .shadowMedium()
            }
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: .constant(authViewModel.errorMessage != nil)) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(authViewModel.errorMessage ?? "")
            }
        }
    }
    
    private var canProceed: Bool {
        switch currentStep {
        case 1:
            return !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !phoneNumber.isEmpty
        case 2:
            return !street.isEmpty && !city.isEmpty && !state.isEmpty && !zipCode.isEmpty && !country.isEmpty
        case 3:
            return !password.isEmpty && password == confirmPassword && acceptTerms && password.count >= 8
        default:
            return false
        }
    }
    
    private func handleNext() {
        if currentStep < totalSteps {
            currentStep += 1
        } else {
            register()
        }
    }
    
    private func register() {
        let address = Address(
            street: street,
            city: city,
            state: state,
            zipCode: zipCode,
            country: country
        )
        
        let user = User(
            id: "",
            firstName: firstName,
            lastName: lastName,
            email: email,
            phoneNumber: phoneNumber,
            address: address,
            profileImageUrl: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        Task {
            await authViewModel.register(user: user, password: password)
            if authViewModel.isAuthenticated {
                dismiss()
            }
        }
    }
}

struct ProgressIndicator: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            ForEach(1...totalSteps, id: \.self) { step in
                HStack(spacing: 4) {
                    Circle()
                        .fill(step <= currentStep ? AppTheme.Colors.primary : AppTheme.Colors.textSecondary.opacity(0.3))
                        .frame(width: 8, height: 8)
                    
                    if step < totalSteps {
                        Rectangle()
                            .fill(step < currentStep ? AppTheme.Colors.primary : AppTheme.Colors.textSecondary.opacity(0.3))
                            .frame(height: 2)
                    }
                }
            }
        }
    }
}

struct PersonalInfoStep: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    @Binding var phoneNumber: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Personal Information")
                .font(AppTheme.Typography.title2)
                .fontWeight(.bold)
            
            Text("Tell us about yourself")
                .font(AppTheme.Typography.callout)
                .foregroundColor(AppTheme.Colors.textSecondary)
            
            FormField(
                icon: "person.fill",
                label: "First Name",
                placeholder: "Enter your first name",
                text: $firstName
            )
            
            FormField(
                icon: "person.fill",
                label: "Last Name",
                placeholder: "Enter your last name",
                text: $lastName
            )
            
            FormField(
                icon: "envelope.fill",
                label: "Email",
                placeholder: "Enter your email",
                text: $email,
                keyboardType: .emailAddress
            )
            
            FormField(
                icon: "phone.fill",
                label: "Phone Number",
                placeholder: "Enter your phone number",
                text: $phoneNumber,
                keyboardType: .phonePad
            )
        }
    }
}

struct AddressStep: View {
    @Binding var street: String
    @Binding var city: String
    @Binding var state: String
    @Binding var zipCode: String
    @Binding var country: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Address")
                .font(AppTheme.Typography.title2)
                .fontWeight(.bold)
            
            Text("Where do you live?")
                .font(AppTheme.Typography.callout)
                .foregroundColor(AppTheme.Colors.textSecondary)
            
            FormField(
                icon: "location.fill",
                label: "Street Address",
                placeholder: "Enter your street address",
                text: $street
            )
            
            FormField(
                icon: "building.2.fill",
                label: "City",
                placeholder: "Enter your city",
                text: $city
            )
            
            HStack(spacing: AppTheme.Spacing.md) {
                FormField(
                    icon: "map.fill",
                    label: "State",
                    placeholder: "State",
                    text: $state
                )
                
                FormField(
                    icon: "number",
                    label: "ZIP Code",
                    placeholder: "ZIP",
                    text: $zipCode,
                    keyboardType: .numberPad
                )
            }
            
            FormField(
                icon: "globe",
                label: "Country",
                placeholder: "Enter your country",
                text: $country
            )
        }
    }
}

struct SecurityStep: View {
    @Binding var password: String
    @Binding var confirmPassword: String
    @Binding var acceptTerms: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Security")
                .font(AppTheme.Typography.title2)
                .fontWeight(.bold)
            
            Text("Create a secure password")
                .font(AppTheme.Typography.callout)
                .foregroundColor(AppTheme.Colors.textSecondary)
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Label("Password", systemImage: "lock.fill")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                
                SecureField("Enter your password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornered(AppTheme.CornerRadius.md)
                    .shadowSmall()
                
                Text("Password must be at least 8 characters")
                    .font(AppTheme.Typography.caption2)
                    .foregroundColor(password.count >= 8 ? AppTheme.Colors.success : AppTheme.Colors.textSecondary)
            }
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Label("Confirm Password", systemImage: "lock.fill")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                
                SecureField("Confirm your password", text: $confirmPassword)
                    .padding()
                    .background(Color.white)
                    .cornered(AppTheme.CornerRadius.md)
                    .shadowSmall()
                
                if !confirmPassword.isEmpty {
                    Text(password == confirmPassword ? "Passwords match" : "Passwords do not match")
                        .font(AppTheme.Typography.caption2)
                        .foregroundColor(password == confirmPassword ? AppTheme.Colors.success : AppTheme.Colors.error)
                }
            }
            
            Toggle(isOn: $acceptTerms) {
                Text("I accept the Terms and Conditions")
                    .font(AppTheme.Typography.callout)
            }
            .toggleStyle(SwitchToggleStyle(tint: AppTheme.Colors.primary))
            .padding()
            .background(Color.white)
            .cornered(AppTheme.CornerRadius.md)
            .shadowSmall()
        }
    }
}

struct FormField: View {
    let icon: String
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Label(label, systemImage: icon)
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.textSecondary)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .autocapitalization(keyboardType == .emailAddress ? .none : .words)
                .padding()
                .background(Color.white)
                .cornered(AppTheme.CornerRadius.md)
                .shadowSmall()
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(AuthViewModel())
}
