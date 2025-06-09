import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_manager/models/transaction.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addTransaction(AppTransaction transaction) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .add({
          ...transaction.toMap(),
          'userId': user.uid, // Dodajemy ID użytkownika
          'timestamp': FieldValue.serverTimestamp(), // Dodajemy timestamp
        });
  }

  Stream<List<AppTransaction>> getTransactions() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => AppTransaction.fromMap(doc.data()))
                  .toList(),
        );
  }
}
