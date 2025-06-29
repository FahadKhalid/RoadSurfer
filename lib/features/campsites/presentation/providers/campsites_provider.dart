import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/campsite.dart';
import '../../domain/entities/filter_criteria.dart';
import '../../domain/usecases/get_campsites_usecase.dart';
import '../../domain/usecases/get_campsite_by_id_usecase.dart';

part 'campsites_provider.g.dart';

@riverpod
class CampsitesNotifier extends _$CampsitesNotifier {
  @override
  Future<List<Campsite>> build() async {
    final useCase = ref.read(getCampsitesUseCaseProvider);
    return await useCase();
  }

  Future<void> refreshCampsites() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(getCampsitesUseCaseProvider);
      return await useCase();
    });
  }

  Future<void> filterCampsites(FilterCriteria criteria) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(getCampsitesUseCaseProvider);
      return await useCase(criteria);
    });
  }
}

@riverpod
Future<Campsite?> campsiteById(CampsiteByIdRef ref, String id) async {
  final useCase = ref.read(getCampsiteByIdUseCaseProvider);
  return await useCase(id);
}

@riverpod
class FilterNotifier extends _$FilterNotifier {
  @override
  FilterCriteria build() {
    return const FilterCriteria();
  }

  void updateFilter(FilterCriteria newFilter) {
    state = newFilter;
  }

  void clearFilters() {
    state = const FilterCriteria();
  }

  void updateCountry(String? country) {
    state = state.copyWith(country: country);
  }

  void updateCloseToWater(bool? closeToWater) {
    state = state.copyWith(closeToWater: closeToWater);
  }

  void updateCampFireAllowed(bool? campFireAllowed) {
    state = state.copyWith(campFireAllowed: campFireAllowed);
  }

  void updateHostLanguage(String? hostLanguage) {
    state = state.copyWith(hostLanguage: hostLanguage);
  }

  void updatePriceRange(double? minPrice, double? maxPrice) {
    state = state.copyWith(minPrice: minPrice, maxPrice: maxPrice);
  }

  void updateSearchQuery(String? searchQuery) {
    state = state.copyWith(searchQuery: searchQuery);
  }
} 