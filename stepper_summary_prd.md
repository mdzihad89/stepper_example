# 📄 Project Requirement Document

## 1. Project Overview
We are building a **multi-step form application** in Flutter using **GetX** state management.  

The app will guide users through **six unique steps (steppers)**. Each step will:

- Allow the user to **pick one or multiple images** from the device.  
- Allow the user to enter **text input**.  
- Send both **list of images and text** to the server via a multipart `POST` request.  
- Display the **server response summary** in a **TextField** (editable).  
- Store only:  
  - **Step name**  
  - **Final summary** (original or edited).  

Users can:
- Navigate **forward or backward** between steps.  
- If the user moves forward without calling the API, the step is considered **skipped** and stored as empty.  
- **Re-trigger API calls** when revisiting steps.  
- At the final step, review **all step summaries in a list**.  
- **Support dummy network calls** for testing using `Future.delayed` to simulate API latency.  

---

## 2. Technologies

- **Frontend**: Flutter (latest stable version)  
- **State Management**: GetX  
- **Image Picker**: `image_picker` package (multiple file selection enabled)  
- **HTTP Networking**: `dio` package (multipart POST requests)  
- **Backend**: API server (provided by backend team)  
- **Dummy Network Simulation**: `Future.delayed` in Flutter for testing without server  

---

## 3. Functional Requirements

### 3.1 Stepper Flow
- The app contains **6 steppers** with unique names:  
  

- User can:  
  - Go **Next** to move forward.  
  - Go **Back** to revisit previous steps.  
  - Moving forward without API call = **skip step**.  

---

### 3.2 Step Workflow (per step)

1. **File & Text Input**  
   - User selects **one or multiple images**.  
   - User enters **optional text input**.  

2. **API Request**  
   - Data is uploaded via `multipart/form-data`:  
     - Field: `files[]` → list of image files  
     - Field: `text` → string input  

   Example:  
   ```
   POST /process-step
   Content-Type: multipart/form-data
   Body:
     files[]: [file1.jpg, file2.jpg, ...]
     text: "user entered text"
   ```  

   - **Dummy Network Simulation**: Use `Future.delayed(Duration(seconds: 2))` to simulate API latency for testing without server.  

3. **API Response**  
   - The server returns only a **summary**.  
   ```json
   {
     "summary": "Extracted or processed result"
   }
   ```  

4. **Response Handling**  
   - Show summary text in a **TextField**.  
   - If untouched → store **original summary**.  
   - If edited → store **edited summary**.  

5. **Runtime Storage**  
   - Store only:  
     - Step name  
     - Final summary (original or edited)  
   - Updates happen in **real time** as user edits.  

6. **Revisiting Step**  
   - Previously saved summary prefilled in TextField.  
   - Option to re-upload files and re-fetch summary.  

---

### 3.3 Final Step (Step F or Summary)
- Display a **ListView** of all step names with their stored summaries.  
- Allow user to review before final submission.  

---

## 4. Non-Functional Requirements
- **Data Persistence**:  
  - Runtime storage via GetX.  
---

## 5. API Contract

- **Endpoint**: `POST /process-step`  
- **Request (multipart/form-data)**:  
  - `files[]`: list of image files  
  - `text`: string  

- **Response**:  
  ```json
  {
    "summary": "Processed summary text"
  }
  ```  

---

## 6. Data Model

```dart
class StepResponse {
  final String stepName;   // e.g., "Step A"
  String summary;          // Final summary (server OR edited)
  bool isCompleted;        // True if user completed this step

  StepResponse({
    required this.stepName,
    this.summary = "",
    this.isCompleted = false,
  });
}
```

---

## 7. State Management (GetX)

- **Controller**: `StepController`  
  - Holds list of `StepResponse` for all 6 steps.  
  - Methods:  
    - `pickFiles(stepName)`  
    - `submitStep(stepName, files, text)`  
    - `updateSummary(stepName, value)`  
    - `getFinalSummaries()`  

---

## 8. UI Design (High-Level)

- **Stepper Navigation**  
  - Progress indicator at top (current step highlighted).  

- **Step Screen**  
  - File picker (multiple image support).  
  - Text input field (user’s own text).  
  - Upload button (trigger API / dummy network call).  
  - Summary TextField (editable, prefilled if revisited).  
  - Next and Back buttons.  

- **Final Screen**  
  - List of steps with their stored summaries.  
  - Submit button.  

---

## 9. Example User Flow

1. User opens Step A → Picks multiple images + enters text → Uploads → Gets summary → Edits → Proceeds.  
2. User moves forward from Step B without upload → Step B marked as skipped (empty summary).  
3. User reaches Step F → Sees list of Step A (edited), Step B (empty), … Step E.  
4. User goes back to Step B → Uploads files + text → Gets summary → Edits → Proceeds again.  
5. Step F updates summary list automatically.  
6. Dummy network calls can be simulated with `Future.delayed(Duration(seconds: 2))` for testing.  

---

## 10. Deliverables

- Flutter app with GetX state management  
- API integration with multipart request (list of files + text)  
- Editable summary handling per step  
- Stepper navigation with back/next (skip is implicit)  
- Final step summary list  
- Dummy network simulation using `Future.delayed`


