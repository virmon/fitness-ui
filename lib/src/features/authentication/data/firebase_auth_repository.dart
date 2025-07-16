import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  AuthRepository(this._auth);
  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> signInWithGoogleAuth(AuthProvider provider) {
    return _auth.signInWithProvider(provider);
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        return userCredential.user;
      } else {
        return await Future.error('Sign-in cancelled or failed');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<User?> signInWithGooglePopUp() async {
    try {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      UserCredential userCredential = await _auth.signInWithPopup(authProvider);
      return userCredential.user;
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<String?> getNewIdToken() async {
    String? newIdToken;
    if (currentUser != null) {
      newIdToken = await currentUser!.getIdToken(true);
    }
    return newIdToken;
  }

  Future<void> signOut() async {
    return _auth.signOut();
  }
}

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
});

final authStateChangesProvider = Provider<Stream<User?>>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});
