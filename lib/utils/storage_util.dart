import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageUtil {
  static final _storage = const FlutterSecureStorage();
  static const _onboardingKey = 'has_completed_onboarding';

  // Save that onboarding has been completed
  static Future<void> setOnboardingCompleted() async {
    await _storage.write(key: _onboardingKey, value: 'true');
  }

  // Check if onboarding has been completed
  static Future<bool> hasCompletedOnboarding() async {
    final value = await _storage.read(key: _onboardingKey);
    return value == 'true';
  }
}
