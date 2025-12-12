import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = HistoryViewModel()
    @State private var selectedFilter: HistoryFilter = .all
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Filter Tabs
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(HistoryFilter.allCases, id: \.self) { filter in
                                FilterChip(
                                    title: filter.title,
                                    isSelected: selectedFilter == filter,
                                    action: { selectedFilter = filter }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    .background(Color.white)
                    
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.primary))
                        Spacer()
                    } else if filteredEvents.isEmpty {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.system(size: 64))
                                .foregroundColor(AppTheme.Colors.textSecondary)
                            
                            Text("No hay historial")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(AppTheme.Colors.text)
                            
                            Text("Las actividades pasadas aparecerán aquí")
                                .foregroundColor(AppTheme.Colors.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(filteredEvents) { event in
                                    HistoryEventCard(event: event)
                                        .padding(.horizontal, 16)
                                }
                            }
                            .padding(.vertical, 16)
                        }
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
            .navigationTitle("Historial")
            .onAppear {
                if let userId = authViewModel.currentUser?.id {
                    Task {
                        await viewModel.fetchHistory(userId: userId)
                    }
                }
            }
        }
    }
    
    private var filteredEvents: [HistoryEvent] {
        switch selectedFilter {
        case .all:
            return viewModel.events
        case .appointments:
            return viewModel.events.filter { $0.type == .appointment }
        case .vaccinations:
            return viewModel.events.filter { $0.type == .vaccination }
        case .treatments:
            return viewModel.events.filter { $0.type == .treatment }
        }
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : AppTheme.Colors.text)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? AppTheme.Colors.primary : Color.gray.opacity(0.1))
                .cornerRadius(20)
        }
    }
}

// MARK: - History Event Card
struct HistoryEventCard: View {
    let event: HistoryEvent
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(eventColor.opacity(0.2))
                    .frame(width: 48, height: 48)
                
                Image(systemName: eventIcon)
                    .font(.title3)
                    .foregroundColor(eventColor)
            }
            
            // Event Details
            VStack(alignment: .leading, spacing: 6) {
                Text(event.title)
                    .font(.headline)
                    .foregroundColor(AppTheme.Colors.text)
                
                Text(event.description)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption)
                    Text(formatDate(event.date))
                        .font(.caption)
                }
                .foregroundColor(AppTheme.Colors.textSecondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private var eventIcon: String {
        switch event.type {
        case .appointment:
            return "calendar.badge.checkmark"
        case .vaccination:
            return "cross.case.fill"
        case .treatment:
            return "stethoscope"
        case .checkup:
            return "heart.text.square.fill"
        }
    }
    
    private var eventColor: Color {
        switch event.type {
        case .appointment:
            return AppTheme.Colors.primary
        case .vaccination:
            return Color.blue
        case .treatment:
            return AppTheme.Colors.secondary
        case .checkup:
            return Color.purple
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy • HH:mm"
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: date)
    }
}

// MARK: - History Filter Enum
enum HistoryFilter: CaseIterable {
    case all
    case appointments
    case vaccinations
    case treatments
    
    var title: String {
        switch self {
        case .all:
            return "Todos"
        case .appointments:
            return "Citas"
        case .vaccinations:
            return "Vacunas"
        case .treatments:
            return "Tratamientos"
        }
    }
}

// MARK: - History Event Model
struct HistoryEvent: Identifiable {
    let id: String
    let type: HistoryEventType
    let title: String
    let description: String
    let date: Date
}

enum HistoryEventType {
    case appointment
    case vaccination
    case treatment
    case checkup
}

// MARK: - History ViewModel
@MainActor
class HistoryViewModel: ObservableObject {
    @Published var events: [HistoryEvent] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchHistory(userId: String) async {
        isLoading = true
        errorMessage = nil
        
        // Simulate loading
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Mock data for demonstration
        events = [
            HistoryEvent(
                id: UUID().uuidString,
                type: .appointment,
                title: "Cita completada",
                description: "Chequeo general de salud - Dr. García",
                date: Date().addingTimeInterval(-86400 * 5)
            ),
            HistoryEvent(
                id: UUID().uuidString,
                type: .vaccination,
                title: "Vacuna aplicada",
                description: "Vacuna antirrábica - Max",
                date: Date().addingTimeInterval(-86400 * 15)
            ),
            HistoryEvent(
                id: UUID().uuidString,
                type: .treatment,
                title: "Tratamiento completado",
                description: "Limpieza dental - Luna",
                date: Date().addingTimeInterval(-86400 * 30)
            ),
            HistoryEvent(
                id: UUID().uuidString,
                type: .checkup,
                title: "Chequeo anual",
                description: "Examen físico completo - Max",
                date: Date().addingTimeInterval(-86400 * 60)
            )
        ]
        
        isLoading = false
    }
}

#Preview {
    HistoryView()
        .environmentObject(AuthViewModel())
}
