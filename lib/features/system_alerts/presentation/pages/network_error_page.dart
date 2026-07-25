import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/core/router/app_state_provider.dart';

class NetworkErrorPage extends ConsumerWidget {
  const NetworkErrorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Please check your network and try again.'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                ref.read(appStateProvider.notifier).retryInitialization();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
