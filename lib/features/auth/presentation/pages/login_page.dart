import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/features/auth/presentation/controller/auth_controller.dart';
import 'package:grpc_app/core/router/app_state_provider.dart';
import 'package:grpc_app/core/constants/app_keys.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the auth state to determine if it is currently loading
    final authState = ref.watch(authControllerProvider);
    final _isSaving = authState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.lock_outline, size: 80, color: Colors.blue),
                const SizedBox(height: 32),
                TextFormField(
                  key: AppKeys.emailField,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email cannot be empty';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: AppKeys.passwordField,
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  key: AppKeys.loginDirectBtn,
                  onPressed: _isSaving
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          
                          try {
                            await ref.read(authControllerProvider.notifier).login(
                                  _emailController.text.trim(),
                                  _passwordController.text,
                                );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Login successful!'), backgroundColor: Colors.green),
                              );
                              // go_router will automatically redirect because auth state changed!
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSaving
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Direct Login', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  key: AppKeys.loginGoogleBtn,
                  onPressed: _isSaving
                      ? null
                      : () async {
                          try {
                            await ref.read(authControllerProvider.notifier).loginWithGoogle();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Google Login successful!'), backgroundColor: Colors.green),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red),
                              );
                            }
                          }
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
        ),
      ),
    );
  }
}
