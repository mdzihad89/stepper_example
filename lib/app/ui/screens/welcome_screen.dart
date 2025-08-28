import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stepper_example/app/ui/screens/main_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Multi-Step Form App!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Get.off(() => const MainScreen()); // Navigate to MainScreen and remove WelcomeScreen from stack
              },
              child: const Text('Start Form'),
            ),
          ],
        ),
      ),
    );
  }
}
