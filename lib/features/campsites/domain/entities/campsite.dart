import 'package:freezed_annotation/freezed_annotation.dart';

part 'campsite.freezed.dart';
part 'campsite.g.dart';

@freezed
class Campsite with _$Campsite {
  const factory Campsite({
    required String id,
    required String label,
    required GeoLocation geoLocation,
    required String country,
    required bool closeToWater,
    required bool campFireAllowed,
    required String hostLanguage,
    required double pricePerNight,
    required String photo,
  }) = _Campsite;

  factory Campsite.fromJson(Map<String, dynamic> json) =>
      _$CampsiteFromJson(json);
}

@freezed
class GeoLocation with _$GeoLocation {
  const factory GeoLocation({
    required double latitude,
    required double longitude,
  }) = _GeoLocation;

  factory GeoLocation.fromJson(Map<String, dynamic> json) =>
      _$GeoLocationFromJson(json);
} 