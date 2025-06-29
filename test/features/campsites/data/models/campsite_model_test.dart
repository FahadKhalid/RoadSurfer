import 'package:flutter_test/flutter_test.dart';
import 'package:roadsurfer_task/features/campsites/data/models/campsite_model.dart';

void main() {
  group('CampsiteModel', () {
    test('should create CampsiteModel from JSON with standard fields', () {
      final json = {
        'id': '1',
        'label': 'Test Campsite',
        'geoLocation': {
          'lat': 52.5200,
          'long': 13.4050,
        },
        'country': 'Germany',
        'isCloseToWater': true,
        'isCampFireAllowed': false,
        'hostLanguages': ['en', 'de'],
        'pricePerNight': 25.0,
        'photo': 'https://example.com/photo.jpg',
      };

      final campsiteModel = CampsiteModel.fromJson(json);

      expect(campsiteModel.id, '1');
      expect(campsiteModel.label, 'Test Campsite');
      expect(campsiteModel.country, 'Germany');
      expect(campsiteModel.closeToWater, true);
      expect(campsiteModel.campFireAllowed, false);
      expect(campsiteModel.hostLanguages, ['en', 'de']);
      expect(campsiteModel.pricePerNight, 25.0);
      expect(campsiteModel.photo, 'https://example.com/photo.jpg');
    });

    test('should handle alternative field names for label', () {
      final jsonWithName = {
        'id': '1',
        'name': 'Alternative Name',
        'geoLocation': {'lat': 52.5200, 'long': 13.4050},
      };

      final jsonWithTitle = {
        'id': '2',
        'title': 'Alternative Title',
        'geoLocation': {'lat': 52.5200, 'long': 13.4050},
      };

      final campsiteWithName = CampsiteModel.fromJson(jsonWithName);
      final campsiteWithTitle = CampsiteModel.fromJson(jsonWithTitle);

      expect(campsiteWithName.name, 'Alternative Name');
      expect(campsiteWithTitle.title, 'Alternative Title');
    });

    test('should handle alternative field names for boolean fields', () {
      final json = {
        'id': '1',
        'geoLocation': {'lat': 52.5200, 'long': 13.4050},
        'closeToWater': true,
        'campFireAllowed': false,
      };

      final campsiteModel = CampsiteModel.fromJson(json);

      expect(campsiteModel.closeToWaterAlt, true);
      expect(campsiteModel.campFireAllowedAlt, false);
    });

    test('should handle alternative field names for price', () {
      final jsonWithPrice = {
        'id': '1',
        'geoLocation': {'lat': 52.5200, 'long': 13.4050},
        'price': 30.0,
      };

      final jsonWithCost = {
        'id': '2',
        'geoLocation': {'lat': 52.5200, 'long': 13.4050},
        'cost': 40.0,
      };

      final campsiteWithPrice = CampsiteModel.fromJson(jsonWithPrice);
      final campsiteWithCost = CampsiteModel.fromJson(jsonWithCost);

      expect(campsiteWithPrice.priceAlt, 30.0);
      expect(campsiteWithCost.costAlt, 40.0);
    });

    test('should handle alternative field names for photo', () {
      final jsonWithImage = {
        'id': '1',
        'geoLocation': {'lat': 52.5200, 'long': 13.4050},
        'image': 'https://example.com/image.jpg',
      };

      final jsonWithPicture = {
        'id': '2',
        'geoLocation': {'lat': 52.5200, 'long': 13.4050},
        'picture': 'https://example.com/picture.jpg',
      };

      final campsiteWithImage = CampsiteModel.fromJson(jsonWithImage);
      final campsiteWithPicture = CampsiteModel.fromJson(jsonWithPicture);

      expect(campsiteWithImage.imageAlt, 'https://example.com/image.jpg');
      expect(campsiteWithPicture.pictureAlt, 'https://example.com/picture.jpg');
    });

    test('should convert to entity with fallback values', () {
      final json = {
        'id': '1',
        'geoLocation': {'lat': 52.5200, 'long': 13.4050},
      };

      final campsiteModel = CampsiteModel.fromJson(json);
      final entity = campsiteModel.toEntity();

      expect(entity.id, '1');
      expect(entity.label, 'Campsite 1'); // Fallback label
      expect(entity.closeToWater, false); // Default value
      expect(entity.campFireAllowed, false); // Default value
      expect(entity.hostLanguage, 'English'); // Default value
      expect(entity.pricePerNight, 0.0); // Default value
      expect(entity.photo, 'https://via.placeholder.com/640/480?text=Campsite'); // Fallback photo
    });

    test('should use helper methods to get correct values', () {
      final json = {
        'id': '1',
        'name': 'Test Name',
        'title': 'Test Title',
        'geoLocation': {'lat': 52.5200, 'long': 13.4050},
        'closeToWater': true,
        'campFireAllowed': false,
        'languages': ['fr', 'en'],
        'price': 50.0,
        'image': 'https://example.com/image.jpg',
      };

      final campsiteModel = CampsiteModel.fromJson(json);
      final entity = campsiteModel.toEntity();

      expect(entity.label, 'Test Name'); // Should use 'name' field
      expect(entity.closeToWater, true); // Should use 'closeToWater' field
      expect(entity.campFireAllowed, false); // Should use 'campFireAllowed' field
      expect(entity.hostLanguage, 'fr'); // Should use first language from 'languages'
      expect(entity.pricePerNight, 50.0); // Should use 'price' field
      expect(entity.photo, 'https://example.com/image.jpg'); // Should use 'image' field
    });
  });

  group('GeoLocationModel', () {
    test('should create GeoLocationModel from JSON with standard fields', () {
      final json = {
        'lat': 52.5200,
        'long': 13.4050,
      };

      final geoLocationModel = GeoLocationModel.fromJson(json);

      expect(geoLocationModel.latitude, 52.5200);
      expect(geoLocationModel.longitude, 13.4050);
    });

    test('should handle alternative field names for coordinates', () {
      final jsonWithLatitude = {
        'latitude': 52.5200,
        'longitude': 13.4050,
      };

      final jsonWithLng = {
        'lat': 52.5200,
        'lng': 13.4050,
      };

      final geoLocationWithLatitude = GeoLocationModel.fromJson(jsonWithLatitude);
      final geoLocationWithLng = GeoLocationModel.fromJson(jsonWithLng);

      expect(geoLocationWithLatitude.latitudeAlt, 52.5200);
      expect(geoLocationWithLatitude.longitudeAlt, 13.4050);
      expect(geoLocationWithLng.longitudeAlt2, 13.4050);
    });

    test('should convert to entity with valid coordinates', () {
      final json = {
        'lat': 52.5200,
        'long': 13.4050,
      };

      final geoLocationModel = GeoLocationModel.fromJson(json);
      final entity = geoLocationModel.toEntity();

      expect(entity.latitude, 52.5200);
      expect(entity.longitude, 13.4050);
    });

    test('should use fallback coordinates for invalid values', () {
      final jsonWithInvalidLat = {
        'lat': 200.0, // Invalid latitude
        'long': 13.4050,
      };

      final jsonWithInvalidLong = {
        'lat': 52.5200,
        'long': 300.0, // Invalid longitude
      };

      final geoLocationWithInvalidLat = GeoLocationModel.fromJson(jsonWithInvalidLat);
      final geoLocationWithInvalidLong = GeoLocationModel.fromJson(jsonWithInvalidLong);

      final entityWithInvalidLat = geoLocationWithInvalidLat.toEntity();
      final entityWithInvalidLong = geoLocationWithInvalidLong.toEntity();

      expect(entityWithInvalidLat.latitude, 52.5200); // Default to Berlin
      expect(entityWithInvalidLong.longitude, 13.4050); // Default to Berlin
    });

    test('should handle null coordinates', () {
      final json = {
        'lat': null,
        'long': null,
      };

      final geoLocationModel = GeoLocationModel.fromJson(json);
      final entity = geoLocationModel.toEntity();

      expect(entity.latitude, 52.5200); // Default to Berlin
      expect(entity.longitude, 13.4050); // Default to Berlin
    });
  });
} 