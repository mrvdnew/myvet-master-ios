import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0
    
    var userId: String {
        authViewModel.currentUser?.id ?? ""
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            HomeView(userId: userId)
                .tabItem {
                    Label("Home", systemImage: selectedTab == 0 ? "house.fill" : "house")
                }
                .tag(0)
            
            // Appointments Tab
            AppointmentsView(userId: userId)
                .tabItem {
                    Label("Citas", systemImage: selectedTab == 1 ? "calendar.circle.fill" : "calendar.circle")
                }
                .tag(1)
            
            // Pets Tab
            PetsView(userId: userId)
                .tabItem {
                    Label("Mascotas", systemImage: selectedTab == 2 ? "pawprint.circle.fill" : "pawprint.circle")
                }
                .tag(2)
            
            // History Tab
            HistoryView(userId: userId)
                .tabItem {
                    Label("Historial", systemImage: selectedTab == 3 ? "heart.text.square.fill" : "heart.text.square")
                }
                .tag(3)
            
            // Profile Tab
            ProfileView()
                .tabItem {
                    Label("Perfil", systemImage: selectedTab == 4 ? "person.circle.fill" : "person.circle")
                }
                .tag(4)
        }
        .accentColor(AppTheme.Colors.primary)
    }
}

#Preview {
    TabBarView()
        .environmentObject(AuthViewModel())
}
