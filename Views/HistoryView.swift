import SwiftUI

struct HistoryView: View {
    @StateObject private var petsViewModel: PetsViewModel
    @State private var selectedPetId: String?
    
    init(userId: String) {
        _petsViewModel = StateObject(wrappedValue: PetsViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if petsViewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if petsViewModel.pets.isEmpty {
                    EmptyHistoryView()
                } else {
                    VStack(spacing: 0) {
                        // Pet selector
                        PetSelectorSection(
                            pets: petsViewModel.pets,
                            selectedPetId: $selectedPetId
                        )
                        
                        // Medical history content
                        if let selectedPet = selectedPet {
                            MedicalHistoryContent(pet: selectedPet)
                        } else {
                            SelectPetPrompt()
                        }
                    }
                    .background(Color.appBackground)
                }
                
                if let error = petsViewModel.errorMessage {
                    VStack {
                        ErrorBanner(message: error)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Medical History")
            .onAppear {
                Task {
                    await petsViewModel.fetchPets()
                    if selectedPetId == nil && !petsViewModel.pets.isEmpty {
                        selectedPetId = petsViewModel.pets.first?.id
                    }
                }
            }
        }
    }
    
    private var selectedPet: Pet? {
        petsViewModel.pets.first { $0.id == selectedPetId }
    }
}

struct EmptyHistoryView: View {
    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: "heart.text.square")
                .font(.system(size: 80))
                .foregroundColor(AppTheme.Colors.primary)
            
            VStack(spacing: AppTheme.Spacing.xs) {
                Text("No Medical History")
                    .font(AppTheme.Typography.title2)
                    .fontWeight(.bold)
                
                Text("Add pets to view their medical history")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(AppTheme.Spacing.xl)
    }
}

struct PetSelectorSection: View {
    let pets: [Pet]
    @Binding var selectedPetId: String?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.md) {
                ForEach(pets) { pet in
                    PetSelectorButton(
                        pet: pet,
                        isSelected: selectedPetId == pet.id
                    ) {
                        selectedPetId = pet.id
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, AppTheme.Spacing.sm)
        }
        .background(Color.white)
        .shadowSmall()
    }
}

struct PetSelectorButton: View {
    let pet: Pet
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppTheme.Spacing.xs) {
                Image(systemName: petIcon)
                    .font(.system(size: 32))
                    .foregroundColor(isSelected ? .white : AppTheme.Colors.primary)
                    .frame(width: 60, height: 60)
                    .background(isSelected ? AppTheme.Colors.primary : AppTheme.Colors.primary.opacity(0.1))
                    .cornered(AppTheme.CornerRadius.md)
                
                Text(pet.name)
                    .font(AppTheme.Typography.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(isSelected ? AppTheme.Colors.primary : AppTheme.Colors.text)
            }
        }
        .buttonStyle(PlainButtonStyle())
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

struct SelectPetPrompt: View {
    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "arrow.up")
                .font(.system(size: 40))
                .foregroundColor(AppTheme.Colors.textSecondary)
            
            Text("Select a pet to view medical history")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct MedicalHistoryContent: View {
    let pet: Pet
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                // Pet summary
                PetSummaryCard(pet: pet)
                
                // Medical records
                if pet.medicalHistory.isEmpty {
                    EmptyMedicalRecordsView()
                } else {
                    MedicalRecordsList(records: pet.medicalHistory)
                }
            }
            .padding()
        }
    }
}

struct PetSummaryCard: View {
    let pet: Pet
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(pet.name)
                    .font(AppTheme.Typography.title3)
                    .fontWeight(.bold)
                
                Text("\(pet.type.capitalized) • \(pet.breed)")
                    .font(AppTheme.Typography.callout)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: AppTheme.Spacing.xs) {
                Label("\(pet.age) yrs", systemImage: "calendar")
                    .font(AppTheme.Typography.caption)
                
                Label(String(format: "%.1f kg", pet.weight), systemImage: "scalemass")
                    .font(AppTheme.Typography.caption)
            }
            .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .padding()
        .background(Color.white)
        .cornered(AppTheme.CornerRadius.lg)
        .shadowMedium()
    }
}

struct EmptyMedicalRecordsView: View {
    var body: some View {
        EmptyStateCard(
            icon: "heart.text.square",
            message: "No medical records for this pet"
        )
    }
}

struct MedicalRecordsList: View {
    let records: [MedicalRecord]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Records (\(records.count))")
                .font(AppTheme.Typography.title3)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            ForEach(records.sorted(by: { $0.date > $1.date })) { record in
                MedicalRecordDetailCard(record: record)
            }
        }
    }
}

struct MedicalRecordDetailCard: View {
    let record: MedicalRecord
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            // Header
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                        Text(record.diagnosis)
                            .font(AppTheme.Typography.headline)
                            .foregroundColor(AppTheme.Colors.text)
                        
                        Text(formatDate(record.date))
                            .font(AppTheme.Typography.caption)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            // Expanded details
            if isExpanded {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Divider()
                    
                    DetailRow(
                        icon: "stethoscope",
                        label: "Veterinarian",
                        value: record.veterinarian
                    )
                    
                    DetailRow(
                        icon: "cross.case",
                        label: "Treatment",
                        value: record.treatment
                    )
                    
                    if let notes = record.notes {
                        DetailRow(
                            icon: "note.text",
                            label: "Notes",
                            value: notes
                        )
                    }
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
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(AppTheme.Colors.primary)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(label)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                
                Text(value)
                    .font(AppTheme.Typography.callout)
                    .foregroundColor(AppTheme.Colors.text)
            }
        }
    }
}

#Preview {
    HistoryView(userId: "user123")
}
