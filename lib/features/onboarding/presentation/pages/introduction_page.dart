import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/core/router/app_state_provider.dart';

class IntroductionPage extends ConsumerWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to MyApp')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, size: 100, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              'Discover new features and \nexperience the best performance.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                ref.read(appStateProvider.notifier).finishIntro();
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
