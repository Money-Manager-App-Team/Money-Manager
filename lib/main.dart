import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'services/authentication_service.dart';


// void main() {
//   runApp(const MyApp());
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Manager',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}


class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState  extends State<LoginScreen> {
  // colntrollers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //instancja authencticationService
  final AuthenticationService _authService = AuthenticationService();

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Login method
  Future<void> _login() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Wprowadź email i hasło';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final user = await _authService.loginWithEmailPassword(
          _emailController.text.trim(),
          _passwordController.text.trim()
      );

      if (user != null) {
        //TODO jak przejdzie logowanie -> do homescreen
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (context) => HomeScreen()),
        // );
        print('Zalogowano pomyślnie: ${user.email}');
      } else {
        setState(() {
          _errorMessage = 'Błąd logowania. Sprawdź dane i spróbuj ponownie.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Wystąpił błąd: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _goToRegistration() {
    //TODO registrationscreen
    print('registrationscreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Górna część – nagłówek
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 50),
            decoration: const BoxDecoration(
              color: Color(0xFF1976D2),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Column(
              children: [
                Text(
                  'Money Manager',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'LOGOWANIE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Środkowa część – formularz
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ADRES E-MAIL',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF3F3F3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'HASŁO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF3F3F3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'NIE PAMIĘTASZ HASŁA',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey.shade500),
                        ),
                      ),
                      child: const Text(
                        'Zaloguj się',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
