import 'package:go_router/go_router.dart';
import '../../features/campsites/presentation/screens/home_screen.dart';
import '../../features/campsites/presentation/screens/campsite_detail_screen.dart';
import '../../features/campsites/presentation/screens/map_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/campsite/:id',
      name: 'campsite-detail',
      builder: (context, state) {
        final campsiteId = state.pathParameters['id']!;
        return CampsiteDetailScreen(campsiteId: campsiteId);
      },
    ),
    GoRoute(
      path: '/map',
      name: 'map',
      builder: (context, state) => const MapScreen(),
    ),
  ],
); 