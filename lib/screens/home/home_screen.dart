import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🙏 Devasthan'),
        actions: [
          IconButton(
            icon: Icon(appProvider.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: appProvider.toggleTheme,
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🛕', style: TextStyle(fontSize: 72)),
            SizedBox(height: 16),
            Text(
              'Coming in Phase 2',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
