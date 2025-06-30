import '../entities/campsite.dart';
import '../entities/filter_criteria.dart';

abstract class CampsiteRepository {
  Future<List<Campsite>> getCampsites();
  Future<List<Campsite>> getFilteredCampsites(FilterCriteria criteria);
  Future<Campsite?> getCampsiteById(String id);
} 