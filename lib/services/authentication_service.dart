import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Rejestracja usera
  Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Błąd rejestracji: $e');
      return null;
    }
  }

  //logowanie
  Future<User?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Błąd logowania: $e');
      return null;
    }
  }

  //logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //sprawdzenie czy użytkownik jest zalogowany
  Stream<User?> get user {
    return _auth.authStateChanges();
  }
}