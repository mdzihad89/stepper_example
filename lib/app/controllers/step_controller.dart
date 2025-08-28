import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../data/models/step_response.dart';

class StepController extends GetxController {
  // Reactive list to hold the state of all 6 steps
  final steps = <StepResponse>[
    StepResponse(stepName: 'Step A'),
    StepResponse(stepName: 'Step B'),
    StepResponse(stepName: 'Step C'),
    StepResponse(stepName: 'Step D'),
    StepResponse(stepName: 'Step E'),
    StepResponse(stepName: 'Step F'),
  ].obs;

  // Reactive index to track the current step
  final currentStepIndex = 0.obs;

  // Loading indicator for API calls
  final isLoading = false.obs;

  // For testing: set to true to simulate API failure
  final bool _simulateApiFailure = false;

  // Loading indicator for final submission
  final isSubmittingAll = false.obs;

  // --- Methods --- //

  /// Picks one or multiple images from the device gallery.
  Future<void> pickFiles() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultipleMedia();
    if (images.isNotEmpty) {
      steps[currentStepIndex.value].selectedFiles = images;
      steps.refresh(); // Refresh the list to make sure UI updates
    }
  }

  /// Updates the optional text for the current step in real-time.
  void updateOptionalText(String value) {
    steps[currentStepIndex.value].optionalText = value;
  }

  /// Submits the data for the current step to the (dummy) server.
  Future<void> submitStep() async {
    isLoading.value = true;
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // --- Simulate API Failure ---
      if (_simulateApiFailure) {
        throw Exception('Simulated API Failure: Network unreachable.');
      }
      // --- End Simulate API Failure ---

      final currentStep = steps[currentStepIndex.value];

      // ONLY update the step data if the API call is successful
      // The optionalText and selectedFiles are already updated in real-time

      // Dummy response using the stored text and files from the current step object
      final summary = 
          "Summary for ${currentStep.stepName}: Text was '${currentStep.optionalText}' and ${currentStep.selectedFiles.length} images were uploaded.";

      // Update the step data
      currentStep.summary = summary;
      currentStep.isCompleted = true;
      steps.refresh(); // Notify listeners about the change in the list item
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to generate summary: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Updates the summary for a specific step in real-time.
  void updateSummary(String value) {
    final currentStep = steps[currentStepIndex.value];
    if (currentStep.summary != value) {
      currentStep.summary = value;
      steps.refresh(); // Notify listeners
    }
  }

  /// Returns the list of all final summaries.
  List<StepResponse> getFinalSummaries() {
    return steps.toList();
  }

  /// Navigates to the next step.
  void goToNextStep() {
    if (currentStepIndex.value < steps.length - 1) {
      currentStepIndex.value++;
    }
  }

  /// Navigates to the previous step.
  void goToPreviousStep() {
    if (currentStepIndex.value > 0) {
      currentStepIndex.value--;
    }
  }

  /// Removes a selected file from a specific step.
  void removeSelectedFile(int stepIndex, XFile fileToRemove) {
    if (stepIndex >= 0 && stepIndex < steps.length) {
      final currentStep = steps[stepIndex];
      currentStep.selectedFiles.removeWhere((file) => file.path == fileToRemove.path);
      steps.refresh(); // Notify listeners
    }
  }

  /// Simulates final submission of all data.
  Future<bool> submitAllData() async {
    isSubmittingAll.value = true;
    try {
      // Simulate network delay for final submission
      await Future.delayed(const Duration(seconds: 3));

      // --- Simulate Final API Failure (for testing) ---
      // You can set this to true to test failure
      bool simulateFinalApiFailure = false;
      if (simulateFinalApiFailure) {
      }
      // --- End Simulate Final API Failure ---

      // Here you would typically send all collected data (steps) to your backend
      // For now, just log it
      print('Submitting all data:');
      for (var step in steps) {
        print('  ${step.stepName}: Summary="${step.summary}", Text="${step.optionalText}", Files=${step.selectedFiles.length}');
      }

      return true; // Indicate success
    } catch (e) {
      // Error snackbar is handled by MainScreen
      return false; // Indicate failure
    } finally {
      isSubmittingAll.value = false;
    }
  }
}
