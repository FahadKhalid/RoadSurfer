import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../entities/campsite.dart';
import '../entities/filter_criteria.dart';
import '../repositories/campsite_repository.dart';
import '../../data/repositories/campsite_repository_impl.dart';

part 'get_campsites_usecase.g.dart';

class GetCampsitesUseCase {
  final CampsiteRepository repository;

  GetCampsitesUseCase(this.repository);

  Future<List<Campsite>> call([FilterCriteria? criteria]) async {
    if (criteria != null && criteria.hasActiveFilters) {
      return await repository.getFilteredCampsites(criteria);
    }
    return await repository.getCampsites();
  }
}

@riverpod
GetCampsitesUseCase getCampsitesUseCase(GetCampsitesUseCaseRef ref) {
  final repository = ref.watch(campsiteRepositoryProvider);
  return GetCampsitesUseCase(repository);
} 