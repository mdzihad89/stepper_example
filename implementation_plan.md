# Implementation Plan: Multi-Step Form App

This document outlines the development plan for the Flutter multi-step form application based on the project requirement document.

## Phase 1: Project Setup & Dependencies

1.  **Initialize Flutter Project:**
    *   Ensure a new Flutter project is created and cleaned up.
2.  **Add Dependencies:**
    *   Open `pubspec.yaml`.
    *   Add the following packages:
        *   `get`: For state management.
        *   `image_picker`: For picking images from the device gallery.
        *   `dio`: For making multipart HTTP requests.
3.  **Folder Structure:**
    *   Create the following directories inside `lib/`:
        *   `app/`: For core application logic.
            *   `controllers/`: For GetX controllers.
            *   `data/`: For data models and providers.
            *   `ui/`: For widgets and screens.
                *   `screens/`: For main app screens.
                *   `widgets/`: For reusable widgets.

## Phase 2: Data Models & State Management (GetX)

1.  **Create `StepResponse` Model:**
    *   Create `lib/app/data/models/step_response.dart`.
    *   Implement the `StepResponse` class as defined in the PRD.
2.  **Implement `StepController`:**
    *   Create `lib/app/controllers/step_controller.dart`.
    *   Define the `StepController` class extending `GetxController`.
    *   Initialize a reactive list of `StepResponse` objects for the 6 steps.
    *   Stub out the required methods:
        *   `pickFiles(String stepName)`
        *   `submitStep(String stepName, List<dynamic> files, String text)`
        *   `updateSummary(String stepName, String value)`
        *   `getFinalSummaries()`
        *   `goToNextStep()`
        *   `goToPreviousStep()`
        *   `currentStepIndex` (as a reactive variable `RxInt`).

## Phase 3: UI - Step Screen

1.  **Create `StepWidget`:**
    *   Create a reusable widget `lib/app/ui/widgets/step_widget.dart`.
    *   This widget will represent the content of a single step.
    *   It will take the `stepName` and the corresponding `StepResponse` object as parameters.
2.  **Implement UI Components:**
    *   **Image Picker Button:** A button that calls the `pickFiles` method in the `StepController`.
    *   **Selected Images Display:** A view to show thumbnails of the selected images.
    *   **Text Input:** A `TextField` for the user's optional text.
    *   **Upload Button:** A button to trigger the `submitStep` method.
    *   **Summary Display:** A `TextField` to display the summary from the server. It should be pre-filled if the step was previously completed. It will call `updateSummary` on edit.
    *   **Loading Indicator:** Show a loading spinner while the API call is in progress.

## Phase 4: UI - Stepper Navigation & Main Screen

1.  **Create `MainScreen`:**
    *   Create `lib/app/ui/screens/main_screen.dart`.
    *   This will be the main view of the application.
2.  **Implement Stepper UI:**
    *   Use a `PageView` or a similar widget to manage the different step screens. The `currentStepIndex` from the `StepController` will control the active page.
    *   Display the `StepWidget` for the current step.
3.  **Navigation Controls:**
    *   Add "Next" and "Back" buttons.
    *   These buttons will call `goToNextStep()` and `goToPreviousStep()` in the `StepController`.
    *   The "Next" button should be disabled until the user is on the last step.
4.  **Progress Indicator:**
    *   Add a visual indicator at the top to show the current step number (e.g., 1 of 6).

## Phase 5: API Integration & Logic

1.  **Implement `pickFiles`:**
    *   In `StepController`, implement the logic to use the `image_picker` package to select multiple images.
    *   Store the selected files in a temporary variable within the controller.
2.  **Implement `submitStep`:**
    *   This method will be responsible for the core logic of a step.
    *   **Dummy Network Call:** Use `Future.delayed` to simulate a 2-second network request.
    *   **Multipart Request (with `dio`):**
        *   Create a `FormData` object.
        *   Append the list of selected image files (`files[]`).
        *   Append the user's text (`text`).
        *   (Initially, this can be commented out or placed behind a flag to use the dummy call).
    *   **Response Handling:**
        *   On successful "response", extract the `summary`.
        *   Update the `summary` and `isCompleted` fields of the corresponding `StepResponse` object in the reactive list.
3.  **Implement `updateSummary`:**
    *   This method will be called by the `onChanged` callback of the summary `TextField`.
    *   It will update the `summary` in the `StepResponse` object for the current step in real-time.

## Phase 6: UI - Final Summary Screen

1.  **Create `SummaryScreen`:**
    *   Create `lib/app/ui/screens/summary_screen.dart`.
    *   This screen will be shown after the last step.
2.  **Display Summaries:**
    *   Use `Obx` or `GetX` to listen to the list of `StepResponse` objects in the `StepController`.
    *   Display a `ListView.builder` that shows each `stepName` and its corresponding `summary`.
    *   If a summary is empty, display "Skipped".
3.  **Navigation:**
    *   Add a "Back" button to return to the last step.
    *   Add a final "Submit" button (functionality can be a placeholder, e.g., a print statement).

## Phase 7: Refinement and Testing

1.  **Code Cleanup:**
    *   Review all code for clarity, consistency, and adherence to best practices.
    *   Add comments where necessary.
2.  **Manual Testing:**
    *   **Flow 1:** Complete all steps sequentially, editing some summaries. Verify the final summary screen.
    *   **Flow 2:** Skip a step by pressing "Next" without uploading. Verify it's marked as "Skipped".
    *   **Flow 3:** Go back to a completed step, re-upload, and check if the summary updates.
    *   **Flow 4:** Go back to a skipped step and complete it. Verify the final list updates.
    *   Test image picking and text input on each step.
