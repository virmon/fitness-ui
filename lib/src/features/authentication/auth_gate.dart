import 'package:fitness_ui/src/features/authentication/application/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            authService.signIn();
          },
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}
