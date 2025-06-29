import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/campsite.dart';
import '../../domain/entities/filter_criteria.dart';
import '../../domain/repositories/campsite_repository.dart';
import '../datasources/campsite_remote_data_source.dart';

part 'campsite_repository_impl.g.dart';

class CampsiteRepositoryImpl implements CampsiteRepository {
  final CampsiteRemoteDataSource remoteDataSource;

  CampsiteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Campsite>> getCampsites() async {
    final campsiteModels = await remoteDataSource.getCampsites();
    return campsiteModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Campsite>> getFilteredCampsites(FilterCriteria criteria) async {
    final allCampsites = await getCampsites();
    return _applyFilters(allCampsites, criteria);
  }

  @override
  Future<Campsite?> getCampsiteById(String id) async {
    final campsites = await getCampsites();
    try {
      return campsites.firstWhere((campsite) => campsite.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Campsite> _applyFilters(List<Campsite> campsites, FilterCriteria criteria) {
    return campsites.where((campsite) {
      if (criteria.country != null && 
          !campsite.country.toLowerCase().contains(criteria.country!.toLowerCase())) {
        return false;
      }
      
      if (criteria.closeToWater != null && 
          campsite.closeToWater != criteria.closeToWater) {
        return false;
      }
      
      if (criteria.campFireAllowed != null && 
          campsite.campFireAllowed != criteria.campFireAllowed) {
        return false;
      }
      
      if (criteria.hostLanguage != null && 
          !campsite.hostLanguage.toLowerCase().contains(criteria.hostLanguage!.toLowerCase())) {
        return false;
      }
      
      if (criteria.minPrice != null && 
          campsite.pricePerNight < criteria.minPrice!) {
        return false;
      }
      
      if (criteria.maxPrice != null && 
          campsite.pricePerNight > criteria.maxPrice!) {
        return false;
      }
      
      if (criteria.searchQuery != null && criteria.searchQuery!.isNotEmpty) {
        final query = criteria.searchQuery!.toLowerCase();
        if (!campsite.label.toLowerCase().contains(query) &&
            !campsite.country.toLowerCase().contains(query)) {
          return false;
        }
      }
      
      return true;
    }).toList();
  }
}

@riverpod
CampsiteRepository campsiteRepository(CampsiteRepositoryRef ref) {
  final remoteDataSource = ref.watch(campsiteRemoteDataSourceProvider);
  return CampsiteRepositoryImpl(remoteDataSource: remoteDataSource);
}

@riverpod
CampsiteRemoteDataSource campsiteRemoteDataSource(CampsiteRemoteDataSourceRef ref) {
  return CampsiteRemoteDataSourceImpl(client: http.Client());
} 