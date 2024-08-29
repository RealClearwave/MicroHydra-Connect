import 'package:flutter/material.dart';
import 'package:mhconnect/view/home/home_view.dart';
import 'package:mhconnect/config.dart';  // Import the configuration file where MH_URL is defined

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MicroHydra Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Start with IPInputScreen instead of HomeView
      home: const IPInputScreen(),
    );
  }
}

class IPInputScreen extends StatefulWidget {
  const IPInputScreen({super.key});

  @override
  State<IPInputScreen> createState() => _IPInputScreenState();
}

class _IPInputScreenState extends State<IPInputScreen> {
  final TextEditingController _ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter MicroHydra IP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _ipController,
              decoration: const InputDecoration(
                labelText: 'MicroHydra IP Address',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_ipController.text.isNotEmpty) {
                  // Update MH_URL with the entered IP
                  MH_URL = _ipController.text;

                  // Navigate to HomeView after updating the URL
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeView(),
                    ),
                  );
                } else {
                  // Show a snackbar or dialog if the input is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid IP address'),
                    ),
                  );
                }
              },
              child: const Text('Save and Continue'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }
}
