import Flutter
import UIKit

/// iOS application entry point.
///
/// Keep this file minimal.
/// Add native iOS code only when required by a Flutter plugin or
/// platform-specific functionality.
@main
@objc
final class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        super.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }

    /// Registers Flutter plugins with the implicit Flutter engine.
    func didInitializeImplicitFlutterEngine(
        _ engineBridge: FlutterImplicitEngineBridge
    ) {
        GeneratedPluginRegistrant.register(
            with: engineBridge.pluginRegistry
        )
    }
}