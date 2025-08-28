import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stepper_example/app/controllers/step_controller.dart';

class StepWidget extends StatelessWidget {
  final int stepIndex;

  const StepWidget({super.key, required this.stepIndex});

  @override
  Widget build(BuildContext context) {
    // Find the controller
    final controller = Get.find<StepController>();

    // Get the specific step data
    final stepData = controller.steps[stepIndex];

    // Controller for the text input, initialized with stored text
    final textController = TextEditingController(text: stepData.optionalText);
    // Controller for the summary input
    final summaryController = TextEditingController(text: stepData.summary);

    // Local state for editing summary
    final RxBool isEditingSummary = false.obs;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step ${stepIndex + 1}: ${stepData.stepName}',
            style: Get.textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => controller.pickFiles(), // Use controller's pickFiles
            icon: const Icon(Icons.photo_library),
            label: const Text('Select Images'),
          ),
          const SizedBox(height: 10),
          // --- Display Selected Images from controller ---
          Obx(() {
            final currentStep = controller.steps[stepIndex];
            if (currentStep.selectedFiles.isEmpty) {
              return const Text('No images selected.');
            }
            return Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: currentStep.selectedFiles.map((file) {
                return Chip(
                  label: Text(file.name, overflow: TextOverflow.ellipsis),
                  avatar: CircleAvatar(
                    backgroundImage: FileImage(File(file.path)),
                  ),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () {
                    controller.removeSelectedFile(stepIndex, file);
                  },
                );
              }).toList(),
            );
          }),
          const SizedBox(height: 20),
          // --- Text Input ---
          TextField(
            controller: textController,
            onChanged: (value) => controller.updateOptionalText(value), // Real-time update
            decoration: const InputDecoration(
              labelText: 'Optional Text Input',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          // --- API Request Trigger ---
          Obx(
            () => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: ElevatedButton.icon(
                      onPressed: controller.steps[stepIndex].selectedFiles.isEmpty
                          ? null // Disable button if no files are selected
                          : () {
                              controller.submitStep(); // No parameters needed
                            },
                      icon: const Icon(Icons.cloud_upload),
                      label: const Text('Upload & Get Summary'),
                    ),
                  ),
          ),
          // --- API Response Handling ---
          Obx(() {
            final currentStep = controller.steps[stepIndex];
            if (!currentStep.isCompleted) {
              return const SizedBox.shrink();
            }

            summaryController.text = currentStep.summary;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Response Summary', style: Get.textTheme.titleLarge),
                    // Show Edit or Save button based on state
                    Obx(() => isEditingSummary.value
                        ? IconButton(
                            icon: const Icon(Icons.check_circle, color: Colors.green),
                            onPressed: () {
                              isEditingSummary.value = false;
                            },
                          )
                        : IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              isEditingSummary.value = true;
                            },
                          )),
                  ],
                ),
                const SizedBox(height: 10),
                // Conditionally show either the TextField or the Container
                Obx(() => isEditingSummary.value
                    ? TextField(
                        controller: summaryController,
                        maxLines: 3,
                        autofocus: true,
                        onChanged: (value) => controller.updateSummary(value),
                        decoration: const InputDecoration(
                          labelText: 'Editable Summary',
                          hintText: 'Server response will appear here...',
                          border: OutlineInputBorder(),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(summaryController.text.isEmpty
                            ? 'No summary available.'
                            : summaryController.text),
                      )),
              ],
            );
          }),
        ],
      ),
    );
  }
}