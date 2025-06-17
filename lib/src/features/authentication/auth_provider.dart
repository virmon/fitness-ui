import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, AuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

final authProvidersProvider =
    Provider<List<AuthProvider<AuthListener, AuthCredential>>>((ref) {
  return [
    GoogleProvider(
        clientId:
            '1063200645032-kpjebp84ojr7uvjs41vvhhsed5co457c.apps.googleusercontent.com'),
  ];
});
