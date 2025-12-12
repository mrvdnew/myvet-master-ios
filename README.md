# MyVet Master iOS

MyVet Master iOS is a comprehensive veterinary management application for iOS devices built with SwiftUI. This application provides pet owners with tools to efficiently manage their pets' health, appointments, and medical records.

## Features

- **Authentication**: Secure login and registration system
- **Home Dashboard**: Personalized greeting with quick actions and upcoming appointments
- **Appointment Management**: Schedule, view, and manage veterinary appointments
- **Pet Management**: Maintain detailed records of your pets with medical histories
- **History**: View past appointments, vaccinations, and treatments
- **Profile Management**: Edit user profile and manage account settings
- **Bottom Tab Navigation**: Easy access to all features with 5 main tabs

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Models**: Data structures for User, Pet, Appointment, etc.
- **Views**: SwiftUI views for all screens (Login, Register, Home, Appointments, Pets, History, Profile)
- **ViewModels**: Business logic and state management (AuthViewModel, HomeViewModel, etc.)
- **Networking**: API client and service layers for backend communication
- **Theme**: Centralized color scheme and styling

## Color Scheme

- Primary Green: RGB(0.30, 0.63, 0.31)
- Secondary Orange: RGB(1.0, 0.60, 0.0)
- Background: RGB(0.96, 0.94, 0.92)
- Status Colors: Green (scheduled), Cyan (confirmed), Gray (completed), Red (cancelled)

## Requirements

- iOS 14.0 or later
- Xcode 13.0 or later
- Swift 5.5 or later

## Installation

### Option 1: Create Xcode Project (Recommended)

1. Clone the repository:
   ```bash
   git clone https://github.com/mrvdnew/myvet-master-ios.git
   cd myvet-master-ios
   ```

2. Open Xcode and create a new iOS App project:
   - File > New > Project
   - Select "iOS" > "App"
   - Product Name: MyVet
   - Interface: SwiftUI
   - Life Cycle: SwiftUI App
   - Save it in the repository directory

3. Add all source files to the project:
   - Drag and drop the following folders into your Xcode project:
     - Models/
     - Views/
     - ViewModels/
     - Networking/
     - Theme/
     - Utils/
     - MyVetApp.swift

4. Build and run the project on your iOS device or simulator.

### Option 2: Using Swift Package Manager

This repository can be used as a Swift Package. The Package.swift file is configured to work with the current structure.

```bash
swift build
```

Note: To run as an iOS app, you'll need to create an Xcode project as described in Option 1.

## Project Structure

```
myvet-master-ios/
├── MyVetApp.swift          # App entry point
├── Models/                  # Data models
│   ├── User.swift
│   ├── Pet.swift
│   ├── Appointment.swift
│   └── Veterinarian.swift
├── Views/                   # SwiftUI views
│   ├── LoginView.swift
│   ├── RegisterView.swift
│   ├── MainTabView.swift
│   ├── HomeView.swift
│   ├── AppointmentsView.swift
│   ├── PetsView.swift
│   ├── HistoryView.swift
│   └── ProfileView.swift
├── ViewModels/              # View models
│   ├── AuthViewModel.swift
│   ├── HomeViewModel.swift
│   ├── AppointmentsViewModel.swift
│   ├── PetsViewModel.swift
│   └── ProfileViewModel.swift
├── Networking/              # API layer
│   ├── APIClient.swift
│   ├── AppointmentService.swift
│   └── PetService.swift
├── Theme/                   # Styling and themes
│   ├── AppTheme.swift
│   ├── FontConstants.swift
│   └── Modifiers.swift
└── Utils/                   # Utility functions
    └── DateFormatter+Extension.swift
```

## Features Implemented

### Authentication Flow
- ✅ Login screen with email/password
- ✅ Registration screen with validation
- ✅ Password visibility toggle
- ✅ Error handling and loading states
- ✅ Mock authentication for testing

### Home Dashboard
- ✅ Personalized greeting
- ✅ Quick action buttons
- ✅ Upcoming appointments section
- ✅ Registered pets section
- ✅ Responsive card-based layout

### Appointments
- ✅ List of all appointments
- ✅ Create new appointment modal
- ✅ Appointment status badges (scheduled, confirmed, completed, cancelled)
- ✅ Service type selection
- ✅ Duration selection

### Pets
- ✅ List of all pets
- ✅ Add new pet modal
- ✅ Pet details (name, type, breed, age, weight)
- ✅ Date of birth picker

### History
- ✅ View past events and activities
- ✅ Filter by type (appointments, vaccinations, treatments)
- ✅ Event cards with icons and details

### Profile
- ✅ User information display
- ✅ Edit profile functionality
- ✅ Settings sections (notifications, privacy, help, about)
- ✅ Logout functionality

## Development

The app uses mock data for demonstration purposes. To connect to a real backend:

1. Update the `APIClient` base URL in `Networking/APIClient.swift`
2. Remove mock data from ViewModels
3. Implement proper error handling
4. Add authentication token management

## Testing

Currently includes mock data and simulated network delays for testing the UI and user flows without a backend.

## Future Enhancements

- Real API integration
- Push notifications
- Image upload for pets
- Appointment reminders
- Medical records management
- Multi-language support
- Dark mode support

## License

This project is proprietary software. All rights reserved.

## Support

For support or inquiries, please contact the development team.

---

**Last Updated**: 2025-12-12
