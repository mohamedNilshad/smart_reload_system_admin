import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_auth/firebase_auth.dart';

String mapFirebaseError(fb.FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-credential':
    case 'wrong-password':
      return 'Incorrect email or password.';
    case 'user-not-found':
      return 'No account found.';
    case 'invalid-email':
      return 'Invalid email address.';
    case 'user-disabled':
      return 'This account has been disabled.';
    case 'too-many-requests':
      return 'Too many failed attempts. Please try again later.';
    case 'email-already-in-use':
      return 'An account with this email already exists.';
    case 'weak-password':
      return 'Password is too weak.';
    default:
      return e.message ?? 'Authentication error occurred.';
  }
}

String mapFirestoreError(FirebaseException e) {
  switch (e.code) {
    case 'permission-denied':
      return 'You do not have permission to perform this action.';
    case 'unavailable':
      return 'Service is temporarily unavailable. Check your internet connection.';
    case 'not-found':
      return 'The requested record could not be found.';
    case 'already-exists':
      return 'This record already exists.';
    case 'unauthenticated':
      return 'Session expired. Please log in again.';
    case 'deadline-exceeded':
      return 'The request timed out. Please try again.';
    case 'cancelled':
      return 'The operation was cancelled.';
    case 'resource-exhausted':
      return 'Database quota exceeded. Please try again later.';
    case 'failed-precondition':
      return 'Operation failed due to a missing index or invalid state.';
    case 'aborted':
      return 'The operation was aborted due to a conflict. Please try again.';
    case 'invalid-argument':
      return 'Invalid data was submitted.';
    default:
      return e.message ?? 'A database error occurred.';
  }
}

String firebaseType(String plugin) {
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