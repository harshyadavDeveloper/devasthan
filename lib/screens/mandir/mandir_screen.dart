import 'package:flutter/material.dart';

class MandirScreen extends StatelessWidget {
  const MandirScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Mandir')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🪔', style: TextStyle(fontSize: 72)),
            SizedBox(height: 16),
            Text(
              'Mandir Builder — Phase 3',
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
