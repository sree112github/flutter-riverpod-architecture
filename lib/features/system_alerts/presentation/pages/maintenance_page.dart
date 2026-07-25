import 'package:flutter/material.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.engineering, size: 80, color: Colors.orange),
            SizedBox(height: 20),
            Text(
              'Under Maintenance',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We are currently upgrading our servers.\nPlease try again later.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
