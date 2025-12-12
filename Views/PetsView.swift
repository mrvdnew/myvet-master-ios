import SwiftUI

struct PetsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = PetsViewModel()
    @State private var showingAddPetSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.primary))
                } else if viewModel.pets.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "pawprint.circle")
                            .font(.system(size: 64))
                            .foregroundColor(AppTheme.Colors.textSecondary)
                        
                        Text("No hay mascotas")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(AppTheme.Colors.text)
                        
                        Text("Agrega tu primera mascota")
                            .foregroundColor(AppTheme.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        Button(action: { showingAddPetSheet = true }) {
                            Text("Agregar Mascota")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppTheme.Colors.primary)
                                .cornerRadius(8)
                        }
                        .padding(.top, 16)
                        .padding(.horizontal, 40)
                    }
                    .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.pets) { pet in
                                PetItemCard(pet: pet)
                                    .padding(.horizontal, 16)
                            }
                        }
                        .padding(.vertical, 16)
                    }
                }
                
                if let error = viewModel.errorMessage {
                    VStack {
                        HStack {
                            Image(systemName: "exclamationmark.circle")
                                .foregroundColor(.red)
                            Text(error)
                                .foregroundColor(.red)
                        }
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                        .padding()
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle("Mascotas")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddPetSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(AppTheme.Colors.primary)
                    }
                }
            }
            .sheet(isPresented: $showingAddPetSheet) {
                CreatePetView(viewModel: viewModel)
            }
            .onAppear {
                if let userId = authViewModel.currentUser?.id {
                    viewModel.setUserId(userId)
                    Task {
                        await viewModel.fetchPets()
                    }
                }
            }
        }
    }
}

// MARK: - Pet Item Card
struct PetItemCard: View {
    let pet: Pet
    
    var body: some View {
        HStack(spacing: 16) {
            // Pet Icon
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.secondary.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "pawprint.fill")
                    .font(.title2)
                    .foregroundColor(AppTheme.Colors.secondary)
            }
            
            // Pet Info
            VStack(alignment: .leading, spacing: 6) {
                Text(pet.name)
                    .font(.headline)
                    .foregroundColor(AppTheme.Colors.text)
                
                Text("\(pet.type.capitalized) • \(pet.breed)")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption)
                        Text("\(pet.age) años")
                            .font(.caption)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "scalemass")
                            .font(.caption)
                        Text("\(String(format: "%.1f", pet.weight)) kg")
                            .font(.caption)
                    }
                }
                .foregroundColor(AppTheme.Colors.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Create Pet View
struct CreatePetView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PetsViewModel
    
    @State private var name = ""
    @State private var type = "dog"
    @State private var breed = ""
    @State private var dateOfBirth = Date()
    @State private var age = ""
    @State private var weight = ""
    
    let petTypes = [
        ("dog", "Perro"),
        ("cat", "Gato"),
        ("rabbit", "Conejo"),
        ("bird", "Ave"),
        ("other", "Otro")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                Form {
                    Section(header: Text("Información Básica")) {
                        TextField("Nombre de la mascota", text: $name)
                        
                        Picker("Tipo", selection: $type) {
                            ForEach(petTypes, id: \.0) { petType in
                                Text(petType.1).tag(petType.0)
                            }
                        }
                        
                        TextField("Raza", text: $breed)
                    }
                    
                    Section(header: Text("Detalles")) {
                        DatePicker("Fecha de Nacimiento", selection: $dateOfBirth, in: ...Date(), displayedComponents: .date)
                        
                        TextField("Edad (años)", text: $age)
                            .keyboardType(.numberPad)
                        
                        TextField("Peso (kg)", text: $weight)
                            .keyboardType(.decimalPad)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Nueva Mascota")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.Colors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        createPet()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.Colors.primary)
                    .disabled(name.isEmpty || breed.isEmpty)
                }
            }
        }
    }
    
    private func createPet() {
        let formatter = ISO8601DateFormatter()
        let petData: [String: Any] = [
            "name": name,
            "type": type,
            "breed": breed,
            "date_of_birth": formatter.string(from: dateOfBirth),
            "age": Int(age) ?? 0,
            "weight": Double(weight) ?? 0.0
        ]
        
        Task {
            await viewModel.createPet(petData)
            dismiss()
        }
    }
}

#Preview {
    PetsView()
        .environmentObject(AuthViewModel())
}
