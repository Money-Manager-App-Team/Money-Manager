import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, User, UserCredential;
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Rejestracja
  Future<User?> register(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Aktualizacja displayName w Firebase Auth
      await userCredential.user?.updateDisplayName(displayName);

      // Zapis dodatkowych danych w Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'displayName': displayName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  // Logowanie - TUTAJ dodaj tę metodę
  Future<User?> login(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  // Wylogowanie
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Reset hasła
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Aktualny użytkownik
  User? get currentUser => _auth.currentUser;
}
