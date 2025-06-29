import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
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
      print('Fetching campsites from: ${ApiConstants.campsitesUrl}');
      final response = await client.get(Uri.parse(ApiConstants.campsitesUrl));
      
      print('Response status: ${response.statusCode}');
      print('Response body preview: ${response.body.substring(0, response.body.length > 300 ? 300 : response.body.length)}...');
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        print('Parsed ${jsonList.length} campsites from API');
        
        // Log the structure of the first campsite for debugging
        if (jsonList.isNotEmpty) {
          print('First campsite structure: ${jsonList.first.keys.toList()}');
        }
        
        final List<CampsiteModel> campsites = [];
        int successCount = 0;
        int errorCount = 0;
        
        for (int i = 0; i < jsonList.length; i++) {
          try {
            final campsite = CampsiteModel.fromJson(jsonList[i]);
            campsites.add(campsite);
            successCount++;
          } catch (e) {
            errorCount++;
            print('Error parsing campsite at index $i: $e');
            print('Campsite data: ${jsonList[i]}');
            
            // Try to create a minimal campsite with available data
            try {
              final fallbackCampsite = _createFallbackCampsite(jsonList[i], i.toString());
              campsites.add(fallbackCampsite);
              print('Created fallback campsite for index $i');
            } catch (fallbackError) {
              print('Failed to create fallback campsite for index $i: $fallbackError');
            }
          }
        }
        
        print('Successfully parsed $successCount campsites, $errorCount errors');
        return campsites;
      } else {
        throw Exception('Failed to load campsites: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching campsites: $e');
      throw Exception('Failed to load campsites: $e');
    }
  }

  // Create a fallback campsite when the API structure changes
  CampsiteModel _createFallbackCampsite(Map<String, dynamic> json, String fallbackId) {
    return CampsiteModel(
      id: json['id']?.toString() ?? fallbackId,
      label: json['label']?.toString() ?? 
             json['name']?.toString() ?? 
             json['title']?.toString() ?? 
             'Campsite $fallbackId',
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
             'https://via.placeholder.com/640/480?text=Campsite',
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
          if (lower == 'true' || lower == '1') return true;
          if (lower == 'false' || lower == '0') return false;
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