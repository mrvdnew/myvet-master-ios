# Xcode Project Setup Guide

This guide explains how to create an Xcode project for the MyVet iOS application.

## Step-by-Step Instructions

### 1. Create New Xcode Project

1. Open Xcode
2. Select **File > New > Project**
3. Choose **iOS** platform
4. Select **App** template
5. Click **Next**

### 2. Configure Project Settings

- **Product Name**: MyVet
- **Team**: Select your development team
- **Organization Identifier**: com.yourcompany (e.g., com.myvet)
- **Bundle Identifier**: Will be generated automatically
- **Interface**: SwiftUI
- **Life Cycle**: SwiftUI App
- **Language**: Swift
- **Include Tests**: ✓ (optional)

Click **Next** and save the project in the repository directory (alongside Package.swift).

### 3. Add Source Files to Project

Delete the default `ContentView.swift` and `MyVetApp.swift` files that Xcode created.

Then add the existing source files by dragging these folders into your Xcode project navigator:

1. **MyVetApp.swift** (main app entry point)
2. **Models/** folder
3. **Views/** folder
4. **ViewModels/** folder
5. **Networking/** folder
6. **Theme/** folder
7. **Utils/** folder

When adding files, make sure to:
- ✓ Copy items if needed
- ✓ Create groups (not folder references)
- ✓ Add to target: MyVet

### 4. Configure Build Settings

#### Deployment Target
- Set **iOS Deployment Target** to **14.0** or higher
- Navigate to Project settings > General > Deployment Info

#### App Icons and Launch Screen
- Add app icons to Assets.xcassets if needed
- Launch screen is configured via Info.plist (already included)

### 5. Info.plist Configuration

The Info.plist file is already configured with:
- Bundle identifier settings
- Supported interface orientations
- Launch screen configuration
- Required device capabilities

If you need to add additional permissions (e.g., camera, location), add them in Info.plist.

### 6. Build and Run

1. Select your target device or simulator from the scheme selector
2. Press **Cmd + B** to build
3. Press **Cmd + R** to run

The app should launch with the login screen.

## Default Login Credentials

The app currently uses mock authentication. You can log in with any email and password:

- Email: test@example.com
- Password: password123

Or register a new account using the registration flow.

## Project Structure in Xcode

Your Xcode project navigator should look like this:

```
MyVet/
├── MyVetApp.swift
├── Models/
│   ├── User.swift
│   ├── Pet.swift
│   ├── Appointment.swift
│   └── Veterinarian.swift
├── Views/
│   ├── LoginView.swift
│   ├── RegisterView.swift
│   ├── MainTabView.swift
│   ├── HomeView.swift
│   ├── AppointmentsView.swift
│   ├── PetsView.swift
│   ├── HistoryView.swift
│   └── ProfileView.swift
├── ViewModels/
│   ├── AuthViewModel.swift
│   ├── HomeViewModel.swift
│   ├── AppointmentsViewModel.swift
│   ├── PetsViewModel.swift
│   └── ProfileViewModel.swift
├── Networking/
│   ├── APIClient.swift
│   ├── AppointmentService.swift
│   └── PetService.swift
├── Theme/
│   ├── AppTheme.swift
│   ├── FontConstants.swift
│   └── Modifiers.swift
├── Utils/
│   └── DateFormatter+Extension.swift
├── Assets.xcassets/
│   └── AppIcon
├── Info.plist
└── Preview Content/
    └── Preview Assets.xcassets
```

## Troubleshooting

### Build Errors

**"Cannot find type 'X' in scope"**
- Ensure all source files are added to the project target
- Check that files are in the correct groups
- Clean build folder: Product > Clean Build Folder (Cmd + Shift + K)

**"Duplicate symbol"**
- Make sure you don't have multiple copies of files
- Check that old AppointmentView.swift and PetListView.swift are removed

### Runtime Issues

**App crashes on launch**
- Check that MyVetApp.swift is properly configured as the @main entry point
- Verify all view dependencies are properly imported

**Views not displaying correctly**
- Check that AppTheme.swift colors are properly defined
- Verify SwiftUI preview providers if using previews

## Testing the App

### Main Features to Test

1. **Login Flow**
   - Try logging in with any email/password
   - Test password visibility toggle
   - Verify loading state

2. **Registration**
   - Fill out registration form
   - Test validation errors
   - Verify successful registration

3. **Home Dashboard**
   - Check personalized greeting
   - Verify quick action buttons
   - Scroll through appointments and pets

4. **Appointments**
   - View existing appointments
   - Create new appointment
   - Check status badges

5. **Pets**
   - View pet list
   - Add new pet
   - Verify pet details display

6. **History**
   - View past events
   - Test filter tabs

7. **Profile**
   - View profile information
   - Edit profile
   - Test logout

## Next Steps

Once the project is set up and running:

1. **Connect to Real Backend**
   - Update APIClient baseURL
   - Remove mock data from ViewModels
   - Implement proper authentication

2. **Add App Icons**
   - Design app icons for different sizes
   - Add to Assets.xcassets

3. **Configure Code Signing**
   - Set up provisioning profiles
   - Configure for App Store distribution

4. **Add Tests**
   - Unit tests for ViewModels
   - UI tests for main flows

5. **Performance Optimization**
   - Profile the app with Instruments
   - Optimize images and assets
   - Implement caching strategies

---

For more information, refer to the README.md file or contact the development team.
