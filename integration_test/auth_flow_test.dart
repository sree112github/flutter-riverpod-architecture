import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:grpc_app/main.dart' as app;
import 'package:grpc_app/core/constants/app_keys.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E Authentication Flow Test', () {
    testWidgets('Verify complete login flow from start to finish', (tester) async {
      // 0. WIPE LOCAL DEVICE STATE
      print('>>> [STEP 0] Wiping local device state...');
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 1. Launch the app using the main entry point
      print('>>> [STEP 1] Launching the app...');
      app.main();
      
      // Wait for the app to fully initialize and settle on the first screen
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 2. Handle flaky emulator environments
      print('>>> [STEP 2] Checking for emulator network/maintenance errors...');
      int retryCount = 0;
      while (find.byKey(AppKeys.maintenanceRetryBtn).evaluate().isNotEmpty && retryCount < 10) {
        print('    -> Tapping Maintenance Retry (Attempt ${retryCount + 1})');
        await tester.tap(find.byKey(AppKeys.maintenanceRetryBtn));
        await tester.pumpAndSettle(const Duration(seconds: 3));
        retryCount++;
      }

      retryCount = 0;
      while (find.byKey(AppKeys.networkRetryBtn).evaluate().isNotEmpty && retryCount < 10) {
        print('    -> Tapping Network Retry (Attempt ${retryCount + 1})');
        await tester.tap(find.byKey(AppKeys.networkRetryBtn));
        await tester.pumpAndSettle(const Duration(seconds: 3));
        retryCount++;
      }

      // 3. Bypass onboarding if present
      print('>>> [STEP 3] Bypassing onboarding screens if present...');
      
      final termsButton = find.byKey(AppKeys.acceptTermsBtn);
      if (termsButton.evaluate().isNotEmpty) {
        print('    -> Bypassed Terms & Conditions');
        await tester.tap(termsButton);
        await tester.pumpAndSettle();
      }

      final introButton = find.byKey(AppKeys.finishIntroBtn);
      if (introButton.evaluate().isNotEmpty) {
        print('    -> Bypassed Introduction');
        await tester.tap(introButton);
        await tester.pumpAndSettle();
      }

      // 4. Verify we are on the Login Page
      print('>>> [STEP 4] Verifying we are on the Login Page...');
      expect(find.byKey(AppKeys.loginDirectBtn), findsOneWidget);

      // 5. Enter credentials and tap the Login button
      print('>>> [STEP 5] Entering credentials and tapping the Login button...');
      
      await tester.enterText(find.byKey(AppKeys.emailField), 'test@test.com');
      await tester.enterText(find.byKey(AppKeys.passwordField), 'password123');
      await tester.pumpAndSettle();

      final loginButton = find.byKey(AppKeys.loginDirectBtn);
      await tester.tap(loginButton);
      
      // Allow the async login process (mock data source) to complete
      await tester.pumpAndSettle();

      // 6. Verify navigation to Dashboard
      print('>>> [STEP 6] Verifying successful navigation to Dashboard...');
      expect(find.byKey(AppKeys.loginDirectBtn), findsNothing);

      final profileBtn = find.byKey(AppKeys.profileBtn);
      expect(profileBtn, findsOneWidget);

      // 7. Tap Profile Button
      print('>>> [STEP 7] Tapping Profile button to open User Profile...');
      await tester.tap(profileBtn);
      await tester.pumpAndSettle();

      // 8. Tap Logout Button
      print('>>> [STEP 8] Tapping Logout button...');
      final logoutBtn = find.byKey(AppKeys.logoutBtn);
      expect(logoutBtn, findsOneWidget);

      await tester.tap(logoutBtn);
      await tester.pumpAndSettle();

      // 9. Verify successful logout
      print('>>> [STEP 9] Verifying successful logout (Login screen visible)...');
      expect(find.byKey(AppKeys.loginDirectBtn), findsOneWidget);
      
      print('>>> E2E Test Completed Successfully! 🎉');
    });
  });
}
