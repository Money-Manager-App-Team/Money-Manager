import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'Brak danych';
    final creationTime = user?.metadata.creationTime?.toString().substring(0, 10) ?? 'Brak daty';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Email: $email', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text('Data rejestracji: $creationTime', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
