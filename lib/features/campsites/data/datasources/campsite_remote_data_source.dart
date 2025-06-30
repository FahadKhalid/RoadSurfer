import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../models/campsite_model.dart';

abstract class CampsiteRemoteDataSource {
  Future<List<CampsiteModel>> getCampsites();
}

class CampsiteRemoteDataSourceImpl implements CampsiteRemoteDataSource {
  final http.Client client;

  CampsiteRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CampsiteModel>> getCampsites() async {
    try {
      final response = await client.get(Uri.parse(ApiConstants.campsitesUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<CampsiteModel> campsites = [];
        for (int i = 0; i < jsonList.length; i++) {
          try {
            final campsite = CampsiteModel.fromJson(jsonList[i]);
            campsites.add(campsite);
          } catch (e) {
            try {
              final fallbackCampsite = _createFallbackCampsite(jsonList[i], i.toString());
              campsites.add(fallbackCampsite);
            } catch (fallbackError) {
              // skip if fallback also fails
            }
          }
        }
        return campsites;
      } else {
        throw Exception('${AppStrings.failedToLoadCampsites}: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('${AppStrings.failedToLoadCampsites}: $e');
    }
  }

  // Create a fallback campsite when the API structure changes
  CampsiteModel _createFallbackCampsite(Map<String, dynamic> json, String fallbackId) {
    return CampsiteModel(
      id: json['id']?.toString() ?? fallbackId,
      label: json['label']?.toString() ?? 
             json['name']?.toString() ?? 
             json['title']?.toString() ?? 
             '${AppStrings.campsitePrefix} $fallbackId',
      geoLocation: GeoLocationModel(
        latitude: _extractDouble(json, ['lat', 'latitude']),
        longitude: _extractDouble(json, ['long', 'longitude', 'lng']),
      ),
      country: json['country']?.toString(),
      closeToWater: _extractBool(json, ['isCloseToWater', 'closeToWater']),
      campFireAllowed: _extractBool(json, ['isCampFireAllowed', 'campFireAllowed']),
      hostLanguages: _extractStringList(json, ['hostLanguages', 'languages']),
      pricePerNight: _extractDouble(json, ['pricePerNight', 'price', 'cost']),
      photo: json['photo']?.toString() ?? 
             json['image']?.toString() ?? 
             json['picture']?.toString() ?? 
             AppStrings.placeholderImageUrl,
    );
  }

  double? _extractDouble(Map<String, dynamic> json, List<String> possibleKeys) {
    for (final key in possibleKeys) {
      final value = json[key];
      if (value != null) {
        if (value is num) return value.toDouble();
        if (value is String) {
          final parsed = double.tryParse(value);
          if (parsed != null) return parsed;
        }
      }
    }
    return null;
  }

  bool? _extractBool(Map<String, dynamic> json, List<String> possibleKeys) {
    for (final key in possibleKeys) {
      final value = json[key];
      if (value != null) {
        if (value is bool) return value;
        if (value is String) {
          final lower = value.toLowerCase();
          if (lower == AppStrings.trueValue || lower == AppStrings.oneValue) return true;
          if (lower == AppStrings.falseValue || lower == AppStrings.zeroValue) return false;
        }
        if (value is num) return value != 0;
      }
    }
    return null;
  }

  List<String>? _extractStringList(Map<String, dynamic> json, List<String> possibleKeys) {
    for (final key in possibleKeys) {
      final value = json[key];
      if (value != null && value is List) {
        final strings = <String>[];
        for (final item in value) {
          if (item != null) {
            strings.add(item.toString());
          }
        }
        if (strings.isNotEmpty) return strings;
      }
    }
    return null;
  }
} 