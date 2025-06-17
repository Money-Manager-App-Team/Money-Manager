import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    // Nie nawigujemy ręcznie - StreamBuilder w main.dart to zrobi
  }

  void _changePassword(BuildContext context) async {
    final TextEditingController passwordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Zmień hasło'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Nowe hasło',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Anuluj'),
            ),
            TextButton(
              onPressed: () async {
                final newPassword = passwordController.text.trim();
                if (newPassword.isNotEmpty && newPassword.length >= 6) {
                  try {
                    await FirebaseAuth.instance.currentUser
                        ?.updatePassword(newPassword);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Hasło zostało zmienione.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Błąd zmiany hasła: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Hasło musi mieć co najmniej 6 znaków.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              child: const Text('Zmień'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'Brak danych';
    final creationTime =
        user?.metadata.creationTime?.toString().substring(0, 10) ?? 'Brak daty';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundImage: const AssetImage('assets/user_avatar.png'),


                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: $email', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              'Data rejestracji: $creationTime',
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text('Wyloguj się'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _changePassword(context),
                icon: const Icon(Icons.lock_reset),
                label: const Text('Zmień hasło'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),

          ],
        ),
      ),
    );
  }
}
