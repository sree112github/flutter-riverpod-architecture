import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/core/router/app_state_provider.dart';
import 'package:grpc_app/core/constants/app_keys.dart';

class MaintenancePage extends ConsumerStatefulWidget {
  const MaintenancePage({super.key});

  @override
  ConsumerState<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends ConsumerState<MaintenancePage> {
  bool _isRetrying = false;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    // Auto-poll the server every 5 seconds silently in the background
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_isRetrying && mounted) {
        _silentRetry();
      }
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _performRetry() async {
    if (!mounted || _isRetrying) return;
    setState(() => _isRetrying = true);
    
    // Ping the server without navigating away
    await ref.read(appStateProvider.notifier).retryInitialization();
    
    // If the widget is still mounted (meaning we are still in maintenance), reset the spinner.
    if (mounted) {
      setState(() => _isRetrying = false);
    }
  }

  Future<void> _silentRetry() async {
    if (!mounted) return;
    // Just ping the server in the background without touching the UI state
    await ref.read(appStateProvider.notifier).retryInitialization();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.engineering, size: 80, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              'Under Maintenance',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'We are currently upgrading our servers.\nPlease try again later.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              key: AppKeys.maintenanceRetryBtn,
              onPressed: _isRetrying ? null : _performRetry,
              icon: _isRetrying
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
              label: Text(_isRetrying ? 'Checking...' : 'Retry Connection'),
            )
          ],
        ),
      ),
    );
  }
}
