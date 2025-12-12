import SwiftUI

struct PetsView: View {
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
                    EmptyPetsView(showingAddPetSheet: $showingAddPetSheet)
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppTheme.Spacing.md) {
                            ForEach(viewModel.pets) { pet in
                                NavigationLink(destination: PetDetailView(pet: pet)) {
                                    PetRowCard(
                                        pet: pet,
                                        onDelete: {
                                            Task {
                                                await viewModel.deletePet(pet.id)
                                            }
                                        }
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                    .background(Color.appBackground)
                }
                
                if let error = viewModel.errorMessage {
                    VStack {
                        ErrorBanner(message: error)
                        Spacer()
                    }
                }
            }
            .navigationTitle("My Pets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddPetSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AppTheme.Colors.primary)
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
}

struct EmptyPetsView: View {
    @Binding var showingAddPetSheet: Bool
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: "pawprint.circle")
                .font(.system(size: 80))
                .foregroundColor(AppTheme.Colors.primary)
            
            VStack(spacing: AppTheme.Spacing.xs) {
                Text("No Pets Yet")
                    .font(AppTheme.Typography.title2)
                    .fontWeight(.bold)
                
                Text("Add your first pet to get started")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingAddPetSheet = true }) {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Add Pet")
                }
                .font(AppTheme.Typography.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppTheme.Colors.primary)
                .cornered(AppTheme.CornerRadius.md)
            }
            .padding(.top, AppTheme.Spacing.md)
        }
        .padding(AppTheme.Spacing.xl)
    }
}

struct PetRowCard: View {
    let pet: Pet
    let onDelete: () -> Void
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            // Pet icon
            Image(systemName: petIcon)
                .font(.system(size: 40))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(AppTheme.Colors.primary)
                .cornered(AppTheme.CornerRadius.md)
            
            // Pet details
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(pet.name)
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.text)
                
                Text("\(pet.type.capitalized) • \(pet.breed)")
                    .font(AppTheme.Typography.callout)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                
                HStack(spacing: AppTheme.Spacing.sm) {
                    Label("\(pet.age) yrs", systemImage: "calendar")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                    
                    Label(String(format: "%.1f kg", pet.weight), systemImage: "scalemass")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .padding()
        .background(Color.white)
        .cornered(AppTheme.CornerRadius.lg)
        .shadowMedium()
        .padding(.horizontal)
        .contextMenu {
            Button(role: .destructive) {
                showDeleteConfirmation = true
            } label: {
                Label("Delete Pet", systemImage: "trash")
            }
        }
        .confirmationDialog("Delete Pet", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete \(pet.name)?")
        }
    }
    
    private var petIcon: String {
        switch pet.type.lowercased() {
        case "dog":
            return "dog.fill"
        case "cat":
            return "cat.fill"
        case "rabbit":
            return "hare.fill"
        case "bird":
            return "bird.fill"
        default:
            return "pawprint.fill"
        }
    }
}

struct PetDetailView: View {
    let pet: Pet
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                // Pet Header
                PetHeaderCard(pet: pet)
                
                // Pet Information
                PetInformationCard(pet: pet)
                
                // Medical History
                MedicalHistorySection(records: pet.medicalHistory)
            }
            .padding()
        }
        .background(Color.appBackground)
        .navigationTitle(pet.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PetHeaderCard: View {
    let pet: Pet
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: petIcon)
                .font(.system(size: 60))
                .foregroundColor(.white)
                .frame(width: 100, height: 100)
                .background(AppTheme.Colors.primary)
                .cornered(AppTheme.CornerRadius.lg)
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(pet.name)
                    .font(AppTheme.Typography.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.Colors.text)
                
                Text("\(pet.type.capitalized) • \(pet.breed)")
                    .font(AppTheme.Typography.callout)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                
                HStack(spacing: AppTheme.Spacing.sm) {
                    Label("\(pet.age) years", systemImage: "calendar")
                        .font(AppTheme.Typography.caption)
                    
                    Label(String(format: "%.1f kg", pet.weight), systemImage: "scalemass")
                        .font(AppTheme.Typography.caption)
                }
                .foregroundColor(AppTheme.Colors.textSecondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornered(AppTheme.CornerRadius.lg)
        .shadowMedium()
    }
    
    private var petIcon: String {
        switch pet.type.lowercased() {
        case "dog":
            return "dog.fill"
        case "cat":
            return "cat.fill"
        case "rabbit":
            return "hare.fill"
        case "bird":
            return "bird.fill"
        default:
            return "pawprint.fill"
        }
    }
}

struct PetInformationCard: View {
    let pet: Pet
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Information")
                .font(AppTheme.Typography.title3)
                .fontWeight(.semibold)
            
            VStack(spacing: AppTheme.Spacing.sm) {
                InfoRow(label: "Birth Date", value: formatDate(pet.dateOfBirth))
                Divider()
                InfoRow(label: "Age", value: "\(pet.age) years")
                Divider()
                InfoRow(label: "Weight", value: String(format: "%.1f kg", pet.weight))
                Divider()
                InfoRow(label: "Breed", value: pet.breed)
                
                if let microchipId = pet.microchipId {
                    Divider()
                    InfoRow(label: "Microchip ID", value: microchipId)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornered(AppTheme.CornerRadius.lg)
        .shadowMedium()
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
                .font(AppTheme.Typography.callout)
                .foregroundColor(AppTheme.Colors.textSecondary)
            Spacer()
            Text(value)
                .font(AppTheme.Typography.callout)
                .fontWeight(.semibold)
                .foregroundColor(AppTheme.Colors.text)
        }
    }
}

struct MedicalHistorySection: View {
    let records: [MedicalRecord]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Medical History")
                .font(AppTheme.Typography.title3)
                .fontWeight(.semibold)
            
            if records.isEmpty {
                EmptyStateCard(
                    icon: "heart.text.square",
                    message: "No medical records yet"
                )
            } else {
                ForEach(records) { record in
                    MedicalRecordCard(record: record)
                }
            }
        }
    }
}

struct MedicalRecordCard: View {
    let record: MedicalRecord
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack {
                Text(record.diagnosis)
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.text)
                
                Spacer()
                
                Text(formatDate(record.date))
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                HStack {
                    Image(systemName: "cross.case")
                        .font(.caption)
                        .foregroundColor(AppTheme.Colors.primary)
                    Text("Treatment: \(record.treatment)")
                        .font(AppTheme.Typography.callout)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                
                HStack {
                    Image(systemName: "stethoscope")
                        .font(.caption)
                        .foregroundColor(AppTheme.Colors.primary)
                    Text("By: \(record.veterinarian)")
                        .font(AppTheme.Typography.callout)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                
                if let notes = record.notes {
                    HStack(alignment: .top) {
                        Image(systemName: "note.text")
                            .font(.caption)
                            .foregroundColor(AppTheme.Colors.primary)
                        Text(notes)
                            .font(AppTheme.Typography.callout)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornered(AppTheme.CornerRadius.lg)
        .shadowSmall()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    PetsView(userId: "user123")
}
