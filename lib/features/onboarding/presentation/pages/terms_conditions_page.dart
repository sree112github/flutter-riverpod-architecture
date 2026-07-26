import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/core/router/app_state_provider.dart';
import 'package:grpc_app/features/auth/presentation/controller/auth_controller.dart';

class TermsConditionsPage extends ConsumerStatefulWidget {
  const TermsConditionsPage({super.key});

  @override
  ConsumerState<TermsConditionsPage> createState() => _TermsConditionsPageState();
}

class _TermsConditionsPageState extends ConsumerState<TermsConditionsPage> {
  bool _isCompleting = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = _isCompleting && authState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Terms & Conditions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'Here are the terms and conditions of using this app. '
                  'Please read them carefully before accepting.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : () {
                setState(() => _isCompleting = true);
                ref.read(appStateProvider.notifier).acceptTerms();
              },
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Accept Terms'),
            ),
          ],
        ),
      ),
    );
  }
}
