import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/features/auth/presentation/controller/auth_controller.dart';
import 'package:grpc_app/features/user/presentation/controller/current_user_controller.dart';
import 'package:grpc_app/features/system_alerts/domain/services/mock_api_interceptor.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(currentUserControllerProvider);
    final authState = ref.watch(authControllerProvider);
    final isLoggingOut = authState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          isLoggingOut
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    // go_router will automatically redirect to /login once this finishes
                    await ref.read(authControllerProvider.notifier).logout();
                  },
                )
        ],
      ),
      body: userState.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('No user logged in.'));
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 24),
                Text(
                  user.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  user.email,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                const Text(
                  'ID:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(user.id),
                const SizedBox(height: 64),
                OutlinedButton.icon(
                  onPressed: () {
                    // Simulate a global 503 from the API Interceptor
                    ref.read(apiInterceptorProvider).simulate503Error();
                  },
                  icon: const Icon(Icons.warning, color: Colors.orange),
                  label: const Text('Simulate 503 Maintenance', style: TextStyle(color: Colors.orange)),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error loading profile: $error')),
      ),
    );
  }
}
