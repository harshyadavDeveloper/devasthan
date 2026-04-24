import 'package:flutter/material.dart';

class AartiScreen extends StatelessWidget {
  const AartiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aarti & Bhajans')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🎵', style: TextStyle(fontSize: 72)),
            SizedBox(height: 16),
            Text(
              'Aarti Player — Phase 4',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}