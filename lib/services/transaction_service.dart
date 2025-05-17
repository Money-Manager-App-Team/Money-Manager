import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_manager/models/transaction.dart';
import 'package:money_manager/firebase_options.dart';

class TransactionService {
  static final TransactionService _instance = TransactionService._internal();
  factory TransactionService() => _instance;

  TransactionService._internal();

  final List<AppTransaction> _localTransactions = [];

  final bool _firebaseAvailable = DefaultFirebaseOptions.currentPlatformOrNull != null;

  Future<void> addTransaction(AppTransaction transaction) async {
    _localTransactions.insert(0, transaction);

    if (_firebaseAvailable) {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('transactions').add(transaction.toMap());
    }
  }

  Stream<List<AppTransaction>> getTransactions() {
    if (_firebaseAvailable) {
      return FirebaseFirestore.instance
          .collection('transactions')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => AppTransaction.fromMap(doc.data()))
              .toList());
    }

    return Stream<List<AppTransaction>>.periodic(
      const Duration(milliseconds: 500),
      (_) => List.unmodifiable(_localTransactions),
    ).asBroadcastStream();
  }
}
