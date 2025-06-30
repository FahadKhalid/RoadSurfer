import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'shared/theme/app_theme.dart';
import 'core/constants/app_strings.dart';

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
        title: AppStrings.appTitle,
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        locale: Locale(AppStrings.defaultLocale, AppStrings.defaultCountry),
      ),
    );
  }
}
