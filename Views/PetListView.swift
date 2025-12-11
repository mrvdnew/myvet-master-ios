import SwiftUI

struct PetListView: View {
    @StateObject private var viewModel: PetsViewModel
    @State private var showingAddPetSheet = false
    
    init(userId: String) {
        _viewModel = StateObject(wrappedValue: PetsViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if viewModel.pets.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "pawprint.circle")
                            .font(.system(size: 64))
                            .foregroundColor(.gray)
                        
                        Text("No Pets Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Add your first pet to get started")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button(action: { showingAddPetSheet = true }) {
                            Text("Add Pet")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .padding(.top, 16)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(viewModel.pets) { pet in
                            NavigationLink(destination: PetDetailView(pet: pet)) {
                                HStack {
                                    Image(systemName: "pawprint.fill")
                                        .foregroundColor(.blue)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(pet.name)
                                            .font(.headline)
                                        Text("\(pet.type) • \(pet.breed)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("\(pet.age) yrs")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .onDelete(perform: deletePets)
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
            .navigationTitle("My Pets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddPetSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPetSheet) {
                AddPetView(viewModel: viewModel)
            }
            .onAppear {
                Task {
                    await viewModel.fetchPets()
                }
            }
        }
    }
    
    private func deletePets(offsets: IndexSet) {
        offsets.forEach { index in
            let pet = viewModel.pets[index]
            Task {
                await viewModel.deletePet(pet.id)
            }
        }
    }
}

struct PetDetailView: View {
    let pet: Pet
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(pet.name)
                            .font(.title)
                            .fontWeight(.bold)
                        Text("\(pet.type) • \(pet.breed)")
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 12) {
                    InfoRow(label: "Age", value: "\(pet.age) years")
                    InfoRow(label: "Weight", value: "\(String(format: "%.1f", pet.weight)) kg")
                    InfoRow(label: "Birth Date", value: formatDate(pet.dateOfBirth))
                    if let microchipId = pet.microchipId {
                        InfoRow(label: "Microchip ID", value: microchipId)
                    }
                }
                
                Divider()
                    .padding(.vertical, 8)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Medical History")
                        .font(.headline)
                    
                    if pet.medicalHistory.isEmpty {
                        Text("No medical records yet")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(pet.medicalHistory) { record in
                            MedicalRecordRow(record: record)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(pet.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

struct MedicalRecordRow: View {
    let record: MedicalRecord
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(record.diagnosis)
                    .fontWeight(.semibold)
                Spacer()
                Text(formatDate(record.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text("Treatment: \(record.treatment)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("By: \(record.veterinarian)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct AddPetView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PetsViewModel
    
    @State private var name = ""
    @State private var type = "dog"
    @State private var breed = ""
    @State private var age = "0"
    @State private var weight = "0"
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Pet Name", text: $name)
                TextField("Breed", text: $breed)
                
                Picker("Type", selection: $type) {
                    Text("Dog").tag("dog")
                    Text("Cat").tag("cat")
                    Text("Rabbit").tag("rabbit")
                    Text("Bird").tag("bird")
                    Text("Other").tag("other")
                }
                
                TextField("Age (years)", text: $age)
                    .keyboardType(.numberPad)
                
                TextField("Weight (kg)", text: $weight)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add Pet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        savePet()
                    }
                }
            }
        }
    }
    
    private func savePet() {
        let petData: [String: Any] = [
            "name": name,
            "type": type,
            "breed": breed,
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
    PetListView(userId: "user123")
}