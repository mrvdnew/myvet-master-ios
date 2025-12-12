# Getting Started with MyVet iOS

## Quick Start Guide

This guide will help you quickly set up and run the MyVet iOS application.

## 📋 Prerequisites

- macOS with Xcode 13.0 or later
- iOS 14.0 or later (for simulator or device)
- Basic knowledge of SwiftUI and iOS development

## 🚀 Quick Setup (5 minutes)

### Step 1: Clone the Repository

```bash
git clone https://github.com/mrvdnew/myvet-master-ios.git
cd myvet-master-ios
```

### Step 2: Create Xcode Project

1. Open Xcode
2. **File** → **New** → **Project**
3. Select **iOS** → **App**
4. Configure:
   - Product Name: `MyVet`
   - Interface: `SwiftUI`
   - Life Cycle: `SwiftUI App`
5. Save in the repository directory (next to Package.swift)

### Step 3: Add Source Files

Delete the default files Xcode created, then drag these folders into Xcode:
- `MyVetApp.swift`
- `Models/`
- `Views/`
- `ViewModels/`
- `Networking/`
- `Theme/`
- `Utils/`

Make sure to:
- ✓ Copy items if needed
- ✓ Create groups
- ✓ Add to target: MyVet

### Step 4: Build and Run

1. Select a simulator or device
2. Press **⌘ + R** to build and run

That's it! The app should launch with the login screen.

## 🔐 Test the App

### Login
Use any email and password to log in (mock authentication):
- Email: `test@example.com`
- Password: `password123`

### Explore Features
- **Home**: See dashboard with upcoming appointments and pets
- **Appointments**: View 3 mock appointments, create new ones
- **Pets**: See 3 mock pets (Max, Luna, Rocky), add new ones
- **History**: View past events with filters
- **Profile**: Edit profile and logout

## 📁 Project Structure

```
MyVet/
├── MyVetApp.swift              # App entry point
├── Views/                      # All UI screens
│   ├── LoginView.swift
│   ├── RegisterView.swift
│   ├── MainTabView.swift
│   ├── HomeView.swift
│   ├── AppointmentsView.swift
│   ├── PetsView.swift
│   ├── HistoryView.swift
│   └── ProfileView.swift
├── ViewModels/                 # Business logic
│   ├── AuthViewModel.swift
│   ├── HomeViewModel.swift
│   ├── AppointmentsViewModel.swift
│   ├── PetsViewModel.swift
│   └── ProfileViewModel.swift
├── Models/                     # Data structures
│   ├── User.swift
│   ├── Pet.swift
│   ├── Appointment.swift
│   └── Veterinarian.swift
├── Networking/                 # API layer
│   ├── APIClient.swift
│   ├── AppointmentService.swift
│   └── PetService.swift
└── Theme/                      # Styling
    ├── AppTheme.swift
    ├── FontConstants.swift
    └── Modifiers.swift
```

## 🎨 Color Reference

The app uses the exact colors specified:
- **Primary Green**: `Color(red: 0.30, green: 0.63, blue: 0.31)`
- **Secondary Orange**: `Color(red: 1.0, green: 0.60, blue: 0.0)`
- **Background**: `Color(red: 0.96, green: 0.94, blue: 0.92)`

## 📱 Features Overview

### ✅ Implemented Features

1. **Authentication**
   - Login with email/password
   - Registration with validation
   - Logout with confirmation

2. **Home Dashboard**
   - Personalized greeting
   - Quick action buttons
   - Upcoming appointments
   - Registered pets

3. **Appointments**
   - View all appointments
   - Create new appointments
   - Status badges (Scheduled, Confirmed, Completed, Cancelled)

4. **Pets**
   - View all pets
   - Add new pets
   - Pet details (name, type, breed, age, weight)

5. **History**
   - Past events display
   - Filter by type (Appointments, Vaccinations, Treatments)

6. **Profile**
   - View user information
   - Edit profile
   - Settings options
   - Logout

### 🔜 Ready for Implementation

- Backend API integration (mock data is currently used)
- Image upload for pets
- Push notifications
- Calendar integration
- Search functionality

## 🛠️ Development Tips

### Mock Data
All ViewModels use mock data for testing. To integrate with a real API:
1. Update `APIClient` base URL in `Networking/APIClient.swift`
2. Remove mock data from ViewModels
3. Implement proper error handling

### Common Tasks

**Run the app:**
```bash
⌘ + R
```

**Clean build:**
```bash
⌘ + Shift + K
```

**Run tests:**
```bash
⌘ + U
```

### Debugging
- Set breakpoints in ViewModels to debug logic
- Use SwiftUI previews for quick UI iteration
- Check console for error messages

## 📚 Additional Documentation

- **[README.md](README.md)** - Project overview and features
- **[SETUP.md](SETUP.md)** - Detailed Xcode setup instructions
- **[IMPLEMENTATION.md](IMPLEMENTATION.md)** - Complete implementation details
- **[APP_STRUCTURE.md](APP_STRUCTURE.md)** - Architecture and flow diagrams
- **[VISUAL_LAYOUTS.md](VISUAL_LAYOUTS.md)** - Screen layout mockups
- **[CHECKLIST.md](CHECKLIST.md)** - Implementation completion checklist

## ❓ Troubleshooting

### Build Errors

**"Cannot find type 'X' in scope"**
- Ensure all source files are added to the project target
- Clean build folder: Product → Clean Build Folder

**"Multiple commands produce"**
- Check for duplicate files in the project
- Remove old AppointmentView.swift and PetListView.swift if present

### Runtime Issues

**App crashes on launch**
- Verify MyVetApp.swift is set as @main entry point
- Check all dependencies are properly imported

**Views not displaying**
- Ensure AppTheme.swift is included in the project
- Verify all color definitions are correct

## 🤝 Contributing

If you'd like to contribute:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📞 Support

For issues or questions:
- Check the documentation files
- Review the IMPLEMENTATION.md for feature details
- Contact the development team

## 🎯 Next Steps

Now that you have the app running:

1. **Explore the UI** - Navigate through all tabs and features
2. **Test functionality** - Try creating appointments and pets
3. **Review code** - Check ViewModels and Views implementation
4. **Plan API integration** - Decide on backend architecture
5. **Add features** - Implement image upload, notifications, etc.

---

**Ready to build something amazing!** 🚀

For detailed setup instructions, see [SETUP.md](SETUP.md).
