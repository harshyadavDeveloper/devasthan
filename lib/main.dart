import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'navigation/app_router.dart';
import 'providers/app_provider.dart';

void main() {
  runApp(const DevasthanApp());
}

class DevasthanApp extends StatelessWidget {
  const DevasthanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: Consumer<AppProvider>(
        builder: (context, appProvider, _) {
          return MaterialApp.router(
            title: 'Devasthan',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: appProvider.themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
