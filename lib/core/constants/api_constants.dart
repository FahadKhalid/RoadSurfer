class ApiConstants {
  // Base URLs for different environments
  static const String mockApiBaseUrl = 'https://62ed0389a785760e67622eb2.mockapi.io';
  static const String stagingApiBaseUrl = 'https://api-staging.roadsurfer.com'; // Example staging URL
  static const String productionApiBaseUrl = 'https://api.roadsurfer.com'; // Example production URL
  
  // API version - can be easily changed when API structure updates
  static const String apiVersion = 'v1';
  
  // Endpoints
  static const String campsitesEndpoint = '/spots/$apiVersion/campsites';
  
  // Current active base URL - change this to switch between environments
  static const String currentBaseUrl = mockApiBaseUrl;
  
  // Full URL getters
  static String get campsitesUrl => '$currentBaseUrl$campsitesEndpoint';
  
  // API configuration
  static const int requestTimeoutSeconds = 30;
  static const int maxRetries = 3;
  
  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Debug mode - set to true to see detailed API logs
  static const bool debugMode = true;
} 