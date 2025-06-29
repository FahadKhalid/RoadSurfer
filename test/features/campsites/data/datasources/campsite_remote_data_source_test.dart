import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:roadsurfer_task/features/campsites/data/datasources/campsite_remote_data_source.dart';
import 'package:roadsurfer_task/features/campsites/data/models/campsite_model.dart';

import 'campsite_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late CampsiteRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = CampsiteRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getCampsites', () {
    const tUrl = 'https://62ed0389a785760e67622eb2.mockapi.io/spots/v1/campsites';

    test('should return list of CampsiteModel when HTTP call is successful', () async {
      // arrange
      final tCampsitesJson = [
        {
          'id': '1',
          'label': 'Test Campsite 1',
          'geoLocation': {'lat': 52.5200, 'long': 13.4050},
          'country': 'Germany',
          'isCloseToWater': true,
          'isCampFireAllowed': false,
          'hostLanguages': ['en', 'de'],
          'pricePerNight': 25.0,
          'photo': 'https://example.com/photo1.jpg',
        },
        {
          'id': '2',
          'label': 'Test Campsite 2',
          'geoLocation': {'lat': 48.8566, 'long': 2.3522},
          'country': 'France',
          'isCloseToWater': false,
          'isCampFireAllowed': true,
          'hostLanguages': ['fr', 'en'],
          'pricePerNight': 30.0,
          'photo': 'https://example.com/photo2.jpg',
        },
      ];

      when(mockHttpClient.get(Uri.parse(tUrl)))
          .thenAnswer((_) async => http.Response(json.encode(tCampsitesJson), 200));

      // act
      final result = await dataSource.getCampsites();

      // assert
      expect(result, isA<List<CampsiteModel>>());
      expect(result.length, 2);
      expect(result[0].id, '1');
      expect(result[0].label, 'Test Campsite 1');
      expect(result[1].id, '2');
      expect(result[1].label, 'Test Campsite 2');
      verify(mockHttpClient.get(Uri.parse(tUrl)));
    });

    test('should handle alternative field names in JSON response', () async {
      // arrange
      final tCampsitesJson = [
        {
          'id': '1',
          'name': 'Alternative Name',
          'geoLocation': {'latitude': 52.5200, 'longitude': 13.4050},
          'closeToWater': true,
          'campFireAllowed': false,
          'languages': ['en', 'de'],
          'price': 25.0,
          'image': 'https://example.com/image.jpg',
        },
      ];

      when(mockHttpClient.get(Uri.parse(tUrl)))
          .thenAnswer((_) async => http.Response(json.encode(tCampsitesJson), 200));

      // act
      final result = await dataSource.getCampsites();

      // assert
      expect(result.length, 1);
      expect(result[0].name, 'Alternative Name');
      expect(result[0].closeToWaterAlt, true);
      expect(result[0].campFireAllowedAlt, false);
      expect(result[0].languagesAlt, ['en', 'de']);
      expect(result[0].priceAlt, 25.0);
      expect(result[0].imageAlt, 'https://example.com/image.jpg');
    });

    test('should create fallback campsites when JSON parsing fails', () async {
      // arrange
      final tCampsitesJson = [
        {
          'id': '1',
          'label': 'Valid Campsite',
          'geoLocation': {'lat': 52.5200, 'long': 13.4050},
          'isCloseToWater': true,
          'isCampFireAllowed': false,
          'hostLanguages': ['en', 'de'],
          'pricePerNight': 25.0,
          'photo': 'https://example.com/photo.jpg',
        },
        {
          'id': '2',
          // Missing required fields to cause parsing error
          'geoLocation': {'lat': 48.8566, 'long': 2.3522},
        },
      ];

      when(mockHttpClient.get(Uri.parse(tUrl)))
          .thenAnswer((_) async => http.Response(json.encode(tCampsitesJson), 200));

      // act
      final result = await dataSource.getCampsites();

      // assert
      expect(result.length, 2);
      expect(result[0].id, '1');
      expect(result[0].label, 'Valid Campsite');
      expect(result[1].id, '2'); // Fallback campsite should still have the ID
    });

    test('should handle mixed data types in JSON response', () async {
      // arrange
      final tCampsitesJson = [
        {
          'id': '1',
          'label': 'Test Campsite',
          'geoLocation': {'lat': 52.5200, 'long': 13.4050},
          'isCloseToWater': 'true', // String instead of boolean
          'isCampFireAllowed': 0, // Number instead of boolean
          'hostLanguages': ['en', 'de'],
          'pricePerNight': '25.5', // String instead of number
          'photo': 'https://example.com/photo.jpg',
        },
      ];

      when(mockHttpClient.get(Uri.parse(tUrl)))
          .thenAnswer((_) async => http.Response(json.encode(tCampsitesJson), 200));

      // act
      final result = await dataSource.getCampsites();

      // assert
      expect(result.length, 1);
      expect(result[0].id, '1');
      expect(result[0].label, 'Test Campsite');
    });

    test('should throw Exception when HTTP call is unsuccessful', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse(tUrl)))
          .thenAnswer((_) async => http.Response('Server Error', 500));

      // act & assert
      expect(
        () => dataSource.getCampsites(),
        throwsA(isA<Exception>()),
      );
      verify(mockHttpClient.get(Uri.parse(tUrl)));
    });

    test('should throw Exception when HTTP call throws an exception', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse(tUrl)))
          .thenThrow(Exception('Network Error'));

      // act & assert
      expect(
        () => dataSource.getCampsites(),
        throwsA(isA<Exception>()),
      );
      verify(mockHttpClient.get(Uri.parse(tUrl)));
    });

    test('should handle empty JSON response', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse(tUrl)))
          .thenAnswer((_) async => http.Response('[]', 200));

      // act
      final result = await dataSource.getCampsites();

      // assert
      expect(result, isEmpty);
      verify(mockHttpClient.get(Uri.parse(tUrl)));
    });

    test('should handle malformed JSON response', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse(tUrl)))
          .thenAnswer((_) async => http.Response('invalid json', 200));

      // act & assert
      expect(
        () => dataSource.getCampsites(),
        throwsA(isA<Exception>()),
      );
      verify(mockHttpClient.get(Uri.parse(tUrl)));
    });
  });
} 