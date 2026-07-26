import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/core/router/app_state_provider.dart';

class NetworkErrorPage extends ConsumerStatefulWidget {
  const NetworkErrorPage({super.key});

  @override
  ConsumerState<NetworkErrorPage> createState() => _NetworkErrorPageState();
}

class _NetworkErrorPageState extends ConsumerState<NetworkErrorPage> {
  bool _isRetrying = false;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    // Auto-poll the network every 5 seconds silently in the background
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
    
    await ref.read(appStateProvider.notifier).retryInitialization();
    
    if (mounted) {
      setState(() => _isRetrying = false);
    }
  }

  Future<void> _silentRetry() async {
    if (!mounted) return;
    await ref.read(appStateProvider.notifier).retryInitialization();
  }

  @override
  Widget build(BuildContext context) {
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
            ElevatedButton.icon(
              onPressed: _isRetrying ? null : _performRetry,
              icon: _isRetrying
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
              label: Text(_isRetrying ? 'Checking...' : 'Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
