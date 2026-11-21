import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_reload_system_admin/src/app.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_strings.dart';
import 'package:smart_reload_system_admin/src/core/constants/constant.dart';
import 'package:smart_reload_system_admin/src/core/error/error_logger.dart';
import 'package:smart_reload_system_admin/src/injection_container.dart' as di;
import 'package:window_manager/window_manager.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
      ),
    );

    // Optional: set window options
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1200, 700),
      minimumSize: Size(1200, 700),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      title: AppStrings.brandName,
    );


    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    await di.init();
    debugPrint("Firebase Connected!");
    await clearFirestoreCache();

    runApp(App(theme: ThemeMode.dark));
  }, (e, st) =>
      errorLog(
        e,
        location: 'Main.main method',
        stackTrace: st,
      )
  );
}

Future<void> clearFirestoreCache() async {
  final FirebaseFirestore fireStore = di.sl<FirebaseFirestore>();
  try {
    await fireStore.clearPersistence();
    debugPrint("Firestore cache cleared successfully.");
  } catch (e) {
    debugPrint("Failed to clear Firestore cache: $e");
  }
}
