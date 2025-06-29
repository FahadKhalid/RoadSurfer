# RoadSurfer - Campsite Discovery App

A Flutter application for discovering and exploring campsites across Europe. Built with modern Flutter architecture using Riverpod for state management and Google Maps integration.

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
│   │   └── api_constants.dart
│   ├── router/
│   │   └── app_router.dart
│   └── utils/
│       └── price_formatter.dart
├── features/
│   └── campsites/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── campsite_remote_data_source.dart
│       │   ├── models/
│       │   │   ├── campsite_model.dart
│       │   │   ├── campsite_model.freezed.dart
│       │   │   └── campsite_model.g.dart
│       │   └── repositories/
│       │       ├── campsite_repository_impl.dart
│       │       └── campsite_repository_impl.g.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── campsite.dart
│       │   │   ├── campsite.freezed.dart
│       │   │   ├── campsite.g.dart
│       │   │   ├── filter_criteria.dart
│       │   │   └── filter_criteria.freezed.dart
│       │   ├── repositories/
│       │   │   └── campsite_repository.dart
│       │   └── usecases/
│       │       ├── get_campsite_by_id_usecase.dart
│       │       ├── get_campsite_by_id_usecase.g.dart
│       │       ├── get_campsites_usecase.dart
│       │       └── get_campsites_usecase.g.dart
│       └── presentation/
│           ├── providers/
│           │   ├── campsites_provider.dart
│           │   └── campsites_provider.g.dart
│           ├── screens/
│           │   ├── campsite_detail_screen.dart
│           │   ├── home_screen.dart
│           │   └── map_screen.dart
│           ├── viewmodels/
│           │   └── campsites_viewmodel.dart
│           └── widgets/
│               ├── campsite_card.dart
│               ├── feature_chip.dart
│               ├── filter_bottom_sheet.dart
│               └── search_bar_widget.dart
├── shared/
│   ├── theme/
│   │   └── app_theme.dart
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

### Coordinate Transformation

The app includes intelligent coordinate transformation to handle API data with scaled coordinates:
```dart
LatLng fixCoordinates(double rawLat, double rawLong) {
  // If values are absurdly large (like 32680.68), scale them down
  final lat = (rawLat.abs() > 90) ? rawLat / 1000 : rawLat;
  final long = (rawLong.abs() > 180) ? rawLong / 1000 : rawLong;
  
  // Clamp to valid ranges
  return LatLng(
    lat.clamp(-90, 90),
    long.clamp(-180, 180),
  );
}
```

## Testing

Run the test suite:
```bash
flutter test
```

The project includes comprehensive unit tests for:
- Data models
- Data sources
- Use cases
- Widgets

## Dependencies

### Core Dependencies
- `flutter_riverpod`: State management
- `go_router`: Navigation
- `google_maps_flutter`: Map integration
- `freezed`: Immutable data classes
- `json_annotation`: JSON serialization

### Development Dependencies
- `build_runner`: Code generation
- `freezed`: Code generation for immutable classes
- `json_serializable`: JSON serialization code generation
- `riverpod_generator`: Riverpod code generation
- `mockito`: Mocking for tests

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Riverpod for excellent state management
- Google Maps for map integration
- MockAPI for providing test data

## Contact

Fahad Khalid - [@FahadKhalid](https://github.com/FahadKhalid)

Project Link: [https://github.com/FahadKhalid/RoadSurfer](https://github.com/FahadKhalid/RoadSurfer)
