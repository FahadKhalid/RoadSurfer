class AppStrings {
  // App
  static const String appTitle = 'Roadsurfer Campsites';
  static const String defaultLocale = 'en';
  static const String defaultCountry = 'US';

  // Navigation
  static const String homeRoute = '/';
  static const String mapRoute = '/map';
  static const String campsiteDetailRoute = '/campsite/:id';

  // Home Screen
  static const String homeTitle = 'Campsites';
  static const String noCampsitesFound = 'No campsites found';
  static const String errorLoadingCampsites = 'Error loading campsites';
  static const String retry = 'Retry';

  // Map Screen
  static const String mapTitle = 'Campsites Map';
  static const String errorLoadingMap = 'Error loading map';
  static const String noValidCoordinates = 'No campsites with valid coordinates found';
  static const String campsitesCount = 'Campsites';

  // Campsite Detail Screen
  static const String detailTitle = 'Campsite Details';
  static const String campsiteNotFound = 'Campsite not found';

  // Search
  static const String searchHint = 'Search campsites...';

  // Filter
  static const String filterTitle = 'Filter Campsites';
  static const String country = 'Country';
  static const String countryHint = 'Enter country name';
  static const String hostLanguage = 'Host Language';
  static const String languageHint = 'Enter language';
  static const String priceRange = 'Price Range (€)';
  static const String minPriceHint = 'Min';
  static const String maxPriceHint = 'Max';
  static const String features = 'Features';
  static const String closeToWater = 'Close to Water';
  static const String campfireAllowed = 'Campfire Allowed';
  static const String clear = 'Clear';
  static const String apply = 'Apply';

  // Campsite Card
  static const String water = 'Water';
  static const String fire = 'Fire';
  static const String campsitePrefix = 'Campsite';

  // Coordinates
  static const String latitudeLabel = 'Lat';
  static const String longitudeLabel = 'Lng';

  // Currency
  static const String euroSymbol = '€';

  // API
  static const String failedToLoadCampsites = 'Failed to load campsites';
  static const String placeholderImageUrl = 'https://via.placeholder.com/640/480?text=Campsite';

  // Boolean values
  static const String trueValue = 'true';
  static const String falseValue = 'false';
  static const String oneValue = '1';
  static const String zeroValue = '0';
} 