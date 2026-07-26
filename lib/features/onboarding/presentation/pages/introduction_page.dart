import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/core/router/app_state_provider.dart';
import 'package:grpc_app/features/auth/presentation/controller/auth_controller.dart';

class IntroductionPage extends ConsumerStatefulWidget {
  const IntroductionPage({super.key});

  @override
  ConsumerState<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends ConsumerState<IntroductionPage> {
  bool _isCompleting = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = _isCompleting && authState.isLoading;

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
              onPressed: isLoading ? null : () {
                setState(() => _isCompleting = true);
                ref.read(appStateProvider.notifier).finishIntro();
              },
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
