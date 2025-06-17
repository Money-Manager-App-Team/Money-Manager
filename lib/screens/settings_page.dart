import 'package:flutter/material.dart';

class OptionsPage extends StatefulWidget {

  const OptionsPage({
    super.key,
  });

  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  bool btnTest1 = false;
  bool btnTest2 = false;
  bool btnTest3 = false;

  double limitSlider = 1500;

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
              value: btnTest1,
              onChanged: (val) {
                setState(() {
                  btnTest1 = val;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Test 2'),
            trailing: Switch(
              value: btnTest2,
              onChanged: (val) {
                setState(() {
                  btnTest2 = val;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Test 3'),
            trailing: Switch(
              value: btnTest3,
              onChanged: (val) {
                setState(() {
                  btnTest3 = val;
                });
              },
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Testowy slider:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${limitSlider.toStringAsFixed(0)} PLN',
                style: const TextStyle(fontSize: 14),
              ),
              Slider(
                min: 0,
                max: 10000,
                divisions: 100,
                label: limitSlider.toStringAsFixed(0),
                value: limitSlider,
                onChanged: (value) {
                  setState(() {
                    limitSlider = value;
                  });
                },
                onChangeEnd: (_) {
                  // _saveThreshold();
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
