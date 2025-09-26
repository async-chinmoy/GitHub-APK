import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user;

    if (user != null) {
      try {
        await user.sendEmailVerification();
      } catch (e) {
        print("Error sending email verification: $e");
      }
    }

    return user;
  }

  Future<User?> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user;

    if (user != null && !user.emailVerified) {
      throw FirebaseAuthException(
        code: 'email-not-verified',
        message:
            'Email not verified. Please check your inbox and verify your email.',
      );
    }

    return user;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
