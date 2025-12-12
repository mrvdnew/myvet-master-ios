# MyVet iOS App Structure

## Application Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        MyVetApp.swift                        │
│                     (@main entry point)                      │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ├── isAuthenticated? NO
                       │   │
                       │   └──> LoginView.swift
                       │        ├── Email field
                       │        ├── Password field (with show/hide toggle)
                       │        ├── "Iniciar sesión" button (GREEN)
                       │        └── "¿No tienes cuenta? Regístrate" link
                       │             │
                       │             └──> RegisterView.swift
                       │                  ├── First Name field
                       │                  ├── Last Name field
                       │                  ├── Email field
                       │                  ├── Password field
                       │                  ├── Confirm Password field
                       │                  └── "Registrarse" button (GREEN)
                       │
                       └── isAuthenticated? YES
                           │
                           └──> MainTabView.swift (TabView with 5 tabs)
                                │
                                ├── Tab 0: HomeView.swift (🏠)
                                │   ├── Header: "Hola, [nombre]"
                                │   ├── Quick Actions:
                                │   │   ├── "Mis Citas" (GREEN)
                                │   │   └── "Mis Mascotas" (ORANGE)
                                │   ├── Próximas Citas (horizontal scroll)
                                │   │   └── Appointment cards
                                │   └── Mascotas Registradas (horizontal scroll)
                                │       └── Pet cards
                                │
                                ├── Tab 1: AppointmentsView.swift (📅)
                                │   ├── List of appointments
                                │   ├── Status badges:
                                │   │   ├── Scheduled (GREEN)
                                │   │   ├── Confirmed (CYAN)
                                │   │   ├── Completed (GRAY)
                                │   │   └── Cancelled (RED)
                                │   └── + Button → CreateAppointmentView
                                │       ├── Date/Time picker
                                │       ├── Service type picker
                                │       ├── Duration picker
                                │       └── Notes field
                                │
                                ├── Tab 2: PetsView.swift (🐾)
                                │   ├── List of pets
                                │   ├── Pet cards with:
                                │   │   ├── Name
                                │   │   ├── Type & Breed
                                │   │   ├── Age
                                │   │   └── Weight
                                │   └── + Button → CreatePetView
                                │       ├── Name field
                                │       ├── Type picker
                                │       ├── Breed field
                                │       ├── Date of Birth picker
                                │       ├── Age field
                                │       └── Weight field
                                │
                                ├── Tab 3: HistoryView.swift (🕐)
                                │   ├── Filter chips:
                                │   │   ├── Todos
                                │   │   ├── Citas
                                │   │   ├── Vacunas
                                │   │   └── Tratamientos
                                │   └── Event cards with:
                                │       ├── Icon (color-coded)
                                │       ├── Title
                                │       ├── Description
                                │       └── Date/Time
                                │
                                └── Tab 4: ProfileView.swift (👤)
                                    ├── Avatar
                                    ├── Name
                                    ├── Email
                                    ├── "Editar Perfil" button
                                    ├── Información Personal:
                                    │   ├── Teléfono
                                    │   └── Email
                                    ├── Configuración:
                                    │   ├── 🔔 Notificaciones
                                    │   ├── 🔒 Privacidad
                                    │   ├── ❓ Ayuda
                                    │   └── ℹ️ Acerca de
                                    └── "Cerrar Sesión" button (RED)
```

## ViewModels & Data Flow

```
┌─────────────────────────────────────────────────────────────┐
│                        ViewModels                             │
└─────────────────────────────────────────────────────────────┘
        │
        ├── AuthViewModel (@Published)
        │   ├── isAuthenticated: Bool
        │   ├── currentUser: User?
        │   ├── isLoading: Bool
        │   ├── errorMessage: String?
        │   ├── login(email, password) async
        │   ├── register(user, password) async
        │   └── logout()
        │
        ├── HomeViewModel (@Published)
        │   ├── upcomingAppointments: [Appointment]
        │   ├── recentPets: [Pet]
        │   ├── isLoading: Bool
        │   ├── errorMessage: String?
        │   └── fetchDashboardData(userId) async
        │
        ├── AppointmentsViewModel (@Published)
        │   ├── appointments: [Appointment]
        │   ├── isLoading: Bool
        │   ├── errorMessage: String?
        │   ├── fetchAppointments() async
        │   ├── bookAppointment(data) async
        │   └── cancelAppointment(id) async
        │
        ├── PetsViewModel (@Published)
        │   ├── pets: [Pet]
        │   ├── isLoading: Bool
        │   ├── errorMessage: String?
        │   ├── fetchPets() async
        │   ├── createPet(data) async
        │   └── deletePet(id) async
        │
        └── ProfileViewModel (@Published)
            ├── user: User?
            ├── isLoading: Bool
            ├── errorMessage: String?
            ├── loadUserProfile(user)
            └── updateProfile(firstName, lastName, phone) async
```

## Models Structure

```
┌─────────────────────────────────────────────────────────────┐
│                          Models                               │
└─────────────────────────────────────────────────────────────┘
        │
        ├── User
        │   ├── id: String
        │   ├── firstName: String
        │   ├── lastName: String
        │   ├── email: String
        │   ├── phoneNumber: String
        │   ├── address: Address
        │   ├── profileImageUrl: String?
        │   ├── createdAt: Date
        │   └── updatedAt: Date
        │
        ├── Pet
        │   ├── id: String
        │   ├── name: String
        │   ├── type: String (dog, cat, rabbit, bird, other)
        │   ├── breed: String
        │   ├── age: Int
        │   ├── weight: Double
        │   ├── dateOfBirth: Date
        │   ├── microchipId: String?
        │   └── medicalHistory: [MedicalRecord]
        │
        ├── Appointment
        │   ├── id: String
        │   ├── petId: String
        │   ├── veterinarianId: String
        │   ├── clinicId: String
        │   ├── dateTime: Date
        │   ├── duration: Int (minutes)
        │   ├── serviceType: String
        │   ├── status: AppointmentStatus
        │   ├── notes: String?
        │   └── reminderSent: Bool
        │
        └── Veterinarian
            ├── id: String
            ├── firstName: String
            ├── lastName: String
            ├── specialization: String
            └── clinicId: String
```

## Networking Layer

```
┌─────────────────────────────────────────────────────────────┐
│                      Networking Layer                         │
└─────────────────────────────────────────────────────────────┘
        │
        ├── APIClient (Generic HTTP Client)
        │   ├── baseURL: String
        │   ├── request<T: Decodable>(endpoint, method, params) async throws -> T
        │   └── HTTPMethod: GET, POST, PUT, PATCH, DELETE
        │
        ├── AppointmentService
        │   ├── fetchAppointments(userId) async throws -> [Appointment]
        │   ├── createAppointment(data) async throws -> Appointment
        │   ├── updateAppointment(id, data) async throws -> Appointment
        │   ├── cancelAppointment(id) async throws
        │   └── fetchAvailableSlots(vetId, date) async throws -> [TimeSlot]
        │
        └── PetService
            ├── fetchPets(userId) async throws -> [Pet]
            ├── createPet(userId, data) async throws -> Pet
            ├── updatePet(id, data) async throws -> Pet
            ├── deletePet(id) async throws
            ├── fetchMedicalRecords(petId) async throws -> [MedicalRecord]
            └── addMedicalRecord(petId, data) async throws -> MedicalRecord
```

## Theme System

```
┌─────────────────────────────────────────────────────────────┐
│                       AppTheme.swift                          │
└─────────────────────────────────────────────────────────────┘
        │
        ├── Colors
        │   ├── primary: Color (0.30, 0.63, 0.31) GREEN
        │   ├── secondary: Color (1.0, 0.60, 0.0) ORANGE
        │   ├── background: Color (0.96, 0.94, 0.92)
        │   ├── scheduled: Color (0.30, 0.63, 0.31) GREEN
        │   ├── confirmed: Color.cyan
        │   ├── completed: Color.gray
        │   ├── cancelled: Color.red
        │   ├── text: Color.black
        │   └── textSecondary: Color.gray
        │
        ├── Typography
        │   ├── largeTitle: 34pt bold
        │   ├── title: 28pt bold
        │   ├── headline: 17pt semibold
        │   ├── body: 17pt regular
        │   └── caption: 12pt regular
        │
        ├── Spacing
        │   ├── sm: 8
        │   ├── md: 16
        │   ├── lg: 24
        │   └── xl: 32
        │
        └── CornerRadius
            ├── md: 8
            └── lg: 12
```

## Screen Hierarchy

```
Login/Register Flow:
┌──────────────────┐
│   LoginView      │
│  - Email         │
│  - Password      │
│  - Login btn     │
│  - Register link │──┐
└──────────────────┘  │
                      │
    ┌─────────────────┘
    │
    ▼
┌──────────────────┐
│  RegisterView    │
│  - First Name    │
│  - Last Name     │
│  - Email         │
│  - Password      │
│  - Confirm Pass  │
│  - Register btn  │
└──────────────────┘

Main App Flow (After Login):
┌────────────────────────────────────────────┐
│            MainTabView                      │
│  ┌──┬──┬──┬──┬──┐                          │
│  │🏠│📅│🐾│🕐│👤│                          │
│  └──┴──┴──┴──┴──┘                          │
│                                             │
│  [Selected Tab Content Displayed Here]     │
│                                             │
└────────────────────────────────────────────┘

Each Tab Content:
┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│  HomeView    │  │Appointments  │  │  PetsView    │  │ HistoryView  │  │ ProfileView  │
│              │  │    View      │  │              │  │              │  │              │
│ - Greeting   │  │              │  │              │  │              │  │ - Avatar     │
│ - Actions    │  │ - List       │  │ - List       │  │ - Filters    │  │ - Info       │
│ - Appts      │  │ - + Create   │  │ - + Create   │  │ - Events     │  │ - Settings   │
│ - Pets       │  │              │  │              │  │              │  │ - Logout     │
└──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘
```

## Key Features Summary

### ✅ Authentication
- Login with email/password
- Registration with validation
- Password visibility toggle
- Logout confirmation

### ✅ Navigation
- 5-tab bottom navigation
- Smooth tab switching
- Consistent header styling

### ✅ Dashboard (Home)
- Personalized greeting
- Quick action buttons
- Upcoming appointments preview
- Registered pets preview

### ✅ Appointments
- View all appointments
- Create new appointments
- Status-based color coding
- Date/time selection
- Service type selection

### ✅ Pets
- View all pets
- Add new pets
- Pet details display
- Type/breed selection

### ✅ History
- Past events display
- Filter by type
- Color-coded icons
- Date/time information

### ✅ Profile
- User information display
- Edit profile capability
- Settings sections
- Logout functionality

### ✅ Design System
- Consistent color scheme
- Reusable components
- Responsive layouts
- Loading states
- Error handling

---

This structure provides a complete, functional iOS application ready for Xcode project creation and API integration.
