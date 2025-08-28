import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stepper_example/app/controllers/step_controller.dart';
import 'package:stepper_example/app/ui/screens/summary_screen.dart';
import 'package:stepper_example/app/ui/widgets/step_widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StepController());
    final pageController = PageController();

    // Listen to changes in the current step index and update the PageView
    ever(controller.currentStepIndex, (index) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              'Step ${controller.currentStepIndex.value + 1} of ${controller.steps.length}',
            )),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: controller.steps.length,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe navigation
              itemBuilder: (context, index) {
                return StepWidget(stepIndex: index);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    if (controller.currentStepIndex.value > 0)
                      TextButton.icon(
                        onPressed: controller.isLoading.value || controller.isSubmittingAll.value
                            ? null
                            : () => controller.goToPreviousStep(),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Back'),
                      )
                    else
                      const SizedBox(), // Placeholder

                    // Next/Finish Button
                    if (controller.currentStepIndex.value < controller.steps.length - 1)
                      TextButton.icon(
                        onPressed: controller.isLoading.value ||
                                   controller.isSubmittingAll.value ||
                                   (controller.currentStepIndex.value == 0 && !controller.steps[0].isCompleted)
                            ? null
                            : () => controller.goToNextStep(),
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Next'),
                      )
                    else
                      Obx(() => TextButton.icon(
                            onPressed: controller.isSubmittingAll.value || !controller.steps.last.isCompleted
                                ? null // Disable button if submitting OR last step is not completed
                                : () {
                                    Get.defaultDialog(
                                      title: 'Confirm Submission',
                                      middleText: 'Do you want to submit all your data?',
                                      textConfirm: 'Yes',
                                      textCancel: 'No',
                                      confirmTextColor: Colors.white,
                                      onConfirm: () async {
                                        Get.back(); // Close the dialog

                                        bool success = await controller.submitAllData();

                                        if (success) {
                                          Get.offAll(() => const SummaryScreen()); // Use offAll to clear previous routes
                                          Get.snackbar(
                                            'Success',
                                            'All data submitted successfully!',
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white,
                                          );
                                        } else {
                                          Get.snackbar(
                                            'Error',
                                            'Final submission failed.',
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                        }
                                      },
                                      onCancel: () {
                                        // Do nothing, dialog closes
                                      },
                                    );
                                  },
                            icon: controller.isSubmittingAll.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.check_circle),
                            label: controller.isSubmittingAll.value
                                ? const Text('') // No text when loading
                                : const Text('Finish'),
                          )),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}