import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_reload_system_admin/src/core/error/firebase_exceptions.dart';

void errorLog(Object error, {String? location, StackTrace? stackTrace}) {
  String type = 'Unknown';
  String message = 'Something went wrong';

  if (error is FirebaseAuthException) {
    type = 'Firebase auth';
    message = mapFirebaseError(error);
  } else if (error is FirebaseException) {
    type = firebaseType(error.plugin);
    message = mapFirestoreError(error);
  } else if (error is FormatException) {
    type = 'Format';
    message = error.message;
  } else if (error is Exception) {
    type = 'Exception';
    message = error.toString();
  }

  debugPrint(
    '❌ [$type]'
        '${location != null ? ' [$location]' : ''}: $message',
  );

  if (kDebugMode && stackTrace != null) {
    debugPrint('StackTrace: $stackTrace');
  }
}
