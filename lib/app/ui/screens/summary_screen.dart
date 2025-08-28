import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stepper_example/app/controllers/step_controller.dart';

import 'package:stepper_example/app/ui/screens/welcome_screen.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StepController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Final Summary'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove default back button
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.steps.length,
          itemBuilder: (context, index) {
            final step = controller.steps[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                  step.stepName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(step.summary.isEmpty ? 'Skipped' : step.summary),
                isThreeLine: step.summary.isNotEmpty,
                trailing: Icon(
                  step.isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: step.isCompleted ? Colors.green : Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            // Use Column to stack buttons
            mainAxisSize: MainAxisSize.min, // Make column take minimum space
            children: [
              ElevatedButton(
                onPressed: () {
                  Get.snackbar(
                    'Submitted!',
                    'Your data has been successfully submitted.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: const Text('Submit All'),
              ),
              const SizedBox(height: 10), // Spacing between buttons
              ElevatedButton(
                onPressed: () {
                  Get.offAll(
                    () => const WelcomeScreen(),
                  ); // Navigate back to WelcomeScreen
                },
                child: const Text('Back to Welcome Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
