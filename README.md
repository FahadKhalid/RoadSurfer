# RoadSurfer - Campsite Discovery App

A Flutter application for discovering and exploring campsites across Europe. Built with modern Flutter architecture using Riverpod for state management and Google Maps integration.

## 🌐 Live Demo

**Visit the live app:** [https://fahadkhalid.github.io/RoadSurfer/](https://fahadkhalid.github.io/RoadSurfer/)

## Features

### 🏕️ Campsite Discovery
- Browse campsites with detailed information
- Filter campsites by various criteria (water proximity, campfire allowed, etc.)
- Search functionality for finding specific campsites
- Price information with proper formatting

### 🗺️ Interactive Map
- Google Maps integration with campsite markers
- Real-time coordinate transformation for accurate positioning
- Zoom and pan functionality
- Info windows with campsite details

### 📱 Modern UI/UX
- Clean Material Design interface
- Responsive layout for different screen sizes
- Smooth navigation with GoRouter
- Loading states and error handling

### 🏗️ Architecture
- **Clean Architecture** with proper separation of concerns
- **Riverpod** for state management
- **Freezed** for immutable data classes
- **GoRouter** for navigation
- **Google Maps Flutter** for map functionality

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── router/
│   └── utils/
├── features/
│   └── campsites/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── providers/
│           ├── screens/
│           ├── viewmodels/
│           └── widgets/
├── shared/
│   ├── theme/
│   └── widgets/
└── main.dart
```

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Google Maps API Key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/FahadKhalid/RoadSurfer.git
   cd RoadSurfer
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Google Maps API Key**
   
   For Web:
   - Add your API key to `web/index.html`:
   ```html
   <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY"></script>
   ```
   
   For Android:
   - Add to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data
     android:name="com.google.android.geo.API_KEY"
     android:value="YOUR_API_KEY"/>
   ```
   
   For iOS:
   - Add to `ios/Runner/AppDelegate.swift`:
   ```swift
   GMSServices.provideAPIKey("YOUR_API_KEY")
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## API Integration

The app integrates with a mock API for campsite data:
- **Base URL**: `https://62ed0389a785760e67622eb2.mockapi.io/spots/v1/campsites`
- **Features**: Automatic coordinate transformation for accurate map positioning
- **Error Handling**: Robust error handling with fallback values

## Testing

Run the test suite:
```bash
flutter test
```
