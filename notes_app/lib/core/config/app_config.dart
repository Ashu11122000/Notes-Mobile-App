import 'package:flutter/foundation.dart';

/// Centralized application configuration.
///
/// This class provides environment-specific configuration values.
/// All networking code should read configuration from here instead of
/// hardcoding values throughout the application.
final class AppConfig {
  const AppConfig._();

  /// FastAPI backend base URL.
  ///
  /// Override using:
  ///
  /// flutter run --dart-define=BASE_URL=http://192.168.1.10:8000
  ///
  /// Android Emulator:
  /// http://10.0.2.2:8000
  ///
  /// iOS Simulator:
  /// http://localhost:8000
  ///
  /// Physical Device:
  /// http://<YOUR_LOCAL_IP>:8000
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  /// Whether the application is running in debug mode.
  static bool get isDebug => kDebugMode;

  /// Whether the application is running in profile mode.
  static bool get isProfile => kProfileMode;

  /// Whether the application is running in release mode.
  static bool get isRelease => kReleaseMode;
}
