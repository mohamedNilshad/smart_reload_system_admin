// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ErrorLogger {

  static void log(Object error, {String? location, StackTrace? stackTrace}) {
    String type = 'Unknown';
    String message = 'Something went wrong';

    // if (error is FirebaseAuthException) {
    //   type = 'Firebase auth';
    //   message = _firebaseAuthMessage(error);
    // } else if (error is FirebaseException) {
    //   type = _firebaseType(error.plugin);
    //   message = _firebaseMessage(error);
    // } else if (error is FormatException) {
    //   type = 'Format';
    //   message = error.message;
    // } else if (error is Exception) {
    //   type = 'Exception';
    //   message = error.toString();
    // }

    debugPrint(
      '❌ [$type]'
          '${location != null ? ' [$location]' : ''}: $message',
    );

    if (kDebugMode && stackTrace != null) {
      debugPrint('StackTrace: $stackTrace');
    }
  }

  // static String _firebaseAuthMessage(FirebaseAuthException error) {
  //   switch (error.code) {
  //     case 'invalid-credential':
  //       return 'Invalid email or password';
  //
  //     case 'invalid-email':
  //       return 'Invalid email address';
  //
  //     case 'user-not-found':
  //       return 'User account not found';
  //
  //     case 'wrong-password':
  //       return 'Incorrect password';
  //
  //     case 'email-already-in-use':
  //       return 'Email address is already in use';
  //
  //     case 'weak-password':
  //       return 'Password is too weak';
  //
  //     case 'user-disabled':
  //       return 'This account has been disabled';
  //
  //     case 'too-many-requests':
  //       return 'Too many requests. Please try again later';
  //
  //     case 'network-request-failed':
  //       return 'No internet connection';
  //
  //     default:
  //       return error.message ?? 'Authentication error';
  //   }
  // }

  static String _firebaseType(String plugin) {
    switch (plugin) {
      case 'cloud_firestore':
        return 'Firestore';

      case 'firebase_database':
        return 'Firebase Database';

      case 'firebase_storage':
        return 'Firebase Storage';

      case 'firebase_messaging':
        return 'Firebase Messaging';

      default:
        return 'Firebase';
    }
  }

  // static String _firebaseMessage(FirebaseException error) {
  //   switch (error.code) {
  //     case 'permission-denied':
  //       return 'Permission denied';
  //
  //     case 'not-found':
  //       return 'Document or data not found';
  //
  //     case 'unavailable':
  //       return 'Service temporarily unavailable';
  //
  //     case 'network-request-failed':
  //       return 'No internet connection';
  //
  //     case 'already-exists':
  //       return 'Data already exists';
  //
  //     case 'cancelled':
  //       return 'Operation was cancelled';
  //
  //     case 'deadline-exceeded':
  //       return 'Request timed out';
  //
  //     default:
  //       return error.message ?? 'Firebase operation failed';
  //   }
  // }
}