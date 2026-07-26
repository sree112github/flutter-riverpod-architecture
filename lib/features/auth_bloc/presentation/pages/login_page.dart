import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/core/router/app_state_provider.dart';
import 'package:grpc_app/features/auth_bloc/presentation/bloc/auth_bloc.dart';
import 'package:grpc_app/features/auth_bloc/presentation/bloc/auth_event.dart';
import 'package:grpc_app/features/auth_bloc/presentation/bloc/auth_state.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login successful!'), backgroundColor: Colors.green),
            );
            // Redirection logic should be handled by router observing the auth state
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          final isSaving = state is AuthLoading;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.lock_outline, size: 80, color: Colors.blue),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: isSaving
                        ? null
                        : () {
                            context.read<AuthBloc>().add(
                                  const AuthLoginRequested(
                                    email: 'test@test.com',
                                    password: 'password123',
                                  ),
                                );
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: isSaving
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Direct Login', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: isSaving
                        ? null
                        : () {
                            context.read<AuthBloc>().add(AuthGoogleLoginRequested());
                          },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.g_mobiledata, size: 30),
                    label: const Text('Sign in with Google', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 32),
                  TextButton(
                    onPressed: () {
                      ref.read(appStateProvider.notifier).clearPreferences();
                    },
                    child: const Text('Clear Terms & Intro Preferences'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
