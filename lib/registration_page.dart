import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1976D2), // Blue color
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'Money Manager',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'REJESTRACJA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // LOGIN
                _buildTextField(label: 'LOGIN'),

                const SizedBox(height: 20),

                // EMAIL
                _buildTextField(label: 'ADRES E-MAIL'),

                const SizedBox(height: 20),

                // PASSWORD
                _buildTextField(label: 'HASŁO', obscure: true),

                const SizedBox(height: 20),

                // Already have an account?
                const Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('JUZ MASZ KONTO?', style: TextStyle(fontSize: 12)),
                      Text(
                        'ZALOGUJ SIĘ',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Register Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    backgroundColor: Colors.grey[200],
                  ),
                  onPressed: () {
                    // TODO: Registration logic here
                  },
                  child: const Text(
                    'Zarejestruj się',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextField(
          obscureText: obscure,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }
}
