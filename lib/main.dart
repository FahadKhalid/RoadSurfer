import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'shared/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: CampsiteApp(),
    ),
  );
}

class CampsiteApp extends StatelessWidget {
  const CampsiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: MaterialApp.router(
        title: 'Roadsurfer Campsites',
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        locale: const Locale('en', 'US'),
      ),
    );
  }
}
