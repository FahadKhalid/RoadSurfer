import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:roadsurfer_task/features/campsites/domain/entities/campsite.dart';
import 'package:roadsurfer_task/features/campsites/domain/entities/filter_criteria.dart';
import 'package:roadsurfer_task/features/campsites/domain/repositories/campsite_repository.dart';
import 'package:roadsurfer_task/features/campsites/domain/usecases/get_campsites_usecase.dart';

import 'get_campsites_usecase_test.mocks.dart';

@GenerateMocks([CampsiteRepository])
void main() {
  late GetCampsitesUseCase useCase;
  late MockCampsiteRepository mockRepository;

  setUp(() {
    mockRepository = MockCampsiteRepository();
    useCase = GetCampsitesUseCase(mockRepository);
  });

  final tCampsites = [
    const Campsite(
      id: '1',
      label: 'Test Campsite 1',
      geoLocation: GeoLocation(latitude: 52.5200, longitude: 13.4050),
      country: 'Germany',
      closeToWater: true,
      campFireAllowed: false,
      hostLanguage: 'German',
      pricePerNight: 25.0,
      photo: 'https://example.com/photo1.jpg',
    ),
    const Campsite(
      id: '2',
      label: 'Test Campsite 2',
      geoLocation: GeoLocation(latitude: 48.8566, longitude: 2.3522),
      country: 'France',
      closeToWater: false,
      campFireAllowed: true,
      hostLanguage: 'French',
      pricePerNight: 30.0,
      photo: 'https://example.com/photo2.jpg',
    ),
  ];

  group('GetCampsitesUseCase', () {
    test('should get campsites from repository', () async {
      // arrange
      when(mockRepository.getCampsites())
          .thenAnswer((_) async => tCampsites);

      // act
      final result = await useCase();

      // assert
      expect(result, tCampsites);
      verify(mockRepository.getCampsites());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when repository returns empty list', () async {
      // arrange
      when(mockRepository.getCampsites())
          .thenAnswer((_) async => <Campsite>[]);

      // act
      final result = await useCase();

      // assert
      expect(result, isEmpty);
      verify(mockRepository.getCampsites());
    });

    test('should propagate exception from repository', () async {
      // arrange
      when(mockRepository.getCampsites())
          .thenThrow(Exception('Repository error'));

      // act & assert
      expect(
        () => useCase(),
        throwsA(isA<Exception>()),
      );
      verify(mockRepository.getCampsites());
    });
  });

  group('FilterCriteria', () {
    test('should have active filters when criteria is provided', () {
      const filterCriteria = FilterCriteria(
        country: 'Germany',
        closeToWater: true,
        minPrice: 20.0,
      );

      expect(filterCriteria.hasActiveFilters, true);
    });

    test('should not have active filters when no criteria is provided', () {
      const filterCriteria = FilterCriteria();

      expect(filterCriteria.hasActiveFilters, false);
    });

    test('should not have active filters when search query is empty', () {
      const filterCriteria = FilterCriteria(searchQuery: '');

      expect(filterCriteria.hasActiveFilters, false);
    });

    test('should have active filters when search query is provided', () {
      const filterCriteria = FilterCriteria(searchQuery: 'test');

      expect(filterCriteria.hasActiveFilters, true);
    });

    test('should have active filters when max price is provided', () {
      const filterCriteria = FilterCriteria(maxPrice: 50.0);

      expect(filterCriteria.hasActiveFilters, true);
    });

    test('should have active filters when host language is provided', () {
      const filterCriteria = FilterCriteria(hostLanguage: 'German');

      expect(filterCriteria.hasActiveFilters, true);
    });

    test('should have active filters when campFireAllowed is provided', () {
      const filterCriteria = FilterCriteria(campFireAllowed: true);

      expect(filterCriteria.hasActiveFilters, true);
    });
  });

  group('Campsite Entity', () {
    test('should create campsite with all properties', () {
      const campsite = Campsite(
        id: '1',
        label: 'Test Campsite',
        geoLocation: GeoLocation(latitude: 52.5200, longitude: 13.4050),
        country: 'Germany',
        closeToWater: true,
        campFireAllowed: false,
        hostLanguage: 'German',
        pricePerNight: 25.0,
        photo: 'https://example.com/photo.jpg',
      );

      expect(campsite.id, '1');
      expect(campsite.label, 'Test Campsite');
      expect(campsite.country, 'Germany');
      expect(campsite.closeToWater, true);
      expect(campsite.campFireAllowed, false);
      expect(campsite.hostLanguage, 'German');
      expect(campsite.pricePerNight, 25.0);
      expect(campsite.photo, 'https://example.com/photo.jpg');
    });

    test('should have valid coordinates', () {
      const campsite = Campsite(
        id: '1',
        label: 'Test Campsite',
        geoLocation: GeoLocation(latitude: 52.5200, longitude: 13.4050),
        country: 'Germany',
        closeToWater: true,
        campFireAllowed: false,
        hostLanguage: 'German',
        pricePerNight: 25.0,
        photo: 'https://example.com/photo.jpg',
      );

      expect(campsite.geoLocation.latitude, 52.5200);
      expect(campsite.geoLocation.longitude, 13.4050);
    });

    test('should be equal when all properties are the same', () {
      const campsite1 = Campsite(
        id: '1',
        label: 'Test Campsite',
        geoLocation: GeoLocation(latitude: 52.5200, longitude: 13.4050),
        country: 'Germany',
        closeToWater: true,
        campFireAllowed: false,
        hostLanguage: 'German',
        pricePerNight: 25.0,
        photo: 'https://example.com/photo.jpg',
      );

      const campsite2 = Campsite(
        id: '1',
        label: 'Test Campsite',
        geoLocation: GeoLocation(latitude: 52.5200, longitude: 13.4050),
        country: 'Germany',
        closeToWater: true,
        campFireAllowed: false,
        hostLanguage: 'German',
        pricePerNight: 25.0,
        photo: 'https://example.com/photo.jpg',
      );

      expect(campsite1, equals(campsite2));
    });

    test('should not be equal when properties are different', () {
      const campsite1 = Campsite(
        id: '1',
        label: 'Test Campsite 1',
        geoLocation: GeoLocation(latitude: 52.5200, longitude: 13.4050),
        country: 'Germany',
        closeToWater: true,
        campFireAllowed: false,
        hostLanguage: 'German',
        pricePerNight: 25.0,
        photo: 'https://example.com/photo.jpg',
      );

      const campsite2 = Campsite(
        id: '2',
        label: 'Test Campsite 2',
        geoLocation: GeoLocation(latitude: 52.5200, longitude: 13.4050),
        country: 'Germany',
        closeToWater: true,
        campFireAllowed: false,
        hostLanguage: 'German',
        pricePerNight: 25.0,
        photo: 'https://example.com/photo.jpg',
      );

      expect(campsite1, isNot(equals(campsite2)));
    });
  });

  group('GeoLocation Entity', () {
    test('should create GeoLocation with valid coordinates', () {
      const geoLocation = GeoLocation(latitude: 52.5200, longitude: 13.4050);

      expect(geoLocation.latitude, 52.5200);
      expect(geoLocation.longitude, 13.4050);
    });

    test('should be equal when coordinates are the same', () {
      const geoLocation1 = GeoLocation(latitude: 52.5200, longitude: 13.4050);
      const geoLocation2 = GeoLocation(latitude: 52.5200, longitude: 13.4050);

      expect(geoLocation1, equals(geoLocation2));
    });

    test('should not be equal when coordinates are different', () {
      const geoLocation1 = GeoLocation(latitude: 52.5200, longitude: 13.4050);
      const geoLocation2 = GeoLocation(latitude: 48.8566, longitude: 2.3522);

      expect(geoLocation1, isNot(equals(geoLocation2)));
    });
  });
} 