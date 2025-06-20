import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:fitness_ui/src/features/authentication/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProviders = ref.watch(authProvidersProvider);

    return ProfileScreen(
      providers: authProviders,
      appBar: AppBar(
        title: Text('Profile'),
      ),
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(2),
          child: AspectRatio(
            aspectRatio: 1,
          ),
        ),
      ],
    );
  }
}
