import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/core/router/app_state_provider.dart';

class TermsConditionsPage extends ConsumerWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              onPressed: () {
                ref.read(appStateProvider.notifier).acceptTerms();
              },
              child: const Text('Accept Terms'),
            ),
          ],
        ),
      ),
    );
  }
}
