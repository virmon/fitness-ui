import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppUserRepository {
  AppUserRepository(this.ref);
  Ref ref;
}

final appUserRepositoryProvider = Provider<AppUserRepository>((ref) {
  return AppUserRepository(ref);
});
