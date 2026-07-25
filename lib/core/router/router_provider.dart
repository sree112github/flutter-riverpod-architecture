import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grpc_app/core/router/app_state.dart';
import 'package:grpc_app/core/router/app_state_provider.dart';
import 'package:grpc_app/features/auth/presentation/controller/auth_controller.dart';
import 'package:grpc_app/features/auth/presentation/pages/login_page.dart';
import 'package:grpc_app/features/product/presentation/pages/product_crud_page.dart';
import 'package:grpc_app/features/splash/presentation/pages/splash_page.dart';
import 'package:grpc_app/features/onboarding/presentation/pages/terms_conditions_page.dart';
import 'package:grpc_app/features/onboarding/presentation/pages/introduction_page.dart';
import 'package:grpc_app/features/system_alerts/presentation/pages/network_error_page.dart';
import 'package:grpc_app/features/system_alerts/presentation/pages/maintenance_page.dart';
import 'package:grpc_app/features/system_alerts/presentation/pages/force_update_page.dart';
import 'package:grpc_app/features/user/presentation/pages/user_profile_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier, // Triggers redirect on state change
    redirect: (context, state) {
      final appState = ref.read(appStateProvider);
      final authState = ref.read(authControllerProvider);
      final currentPath = state.uri.path;
      
      // Determine what path we SHOULD be on based on AppState
      String? expectedPath;
      
      switch (appState) {
        case AppState.initializing:
          expectedPath = '/splash';
          break;
        case AppState.networkError:
          expectedPath = '/network-error';
          break;
        case AppState.forceUpdate:
          expectedPath = '/force-update';
          break;
        case AppState.maintenance:
          expectedPath = '/maintenance';
          break;
        case AppState.termsPending:
          expectedPath = '/terms';
          break;
        case AppState.introPending:
          expectedPath = '/intro';
          break;
        case AppState.ready:
          // Wait for auth state to finish loading before routing
          if (authState.isLoading) {
            expectedPath = '/splash';
            break;
          }
          
          // App is ready, now we check auth
          final isAuthed = authState.value ?? false;
          
          if (!isAuthed) {
            // Not authenticated: Must be on /login
            expectedPath = '/login';
          } else {
            // Authenticated: Allowed to be on / or /profile
            // If they are on a login or onboarding screen, redirect to home
            final isAuthOrOnboarding = currentPath == '/login' || 
                                       currentPath == '/splash' || 
                                       currentPath == '/terms' || 
                                       currentPath == '/intro';
            if (isAuthOrOnboarding) {
              expectedPath = '/';
            } else {
              // They are on a valid authenticated route (like / or /profile)
              expectedPath = currentPath;
            }
          }
          break;
      }
      
      // If we are already on the expected path, no need to redirect
      if (expectedPath == currentPath) return null;
      
      // Otherwise, redirect to the expected path
      return expectedPath;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductCrudPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const UserProfilePage(),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const LoginPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // Smooth slide-up transition
              const begin = Offset(0.0, 1.0); // Start from bottom
              const end = Offset.zero;
              final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeOutQuart));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
          );
        },
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/terms',
        builder: (context, state) => const TermsConditionsPage(),
      ),
      GoRoute(
        path: '/intro',
        builder: (context, state) => const IntroductionPage(),
      ),
      GoRoute(
        path: '/network-error',
        builder: (context, state) => const NetworkErrorPage(),
      ),
      GoRoute(
        path: '/maintenance',
        builder: (context, state) => const MaintenancePage(),
      ),
      GoRoute(
        path: '/force-update',
        builder: (context, state) => const ForceUpdatePage(),
      ),
    ],
  );
});

// A custom listenable to trigger GoRouter refreshes when Riverpod providers update
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen(appStateProvider, (_, __) => notifyListeners());
    ref.listen(authControllerProvider, (_, __) => notifyListeners());
  }
}
