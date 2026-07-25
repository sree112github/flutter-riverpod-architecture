import 'package:flutter/material.dart';

class ForceUpdatePage extends StatelessWidget {
  const ForceUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.system_update, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Update Required',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'A new version of the app is available.\nPlease update to continue using the app.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // In a real app, open App Store or Play Store
              },
              child: const Text('Update Now'),
            ),
          ],
        ),
      ),
    );
  }
}
