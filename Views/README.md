# MyVet iOS Views Documentation

This document describes all the UI views created for the MyVet iOS application, following the Android version's design and structure.

## Design Theme

The app uses an Android-inspired color scheme:
- **Primary Color**: Green (#4CAF50) - Used for main actions and navigation
- **Secondary Color**: Orange (#FF9800) - Used for accents and secondary elements
- **Accent Color**: Teal (#03DAC5) - Used for highlights and special features
- **Background**: Beige (#F5F1EB) - Warm, professional background color

## Main Views

### 1. TabBarView
**File**: `Views/TabBarView.swift`

Main navigation container with bottom tab bar containing 5 tabs:
- **Home** (Casa) - Dashboard overview
- **Citas** - Appointments management
- **Mascotas** - Pets management
- **Historial** - Medical history records
- **Perfil** - User profile

### 2. HomeView
**File**: `Views/HomeView.swift`

Main dashboard displaying:
- Welcome header with user name
- Quick action buttons (Book Appointment, Add Pet, Medical Records, Reminders)
- Upcoming appointments summary (max 3)
- My Pets summary (horizontal scroll)

**Key Features**:
- Real-time data fetching from ViewModels
- Empty states for no data
- Navigation to detail views

### 3. AppointmentsView
**File**: `Views/AppointmentsView.swift`

Comprehensive appointments management:
- Grouped by date sections
- Individual appointment cards with:
  - Time and duration
  - Service type
  - Status badge (Scheduled, Confirmed, Completed, Cancelled, No Show)
  - Delete action
- Create new appointment with BookAppointmentView modal
- Empty state for no appointments

**Related Components**:
- `BookAppointmentView` - Modal form for creating appointments

### 4. PetsView
**File**: `Views/PetsView.swift`

Pet management interface:
- List of user's pets with cards showing:
  - Pet icon (type-specific: dog, cat, rabbit, bird)
  - Name, type, and breed
  - Age and weight
- Navigation to PetDetailView
- Add new pet with AddPetView modal
- Delete pets with confirmation

**Related Components**:
- `PetDetailView` - Detailed pet information and medical history
- `AddPetView` - Modal form for adding new pets
- `PetHeaderCard` - Pet profile header
- `PetInformationCard` - Pet details card
- `MedicalHistorySection` - Medical records list

### 5. HistoryView
**File**: `Views/HistoryView.swift`

Medical history viewer:
- Pet selector (horizontal scroll)
- Selected pet summary
- Expandable medical record cards with:
  - Diagnosis
  - Date
  - Veterinarian
  - Treatment
  - Notes
- Empty state for no records

**Key Features**:
- Pet-specific history filtering
- Expandable record details
- Chronological sorting (newest first)

### 6. ProfileView
**File**: `Views/ProfileView.swift`

User profile and settings:
- Profile header with user information
- Account section (Edit Profile, Change Password, Notifications)
- Preferences section (Dark Mode, Language)
- About section (About MyVet, Terms & Conditions, Privacy Policy)
- Logout button
- Version information

**Related Components**:
- `EditProfileView` - Modal form for editing user profile

### 7. LoginView
**File**: `Views/LoginView.swift`

Authentication screen:
- App logo and branding
- Email and password fields
- Login button with loading state
- Forgot password link
- Create new account button
- Error message display

**Related Components**:
- `ForgotPasswordView` - Modal for password reset

### 8. RegisterView
**File**: `Views/RegisterView.swift`

Multi-step registration:
- **Step 1**: Personal Information (name, email, phone)
- **Step 2**: Address (street, city, state, zip, country)
- **Step 3**: Security (password, confirm password, terms acceptance)
- Progress indicator
- Next/Back navigation
- Form validation

## Reusable Components

### UI Components
- `EmptyStateCard` - Consistent empty state display
- `ErrorBanner` - Error message banner
- `StatusBadge` - Appointment status indicator
- `QuickActionCard` - Action button card
- `PetCard` - Pet summary card
- `AppointmentCard` - Appointment summary card
- `MedicalRecordCard` - Medical record card
- `InfoRow` - Label-value row
- `DetailRow` - Icon-label-value row
- `FormField` - Consistent form input field
- `ProfileMenuItem` - Profile menu item with icon and chevron
- `ProgressIndicator` - Step progress indicator

## MVVM Architecture

All views follow MVVM pattern:
- **Views**: SwiftUI views (presentation layer)
- **ViewModels**: 
  - `AppointmentsViewModel` - Appointment data and operations
  - `PetsViewModel` - Pet data and operations
  - `AuthViewModel` - Authentication and user management
- **Models**:
  - `Appointment` - Appointment data model
  - `Pet` - Pet data model
  - `MedicalRecord` - Medical record data model
  - `User` - User data model
  - `TimeSlot` - Available time slot model

## Navigation Flow

```
LoginView (if not authenticated)
    ↓
TabBarView (if authenticated)
    ├── HomeView
    │   ├── Quick Actions
    │   ├── Upcoming Appointments → AppointmentsView
    │   └── My Pets → PetsView
    ├── AppointmentsView
    │   └── BookAppointmentView (modal)
    ├── PetsView
    │   ├── AddPetView (modal)
    │   └── PetDetailView
    ├── HistoryView
    │   └── Medical Records (per pet)
    └── ProfileView
        └── EditProfileView (modal)
```

## Styling

All views use AppTheme constants:
- **Colors**: `AppTheme.Colors.*`
- **Typography**: `AppTheme.Typography.*`
- **Spacing**: `AppTheme.Spacing.*`
- **Corner Radius**: `AppTheme.CornerRadius.*`
- **Shadows**: View extensions (`.shadowSmall()`, `.shadowMedium()`, `.shadowLarge()`)

## State Management

- `@StateObject` - View-owned ViewModels
- `@EnvironmentObject` - Shared AuthViewModel
- `@State` - Local view state
- `@Binding` - Parent-child communication
- `async/await` - Asynchronous data fetching

## Data Fetching

Views fetch data on appear:
```swift
.onAppear {
    Task {
        await viewModel.fetchData()
    }
}
```

## Error Handling

Consistent error display:
- Error banners at top of screen
- Red color scheme
- Exclamation icon
- Dismissible or auto-dismiss

## Empty States

All list views include empty states:
- Large icon
- Title
- Description
- Call-to-action button

## Accessibility

- Semantic labels
- SF Symbols for icons
- Dynamic type support
- VoiceOver compatible

## Testing

Preview providers included for all views:
```swift
#Preview {
    ViewName()
        .environmentObject(AuthViewModel())
}
```

## Future Enhancements

1. Add search functionality to lists
2. Implement filters and sorting
3. Add pull-to-refresh
4. Include push notifications
5. Add image upload for pets
6. Implement appointment reminders
7. Add multi-language support
8. Include dark mode support
9. Add animation transitions
10. Implement offline mode

## Dependencies

- SwiftUI framework
- Existing ViewModels
- Existing Models
- Existing Services (AppointmentService, PetService)
- AppTheme styling system
