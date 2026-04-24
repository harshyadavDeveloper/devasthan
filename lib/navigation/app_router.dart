import 'package:go_router/go_router.dart';
import '../navigation/app_shell.dart';
import '../screens/home/home_screen.dart';
import '../screens/mandir/mandir_screen.dart';
import '../screens/aarti/aarti_screen.dart';
import '../screens/profile/profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/mandir', builder: (_, __) => const MandirScreen()),
        GoRoute(path: '/aarti', builder: (_, __) => const AartiScreen()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      ],
    ),
  ],
);
