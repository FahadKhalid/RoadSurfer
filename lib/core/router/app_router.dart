import 'package:go_router/go_router.dart';
import '../../features/campsites/presentation/screens/home_screen.dart';
import '../../features/campsites/presentation/screens/campsite_detail_screen.dart';
import '../../features/campsites/presentation/screens/map_screen.dart';
import '../constants/app_strings.dart';

final appRouter = GoRouter(
  initialLocation: AppStrings.homeRoute,
  routes: [
    GoRoute(
      path: AppStrings.homeRoute,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppStrings.campsiteDetailRoute,
      name: 'campsite-detail',
      builder: (context, state) {
        final campsiteId = state.pathParameters['id']!;
        return CampsiteDetailScreen(campsiteId: campsiteId);
      },
    ),
    GoRoute(
      path: AppStrings.mapRoute,
      name: 'map',
      builder: (context, state) => const MapScreen(),
    ),
  ],
); 