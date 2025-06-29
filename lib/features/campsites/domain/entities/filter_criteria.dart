import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_criteria.freezed.dart';

@freezed
class FilterCriteria with _$FilterCriteria {
  const factory FilterCriteria({
    String? country,
    bool? closeToWater,
    bool? campFireAllowed,
    String? hostLanguage,
    double? minPrice,
    double? maxPrice,
    String? searchQuery,
  }) = _FilterCriteria;

  const FilterCriteria._();

  bool get hasActiveFilters =>
      country != null ||
      closeToWater != null ||
      campFireAllowed != null ||
      hostLanguage != null ||
      minPrice != null ||
      maxPrice != null ||
      (searchQuery != null && searchQuery!.isNotEmpty);
} 