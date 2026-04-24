import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  static const _tabs = [
    _Tab(
        path: '/home',
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: 'Home'),
    _Tab(
        path: '/mandir',
        icon: Icons.temple_hindu_outlined,
        activeIcon: Icons.temple_hindu,
        label: 'Mandir'),
    _Tab(
        path: '/aarti',
        icon: Icons.music_note_outlined,
        activeIcon: Icons.music_note_rounded,
        label: 'Aarti'),
    _Tab(
        path: '/profile',
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: 'Profile'),
  ];

  int _index(String loc) {
    if (loc.startsWith('/mandir')) return 1;
    if (loc.startsWith('/aarti')) return 2;
    if (loc.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index(loc),
        onTap: (i) => context.go(_tabs[i].path),
        items: _tabs
            .map((t) => BottomNavigationBarItem(
                  icon: Icon(t.icon),
                  activeIcon: Icon(t.activeIcon),
                  label: t.label,
                ))
            .toList(),
      ),
    );
  }
}

class _Tab {
  final String path;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _Tab({
    required this.path,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
