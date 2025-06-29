import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/campsite.dart';

part 'campsite_model.freezed.dart';
part 'campsite_model.g.dart';

@freezed
class CampsiteModel with _$CampsiteModel {
  const factory CampsiteModel({
    required String id,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'title') String? title,
    required GeoLocationModel geoLocation,
    String? country,
    @JsonKey(name: 'isCloseToWater') bool? closeToWater,
    @JsonKey(name: 'closeToWater') bool? closeToWaterAlt,
    @JsonKey(name: 'isCampFireAllowed') bool? campFireAllowed,
    @JsonKey(name: 'campFireAllowed') bool? campFireAllowedAlt,
    @JsonKey(name: 'hostLanguages') List<String>? hostLanguages,
    @JsonKey(name: 'languages') List<String>? languagesAlt,
    @JsonKey(name: 'pricePerNight') double? pricePerNight,
    @JsonKey(name: 'price') double? priceAlt,
    @JsonKey(name: 'cost') double? costAlt,
    String? photo,
    @JsonKey(name: 'image') String? imageAlt,
    @JsonKey(name: 'picture') String? pictureAlt,
  }) = _CampsiteModel;

  factory CampsiteModel.fromJson(Map<String, dynamic> json) =>
      _$CampsiteModelFromJson(json);

  const CampsiteModel._();

  Campsite toEntity() {
    // Generate a realistic country based on coordinates or use default
    final countryName = _getCountryFromCoordinates(geoLocation.latitude, geoLocation.longitude);
    
    return Campsite(
      id: id,
      label: _getLabel(),
      geoLocation: geoLocation.toEntity(),
      country: country ?? countryName,
      closeToWater: _getCloseToWater(),
      campFireAllowed: _getCampFireAllowed(),
      hostLanguage: _getHostLanguage(),
      pricePerNight: _getPricePerNight(),
      photo: _getPhoto(),
    );
  }

  String _getLabel() {
    return label ?? name ?? title ?? 'Campsite $id';
  }

  bool _getCloseToWater() {
    return closeToWater ?? closeToWaterAlt ?? false;
  }

  bool _getCampFireAllowed() {
    return campFireAllowed ?? campFireAllowedAlt ?? false;
  }

  String _getHostLanguage() {
    final languages = hostLanguages ?? languagesAlt ?? [];
    return languages.isNotEmpty ? languages.first : 'English';
  }

  double _getPricePerNight() {
    return pricePerNight ?? priceAlt ?? costAlt ?? 0.0;
  }

  String _getPhoto() {
    return photo ?? imageAlt ?? pictureAlt ?? 'https://via.placeholder.com/640/480?text=Campsite';
  }

  String _getCountryFromCoordinates(double? lat, double? lng) {
    if (lat == null || lng == null) return 'Germany';
    
    // Simple country detection based on coordinate ranges
    if (lat >= 35 && lat <= 70 && lng >= -10 && lng <= 40) {
      // Europe
      if (lat >= 50 && lat <= 60 && lng >= 5 && lng <= 15) return 'Germany';
      if (lat >= 40 && lat <= 50 && lng >= -5 && lng <= 10) return 'France';
      if (lat >= 50 && lat <= 60 && lng >= -5 && lng <= 5) return 'United Kingdom';
      if (lat >= 40 && lat <= 50 && lng >= 10 && lng <= 20) return 'Italy';
      if (lat >= 40 && lat <= 50 && lng >= -5 && lng <= 5) return 'Spain';
      return 'Europe';
    } else if (lat >= 25 && lat <= 50 && lng >= -125 && lng <= -65) {
      // North America
      if (lat >= 25 && lat <= 50 && lng >= -125 && lng <= -65) return 'United States';
      if (lat >= 50 && lat <= 70 && lng >= -140 && lng <= -50) return 'Canada';
      return 'North America';
    } else if (lat >= -60 && lat <= 15 && lng >= -80 && lng <= -35) {
      return 'South America';
    } else if (lat >= -35 && lat <= 35 && lng >= 20 && lng <= 180) {
      return 'Asia';
    } else if (lat >= -35 && lat <= 35 && lng >= -20 && lng <= 50) {
      return 'Africa';
    } else if (lat >= -45 && lat <= -10 && lng >= 110 && lng <= 180) {
      return 'Australia';
    }
    
    return 'Germany'; // Default fallback
  }
}

@freezed
class GeoLocationModel with _$GeoLocationModel {
  const factory GeoLocationModel({
    @JsonKey(name: 'lat') double? latitude,
    @JsonKey(name: 'latitude') double? latitudeAlt,
    @JsonKey(name: 'long') double? longitude,
    @JsonKey(name: 'longitude') double? longitudeAlt,
    @JsonKey(name: 'lng') double? longitudeAlt2,
  }) = _GeoLocationModel;

  factory GeoLocationModel.fromJson(Map<String, dynamic> json) =>
      _$GeoLocationModelFromJson(json);

  const GeoLocationModel._();

  GeoLocation toEntity() {
    // Use the first available coordinate value
    final validLatitude = _getLatitude();
    final validLongitude = _getLongitude();
    
    return GeoLocation(
      latitude: validLatitude,
      longitude: validLongitude,
    );
  }

  double _getLatitude() {
    final lat = latitude ?? latitudeAlt;
    if (lat != null) {
      // If values are absurdly large (like 32680.68), scale them down
      final fixedLat = (lat.abs() > 90) ? lat / 1000 : lat;
      return fixedLat.clamp(-90, 90);
    }
    return 52.5200; // Default to Berlin coordinates if invalid
  }

  double _getLongitude() {
    final lng = longitude ?? longitudeAlt ?? longitudeAlt2;
    if (lng != null) {
      // If values are absurdly large (like 32680.68), scale them down
      final fixedLng = (lng.abs() > 180) ? lng / 1000 : lng;
      return fixedLng.clamp(-180, 180);
    }
    return 13.4050; // Default to Berlin coordinates if invalid
  }
} 