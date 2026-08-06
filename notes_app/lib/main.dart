// dart:async is a asynchronous library that provides supports for asynchronous programming.
// It handles operations that don't finish immediately, such as network requests, timers, file operations, and streams of data.
import 'dart:async';

// foundation.dart is a core library that provides essential classes and functions for building Flutter applications.
// It includes classes for managing application state, handling errors, and working with asynchronous operations.
import 'package:flutter/foundation.dart';

// material.dart is a library that provides a set of visual, structural, and interactive widgets for building applications 
// It includes widgets that follow the Material design guidelines such as buttons, cards, and navigation drawers.
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/app_initializer.dart';
import 'core/services/logger_service.dart';

/// ============================================================================
/// File: main.dart
/// ============================================================================
///
/// Application Entry Point
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Initializes Flutter.
/// • Configures global error handling.
/// • Initializes application services.
/// • Launches application.
///
/// ============================================================================

void main() {

  // runZonedGuarded is a function that runs a block of code in a new zone and catches any uncaught errors that occur within that zone.
  // new zone is an execution context that allows to manage and isolate asynchronous operations, error handling, and other behaviors.
  runZonedGuarded(

    // () async is an asynchronous function that returns a Future. It allows to use the await keyword to wait for asynchronous operations to complete before proceeding.
    () async {

      // WidgetsFlutterBinding is a class that provides access to the Flutter engine and framework.
      // It is responsible for initializing the Flutter framework, managing the widget tree, and handling input events.
      WidgetsFlutterBinding.ensureInitialized();

      // FlutterError is a class that provides methods for handling errors in the Flutter framework. It includes methods for reporting errors, logging errors, and displaying error messages to the user.
      // FlutterError.onError is a callback that is called when an error occurs in the Flutter framework.
      // It allows to handle errors and log them or display them to the user.
      // FlutterErrorDetails is a class that contains information about an error that occurred in the Flutter framework. It includes the detail message, and the exception.
      FlutterError.onError = (FlutterErrorDetails details) {

        // FlutterError.presentError is a method that displays an error message to the user.
        FlutterError.presentError(details);

        // LoggerService.error is a method that logs an error message to the console.
        LoggerService.error(
          'Flutter framework error.',

          // details.exception is a property that contains the exception that caused an error.
          error: details.exception,
          
          // details.stack is a property that contains the stack trace of an error.
          // stack trace is a list of function calls that were active at the time an error occurred.
          // It is used to help diagnose and debug an error.
          stackTrace: details.stack,
        );
      };

      // PlatformDispatcher.instance.onError is a callback that is called when an error occurs in the platform layer.
      // Platform layer is the layer of the Flutter framework that interacts with the underlying operating system and hardware.
      // Object error is a parameter that contains the error that occurred in the platform layer.
      // StackTrace stackTrace is a parameter that contains the stack trace of an error that occurred in the platform layer.
      PlatformDispatcher.instance.onError = (Object error, StackTrace stackTrace) {
            LoggerService.error(
              'Platform error occurred.',

              error: error,

              stackTrace: stackTrace,
            );

            return true;
          };

      // Here, we are using a try-catch block to handle any exceptions that may occur during the application startup process.
      try {

        // LoggerService.info is a method that logs an informational message to the console.
        LoggerService.info('Application startup started.');
        
        // AppInitializer.initialize is a method that initializes the application services.
        await AppInitializer.initialize();

        LoggerService.info('Application services initialized.');
        
        // Here, we are launching the application using the runApp method.
        // runApp is a function that starts the Flutter framework and displays the given widget.
        runApp(const NotesApp());
      } catch (exception, stackTrace) {
        LoggerService.error(
          'Application startup failed.',

          error: exception,

          stackTrace: stackTrace,
        );

        // Here, we are launching an application that displays a startup error screen to the user if the application fails to start.
        runApp(const _StartupErrorApp());
      }
    },

    
    // Here, we are handling any unhandled asynchronous errors that may occur during the application startup process.
    (Object error, StackTrace stackTrace) {
      LoggerService.error(
        'Unhandled asynchronous error.',

        error: error,

        stackTrace: stackTrace,
      );
    },
  );
}

// _StartupErrorApp is a stateless widget that displays a startup error screen to the user if the application fails to start.
// Stateless widget is used to display static content that does not change over time. It is used to display a startup error screen that informs the user that the application failed to start and prompts them to restart the application.
final class _StartupErrorApp extends StatelessWidget {

  // Here, we are defining a constructor for the _StartupErrorApp class which is used to create an instance of the class. 
  // The constructor is used to initialize the properties of the class and set up any necessary dependencies.
  const _StartupErrorApp();

  // @override is a decorator that indicates that the method is used to override a method in a superclass.
  @override

  // Here, we are defining a method called build that returns a widget. The build method is used to create the UI of the application.
  Widget build(BuildContext context) {

    // We are using the MaterialApp widget to create the application's UI.
    return MaterialApp(

      // debugShowCheckedModeBanner is a property that determines whether the debug banner should be displayed in the application.
      debugShowCheckedModeBanner: false,

      // home is a property that specifies the widget that should be displayed when the application starts.
      // Scaffold is a widget that provides a basic visual structure for the application.
      home: Scaffold(

        // body is a property that specifies the widget that should be displayed in the body of the Scaffold and Center is a widget that centers its child widget within the available space.
        body: Center(

          // child is a property that specifies the widget that should be displayed in the center of the available space.
          child: Padding(

            // padding is a property that specifies the amount of space to be added around the child widget.
            padding: const EdgeInsets.all(24),
            
            // Column is a widget that arranges its child widgets in a vertical column.
            child: Column(
              mainAxisSize: MainAxisSize.min,

              // children is a property that specifies the list of child widgets that should be displayed in the column.
              children: <Widget>[

                const Icon(
                  // Icons.error_outline_rounded is a built-in icon in the Flutter framework that represents an error or warning. 
                  // It is used to indicate that an error has occurred and that the user should take actions to resolve the issue.
                  Icons.error_outline_rounded,

                  size: 72,

                  color: Colors.red,
                ),
                
                // SizedBox is a widget that adds empty space between its child widgets. 
                // It is used to create a visual separation between the error icon and the error message.
                const SizedBox(height: 20),

                Text(
                  'Application failed to start.',

                  textAlign: TextAlign.center,

                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 12),

                const Text(
                  'Please restart the application.',

                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
