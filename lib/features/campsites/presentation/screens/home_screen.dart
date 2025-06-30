import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/campsites_provider.dart';
import '../widgets/campsite_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/search_bar_widget.dart';
import '../../../../core/constants/app_strings.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(campsitesNotifierProvider.notifier).refreshCampsites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final campsitesAsync = ref.watch(campsitesNotifierProvider);
    final filterNotifier = ref.watch(filterNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => context.push(AppStrings.mapRoute),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(
              onSearchChanged: (query) {
                filterNotifier.updateSearchQuery(query);
                _applyFilters();
              },
            ),
          ),
          Expanded(
            child: campsitesAsync.when(
              data: (campsites) {
                if (campsites.isEmpty) {
                  return Center(
                    child: Text(AppStrings.noCampsitesFound),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(campsitesNotifierProvider.notifier)
                        .refreshCampsites();
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 1;
                      double width = constraints.maxWidth;
                      if (width >= 1200) {
                        crossAxisCount = 4;
                      } else if (width >= 800) {
                        crossAxisCount = 2;
                      }
                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: campsites.length,
                        itemBuilder: (context, index) {
                          final campsite = campsites[index];
                          return CampsiteCard(
                            campsite: campsite,
                            onTap: () => context.push(AppStrings.campsiteDetailRoute.replaceAll(':id', campsite.id)),
                          );
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.errorLoadingCampsites,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(campsitesNotifierProvider.notifier)
                            .refreshCampsites();
                      },
                      child: Text(AppStrings.retry),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const FilterBottomSheet(),
    );
  }

  void _applyFilters() {
    final currentFilter = ref.read(filterNotifierProvider);
    ref
        .read(campsitesNotifierProvider.notifier)
        .filterCampsites(currentFilter);
  }
} 