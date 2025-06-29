import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../domain/entities/campsite.dart';
import '../../domain/entities/filter_criteria.dart';
import '../providers/campsites_provider.dart';

/// ViewModel for Campsites feature following MVVM pattern
/// Handles business logic, formatting, and data transformation for the UI
class CampsitesViewModel {
  final Ref ref;

  CampsitesViewModel(this.ref);

  /// Get all campsites with loading state
  AsyncValue<List<Campsite>> get campsites => ref.watch(campsitesNotifierProvider);

  /// Get a specific campsite by ID
  AsyncValue<Campsite?> getCampsiteById(String id) {
    return ref.watch(campsiteByIdProvider(id));
  }

  /// Get current filter criteria
  FilterCriteria get currentFilter => ref.watch(filterNotifierProvider);

  /// Format price for display with Euro currency
  String formatPrice(double price) {
    return PriceFormatter.formatPricePerNight(price, currency: '€');
  }

  /// Format price range for display
  String formatPriceRange(double minPrice, double maxPrice) {
    return PriceFormatter.formatPriceRange(minPrice, maxPrice, currency: '€');
  }

  /// Get formatted location string
  String getFormattedLocation(Campsite campsite) {
    return '${campsite.country} • ${campsite.geoLocation.latitude.toStringAsFixed(2)}, ${campsite.geoLocation.longitude.toStringAsFixed(2)}';
  }

  /// Get formatted coordinates string
  String getFormattedCoordinates(Campsite campsite) {
    return 'Lat: ${campsite.geoLocation.latitude.toStringAsFixed(4)}, Lng: ${campsite.geoLocation.longitude.toStringAsFixed(4)}';
  }

  /// Get feature chips data for a campsite
  List<Map<String, dynamic>> getFeatureChips(Campsite campsite) {
    final chips = <Map<String, dynamic>>[];
    
    if (campsite.closeToWater) {
      chips.add({
        'icon': 'water',
        'label': 'Close to Water',
        'isActive': true,
      });
    }
    
    if (campsite.campFireAllowed) {
      chips.add({
        'icon': 'local_fire_department',
        'label': 'Campfire Allowed',
        'isActive': true,
      });
    }
    
    return chips;
  }

  /// Get price statistics for filtered campsites
  Map<String, dynamic> getPriceStatistics(List<Campsite> campsites) {
    if (campsites.isEmpty) {
      return {
        'minPrice': 0.0,
        'maxPrice': 0.0,
        'averagePrice': 0.0,
        'formattedRange': '€0/night',
      };
    }

    final prices = campsites.map((c) => c.pricePerNight).toList();
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final averagePrice = prices.reduce((a, b) => a + b) / prices.length;

    return {
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'averagePrice': averagePrice,
      'formattedRange': formatPriceRange(minPrice, maxPrice),
    };
  }

  /// Check if campsite matches search query
  bool matchesSearch(Campsite campsite, String query) {
    if (query.isEmpty) return true;
    
    final lowerQuery = query.toLowerCase();
    return campsite.label.toLowerCase().contains(lowerQuery) ||
           campsite.country.toLowerCase().contains(lowerQuery) ||
           campsite.hostLanguage.toLowerCase().contains(lowerQuery);
  }

  /// Get sorted campsites by price
  List<Campsite> getSortedCampsites(List<Campsite> campsites, String sortBy) {
    final sorted = List<Campsite>.from(campsites);
    
    switch (sortBy.toLowerCase()) {
      case 'price_low_to_high':
        sorted.sort((a, b) => a.pricePerNight.compareTo(b.pricePerNight));
        break;
      case 'price_high_to_low':
        sorted.sort((a, b) => b.pricePerNight.compareTo(a.pricePerNight));
        break;
      case 'name_a_to_z':
        sorted.sort((a, b) => a.label.compareTo(b.label));
        break;
      case 'name_z_to_a':
        sorted.sort((a, b) => b.label.compareTo(a.label));
        break;
    }
    
    return sorted;
  }

  /// Refresh campsites data
  Future<void> refreshCampsites() async {
    await ref.read(campsitesNotifierProvider.notifier).refreshCampsites();
  }

  /// Update filter criteria
  void updateFilter(FilterCriteria criteria) {
    ref.read(filterNotifierProvider.notifier).updateFilter(criteria);
  }

  /// Clear all filters
  void clearFilters() {
    ref.read(filterNotifierProvider.notifier).clearFilters();
  }
}

/// Provider for CampsitesViewModel
final campsitesViewModelProvider = Provider<CampsitesViewModel>((ref) {
  return CampsitesViewModel(ref);
}); 