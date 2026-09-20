import 'package:flutter/foundation.dart';

/// A centralized registry of all Widget Keys used across the application.
/// Using this registry prevents typos, avoids duplicate keys, and makes
/// automated testing robust against localization changes.
class AppKeys {
  // Onboarding & Intro
  static const acceptTermsBtn = Key('accept_terms_btn');
  static const finishIntroBtn = Key('finish_intro_btn');

  // Authentication
  static const loginDirectBtn = Key('login_direct_btn');
  static const loginGoogleBtn = Key('login_google_btn');
  static const emailField = Key('email_field');
  static const passwordField = Key('password_field');

  // System Alerts
  static const networkRetryBtn = Key('network_retry_btn');
  static const maintenanceRetryBtn = Key('maintenance_retry_btn');

  // Dashboard & Profile
  static const profileBtn = Key('profile_btn');
  static const logoutBtn = Key('logout_btn');
}
