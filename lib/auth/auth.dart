import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = cred.user;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        print("Verification email sent to ${user.email}");
        
      }

      return user;
    } on FirebaseAuthException catch (e) {
      print("Signup error: ${e.code} - ${e.message}");
      rethrow; // propagate to UI
    } catch (e) {
      print("Unexpected signup error: $e");
      rethrow;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = cred.user;

      if (user != null && !user.emailVerified) {
        await _auth.signOut();
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message:
              'Email not verified. Please check your inbox and verify your email.',
        );
      }

      return user;
    } on FirebaseAuthException catch (e) {
      print("Login error: ${e.code} - ${e.message}");
      rethrow;
    } catch (e) {
      print("Unexpected login error: $e");
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      print("User logged out successfully");
    } catch (e) {
      print("Logout error: $e");
      rethrow;
    }
  }

  User? get currentUser => _auth.currentUser;
}
