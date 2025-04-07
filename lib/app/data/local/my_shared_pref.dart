import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPref {
  // Prevent creating an instance
  MySharedPref._();

  // SharedPreferences instance
  static late SharedPreferences _sharedPreferences;

  // Storage Keys
  static const String _fcmTokenKey = 'fcm_token';
  static const String _currentLocalKey = 'current_local';
  static const String _lightThemeKey = 'is_theme_light';
  static const String _isLoggedInKey =
      'is_logged_in'; // Key to store login status
  static const String _authTokenKey = 'auth_token'; // Key to store auth token
  static const String _refreshToken =
      'refresh_token'; // Key to store auth token
  static const String _onboardingCompleteKey =
      'onboarding_complete'; // Key to store onboarding status

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static setStorage(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  /// Set theme as light or dark
  static Future<void> setThemeIsLight(bool lightTheme) =>
      _sharedPreferences.setBool(_lightThemeKey, lightTheme);

  /// Get theme type (light or dark)
  static bool getThemeIsLight() =>
      _sharedPreferences.getBool(_lightThemeKey) ?? true;

  /// Save current locale
  static Future<void> setCurrentLanguage(String languageCode) =>
      _sharedPreferences.setString(_currentLocalKey, languageCode);

  /// Get current locale
  static Locale getCurrentLocal() {
    String? currentLocal = _sharedPreferences.getString(_currentLocalKey);
    return currentLocal != null ? Locale(currentLocal) : const Locale('en');
  }

  /// Save generated FCM token
  static Future<void> setFcmToken(String token) =>
      _sharedPreferences.setString(_fcmTokenKey, token);

  /// Get FCM token
  static String? getFcmToken() => _sharedPreferences.getString(_fcmTokenKey);

  /// Save login status (true if user is logged in)
  static Future<void> setIsLoggedIn(bool isLoggedIn) =>
      _sharedPreferences.setBool(_isLoggedInKey, isLoggedIn);

  /// Check if user is logged in
  static bool isLoggedIn() =>
      _sharedPreferences.getBool(_isLoggedInKey) ?? false;

  /// Save authorization token
  static Future<void> setAuthToken(String? token) {
    if (token == null) {
      return _sharedPreferences.remove(_authTokenKey);
    }
    return _sharedPreferences.setString(_authTokenKey, token);
  }

  /// Get authorization token
  static String? getAuthToken() => _sharedPreferences.getString(_authTokenKey);

  /// Save authorization refresh  token
  static Future<void> setAuthRefreshToken(String? token) {
    if (token == null) {
      return _sharedPreferences.remove(_refreshToken);
    }
    return _sharedPreferences.setString(_refreshToken, token);
  }

  /// Get authorization token
  static String? getAuthRefreshToken() =>
      _sharedPreferences.getString(_refreshToken);

  /// Save onboarding completion status (true if onboarding is completed)
  static Future<void> setOnboardingComplete(bool isComplete) =>
      _sharedPreferences.setBool(_onboardingCompleteKey, isComplete);

  /// Check if onboarding is completed
  static bool isOnboardingComplete() =>
      _sharedPreferences.getBool(_onboardingCompleteKey) ?? false;

  /// Clear all stored data
  // Clear all stored data
  static Future<void> clear() async {
    bool result = await _sharedPreferences.clear();
    if (result) {
      print("SharedPreferences cleared successfully");
    } else {
      print("Failed to clear SharedPreferences");
    }
  }
}
