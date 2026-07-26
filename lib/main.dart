import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_app/core/config/env_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grpc_app/core/storage/storage_provider.dart';
import 'package:grpc_app/core/router/router_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc_app/features/auth_bloc/presentation/bloc/auth_dependency_provider.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.init();
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final authBloc = ref.watch(authBlocProvider);
    
    return BlocProvider.value(
      value: authBloc,
      child: MaterialApp.router(
        title: 'Clean Arch App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
