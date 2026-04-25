import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'navigation/app_router.dart';
import 'providers/app_provider.dart';
import 'providers/mandir_provider.dart';
import 'providers/aarti_provider.dart';
import 'providers/streak_provider.dart';
import 'providers/alarm_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const DevasthanApp());
}

class DevasthanApp extends StatelessWidget {
  const DevasthanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProxyProvider0<MandirProvider>(
          create: (_) => MandirProvider()..init(),
          update: (_, prev) => prev ?? (MandirProvider()..init()),
        ),
        ChangeNotifierProvider(create: (_) => AartiProvider()),
        ChangeNotifierProxyProvider0<StreakProvider>(
          create: (_) => StreakProvider()..init(),
          update: (_, prev) => prev ?? (StreakProvider()..init()),
        ),
        ChangeNotifierProxyProvider0<AlarmProvider>(
          create: (_) => AlarmProvider()..init(),
          update: (_, prev) => prev ?? (AlarmProvider()..init()),
        ),
      ],
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
