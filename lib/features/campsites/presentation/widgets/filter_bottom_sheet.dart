import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/filter_criteria.dart';
import '../providers/campsites_provider.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  String? selectedCountry;
  bool? closeToWater;
  bool? campFireAllowed;
  String? selectedLanguage;
  double? minPrice;
  double? maxPrice;

  // Create persistent controllers
  late TextEditingController _countryController;
  late TextEditingController _languageController;
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;

  @override
  void initState() {
    super.initState();
    final currentFilter = ref.read(filterNotifierProvider);
    selectedCountry = currentFilter.country;
    closeToWater = currentFilter.closeToWater;
    campFireAllowed = currentFilter.campFireAllowed;
    selectedLanguage = currentFilter.hostLanguage;
    minPrice = currentFilter.minPrice;
    maxPrice = currentFilter.maxPrice;

    // Initialize controllers with current values
    _countryController = TextEditingController(text: selectedCountry ?? '');
    _languageController = TextEditingController(text: selectedLanguage ?? '');
    _minPriceController = TextEditingController(text: minPrice?.toString() ?? '');
    _maxPriceController = TextEditingController(text: maxPrice?.toString() ?? '');
  }

  @override
  void dispose() {
    _countryController.dispose();
    _languageController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Campsites',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Country Filter
          Text(
            'Country',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _countryController,
            decoration: const InputDecoration(
              hintText: 'Enter country name',
            ),
            textDirection: TextDirection.ltr,
            onChanged: (value) {
              setState(() {
                selectedCountry = value.isEmpty ? null : value;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // Language Filter
          Text(
            'Host Language',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _languageController,
            decoration: const InputDecoration(
              hintText: 'Enter language',
            ),
            textDirection: TextDirection.ltr,
            onChanged: (value) {
              setState(() {
                selectedLanguage = value.isEmpty ? null : value;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // Price Range
          Text(
            'Price Range (€)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minPriceController,
                  decoration: const InputDecoration(
                    hintText: 'Min',
                  ),
                  textDirection: TextDirection.ltr,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      minPrice = value.isEmpty ? null : double.tryParse(value);
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _maxPriceController,
                  decoration: const InputDecoration(
                    hintText: 'Max',
                  ),
                  textDirection: TextDirection.ltr,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      maxPrice = value.isEmpty ? null : double.tryParse(value);
                    });
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Features
          Text(
            'Features',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          
          // Close to Water
          CheckboxListTile(
            title: const Text('Close to Water'),
            value: closeToWater,
            tristate: true,
            onChanged: (value) {
              setState(() {
                closeToWater = value;
              });
            },
            contentPadding: EdgeInsets.zero,
          ),
          
          // Campfire Allowed
          CheckboxListTile(
            title: const Text('Campfire Allowed'),
            value: campFireAllowed,
            tristate: true,
            onChanged: (value) {
              setState(() {
                campFireAllowed = value;
              });
            },
            contentPadding: EdgeInsets.zero,
          ),
          
          const SizedBox(height: 24),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _clearFilters,
                  child: const Text('Clear'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      selectedCountry = null;
      closeToWater = null;
      campFireAllowed = null;
      selectedLanguage = null;
      minPrice = null;
      maxPrice = null;
      
      // Clear controllers
      _countryController.clear();
      _languageController.clear();
      _minPriceController.clear();
      _maxPriceController.clear();
    });
    
    ref.read(filterNotifierProvider.notifier).clearFilters();
    ref.read(campsitesNotifierProvider.notifier).refreshCampsites();
    Navigator.pop(context);
  }

  void _applyFilters() {
    final filterCriteria = FilterCriteria(
      country: selectedCountry,
      closeToWater: closeToWater,
      campFireAllowed: campFireAllowed,
      hostLanguage: selectedLanguage,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
    
    ref.read(filterNotifierProvider.notifier).updateFilter(filterCriteria);
    ref.read(campsitesNotifierProvider.notifier).filterCampsites(filterCriteria);
    Navigator.pop(context);
  }
} 