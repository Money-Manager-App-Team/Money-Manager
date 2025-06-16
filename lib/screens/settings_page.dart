import 'package:flutter/material.dart';

class OptionsPage extends StatefulWidget {

  const OptionsPage({
    super.key,
  });

  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia'),
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
      ),      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Test 1'),
            trailing: Switch(
              value: false,
              onChanged: (_) {},
            ),
          ),
          ListTile(
            title: const Text('Test 2'),
            trailing: Switch(
              value: false,
              onChanged: (_) {},
            ),
          ),
          ListTile(
            title: const Text('Test 3'),
            trailing: Switch(
              value: false,
              onChanged: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}
