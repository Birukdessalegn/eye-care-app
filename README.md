# Eye Care Mobile Application

A comprehensive Flutter mobile application designed to support individuals in maintaining their eye health, particularly those who spend long hours using computing devices and are exposed to Computer Vision Syndrome (CVS).

## 📱 Features

### Core Modules Implemented

1. **User Management**
   - User registration and login
   - Role-based access (User, Doctor, Admin)
   - Profile management with medical history
   - Secure authentication with token storage

2. **Eye Exercises** (Framework Ready)
   - Repository of eye exercises with descriptions
   - Exercise session tracking
   - Progress monitoring and weekly reports
   - Difficulty levels and categories

3. **Reminders & Notifications**
   - Daily eye break reminders
   - Medication reminders
   - Local push notifications
   - Recurring reminder patterns

4. **E-Commerce Module** (Framework Ready)
   - Eye care product catalog
   - Shopping cart functionality
   - Product search and filtering
   - Basic checkout flow

5. **Clinic Locator** (Framework Ready)
   - Find nearby eye clinics
   - Google Maps integration
   - Clinic details and contact information
   - Distance calculation

6. **Dashboard & Analytics**
   - User activity tracking
   - Weekly progress reports
   - Quick action cards
   - Today's reminders overview

## 🏗️ Architecture

The application follows a clean architecture pattern with:

- **Presentation Layer**: Flutter widgets and screens
- **Business Logic Layer**: Provider state management
- **Data Layer**: API services and local storage
- **Models**: Data structures for all entities

### Key Technologies

- **Frontend**: Flutter (Dart)
- **State Management**: Provider
- **Local Storage**: Flutter Secure Storage, Shared Preferences
- **Notifications**: Flutter Local Notifications
- **HTTP Client**: http package
- **Maps**: Google Maps Flutter
- **Location**: Geolocator


## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.24.5 or later)
- Dart SDK (3.5.4 or later)
- Android Studio / VS Code
- Android SDK (for Android builds)
- Xcode (for iOS builds, macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd eye_care_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoints**
   - Update the `baseUrl` in `lib/services/api_service.dart`
   - Replace with your actual backend API URL

4. **Set up Google Maps (Optional)**
   - Get Google Maps API key
   - Add to `android/app/src/main/AndroidManifest.xml`
   - Add to `ios/Runner/AppDelegate.swift`

5. **Run the application**
   ```bash
   flutter run
   ```

### Building for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS IPA:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web
```

## 🔧 Configuration

### Backend Integration



### Notifications Setup

1. **Android**: Configure notification channels in `AndroidManifest.xml`
2. **iOS**: Request notification permissions in `Info.plist`
3. **Firebase**: Optional - integrate Firebase for push notifications

### Google Maps Setup

1. Get API key from Google Cloud Console
2. Enable Maps SDK for Android/iOS
3. Add API key to platform-specific configuration files

The project includes:
- Widget tests for UI components
- Unit tests for business logic
- Integration tests for user flows

## 📱 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (iOS 12+)
- ✅ Web (Chrome, Firefox, Safari, Edge)

## 🔮 Future Enhancements

1. **AI Integration**: Implement symptom analysis and recommendations
2. **Telemedicine**: Video consultation features
3. **Wearable Integration**: Smart glasses and fitness tracker support
4. **Offline Mode**: Local data synchronization
5. **Multi-language**: Internationalization support
6. **Advanced Analytics**: Machine learning insights

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
