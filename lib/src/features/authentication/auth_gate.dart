import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:fitness_ui/src/features/authentication/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProviders = ref.watch(authProvidersProvider);
    return Scaffold(
      body: SignInScreen(
        providers: authProviders,
      ),
    );
  }
}
