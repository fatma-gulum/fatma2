import 'package:sixpack30/Models/user.dart';

abstract class AuthRepository {
  Future<User?> getCurrentUser();
  Future<User?> signIn(String email, String password);
  Future<void> signOut();
}

class FakeAuthRepository implements AuthRepository {
  @override
  Future<User?> getCurrentUser() async {
    return null;
  }

  @override
  Future<User?> signIn(String email, String password) async {
    return User(
      id: '1',
      name: 'Demo User',
      email: email,
    );
  }

  @override
  Future<void> signOut() async {
    return;
  }
}

