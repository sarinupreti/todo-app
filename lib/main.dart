import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:withu_todo/non_ui/globals/navigation.dart';
import 'package:withu_todo/non_ui/provider/tasks.dart';
import 'package:withu_todo/non_ui/repository/firebase_manager.dart';
import 'package:withu_todo/ui/pages/home.dart';
import 'package:withu_todo/ui/widgets/error_widget.dart';

const title = 'WithU';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runZonedGuarded(() {
    runApp(FirebaseApp());
  }, (error, stackTrace) {
    print('runZonedGuarded: Caught error in my root zone.');
  });
}

class FirebaseApp extends StatefulWidget {
  @override
  _FirebaseAppState createState() => _FirebaseAppState();
}

class _FirebaseAppState extends State<FirebaseApp> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  Future<void> _initializeFlutterFire() async {
    // Wait for Firebase to initialize
    await FirebaseManager.shared.initialise();

    // Pass all uncaught errors to Crashlytics.
    Function originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      // Forward to original handler.
      originalOnError(errorDetails);
    };
  }

  // Define an async function to initialize FlutterFire
  void initialize() async {
    if (_error) {
      setState(() {
        _error = false;
      });
    }

    try {
      await _initializeFlutterFire();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error || !_initialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        home: Scaffold(
          body: _error
              ? ErrorMessage(
                  message: "Problem initialising the app",
                  buttonTitle: "RETRY",
                  onTap: initialize,
                )
              : Container(),
        ),
      );
    }
    return App();
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        scaffoldMessengerKey: globalScafoldMessengerKey,
        navigatorKey: globalNavigatorKey,
        title: title,
        theme: customTheme(),
        home: HomeTabsPage(),
      ),
    );
  }

  ThemeData customTheme() {
    return ThemeData(
      textTheme: TextTheme(
        headline1: TextStyle(
            fontFamily: "Poppins", fontSize: 30, fontWeight: FontWeight.w700),
        headline2: TextStyle(
            fontFamily: "Poppins", fontSize: 24, fontWeight: FontWeight.w700),
        headline3: TextStyle(
            fontFamily: "Poppins", fontSize: 22, fontWeight: FontWeight.w700),
        headline4: TextStyle(
            fontFamily: "Poppins", fontSize: 20, fontWeight: FontWeight.w700),
        headline5: TextStyle(
            fontFamily: "Poppins", fontSize: 18, fontWeight: FontWeight.w700),
        headline6: TextStyle(
            fontFamily: "Poppins", fontSize: 16, fontWeight: FontWeight.w700),
        subtitle1: TextStyle(
            fontFamily: "Poppins", fontSize: 16, fontWeight: FontWeight.w500),
        subtitle2: TextStyle(
            fontFamily: "Poppins", fontSize: 14, fontWeight: FontWeight.w500),
        bodyText1: TextStyle(
            fontFamily: "Poppins", fontSize: 12, fontWeight: FontWeight.w500),
        bodyText2: TextStyle(
            fontFamily: "Poppins", fontSize: 10, fontWeight: FontWeight.w500),
        button: TextStyle(
            fontFamily: "Poppins", fontWeight: FontWeight.w700, fontSize: 14),
        caption: TextStyle(fontFamily: "Poppins"),
        overline: TextStyle(fontFamily: "Poppins"),
      ),
    );
  }
}
