import 'package:image_picker/image_picker.dart';

class StepResponse {
  final String stepName; // e.g., "Step A"
  String summary; // Final summary (server OR edited)
  bool isCompleted; // True if user completed this step
  List<XFile> selectedFiles = []; // Holds the selected files for this step
  String optionalText = ""; // Holds the user's text input for this step

  StepResponse({
    required this.stepName,
    this.summary = "",
    this.isCompleted = false,
  });
}