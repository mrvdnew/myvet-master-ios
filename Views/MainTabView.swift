import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 0: Home
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Inicio")
                }
                .tag(0)
            
            // Tab 1: Appointments
            AppointmentsView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "calendar" : "calendar")
                    Text("Citas")
                }
                .tag(1)
            
            // Tab 2: Pets
            PetsView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "pawprint.fill" : "pawprint")
                    Text("Mascotas")
                }
                .tag(2)
            
            // Tab 3: History
            HistoryView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "clock.fill" : "clock")
                    Text("Historial")
                }
                .tag(3)
            
            // Tab 4: Profile
            ProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "person.fill" : "person")
                    Text("Perfil")
                }
                .tag(4)
        }
        .accentColor(AppTheme.Colors.primary)
        .environmentObject(authViewModel)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
}
