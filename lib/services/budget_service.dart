import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_manager/models/budget.dart';

class BudgetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<Budget> get budgetStream {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(Budget(max: 0, value: 0));

    return _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map(
          (doc) =>
              doc.exists
                  ? Budget.fromMap(doc.data()?['budget'] ?? {})
                  : Budget(max: 1000, value: 0),
        );
  }

  get budget => null;

  Future<void> updateBudget(Budget newBudget) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).set({
      'budget': newBudget.toMap(),
    }, SetOptions(merge: true));
  }
}
