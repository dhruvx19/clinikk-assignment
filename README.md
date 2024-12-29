# Clinikk Assignment - Flutter Intern

This repository contains a Flutter-based **To-Do App** built as part of the Clinikk assignment. The app allows users to manage tasks locally and demonstrates simple API integration by fetching and displaying data from an open-source API.

---

## Features

### Task Management
- **Add New Tasks**: Users can add tasks with a title.
- **Mark as Complete**: Tasks can be marked complete using a checkbox.
- **Delete Tasks**: Users can delete tasks from the list.
- **Persist Tasks**: Tasks are saved locally using **Shared Preferences**, ensuring data is available across sessions.

### API Integration
- Fetch and display a list of posts from [`https://jsonplaceholder.typicode.com/posts`](https://jsonplaceholder.typicode.com/posts).
- Filter posts by user ID using a search box (e.g., [`https://jsonplaceholder.typicode.com/posts?userId=1`](https://jsonplaceholder.typicode.com/posts?userId=1)).

### Design
- **Material Design** principles followed.
- UI inspired by [Figma Community Design](https://www.figma.com/community/file/1083383246788717048).
- Responsive layout with attention to typography and user experience.

---

## Requirements

- **Flutter SDK**: `>=3.5.0`
- **Dart SDK**: Compatible with Flutter version.
- **Dependencies**:
  - `http`: API integration.
  - `shared_preferences`: Local storage.
  - `provider`: State management.
  - `google_fonts`: Enhanced UI/UX.

---

## Installation

### Prerequisites
1. Install Flutter: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install).
2. Clone this repository:
   ```bash
   git clone https://github.com/dhruvx19/clinikk-assignment.git
   ```
3. Navigate to the project directory:
   ```bash
   cd clinikk-assignment
   ```
4. Fetch the dependencies:
   ```bash
   flutter pub get
   ```

---

## Running the App

1. Ensure a device/emulator is connected.
2. Run the app using the following command:
   ```bash
   flutter run
   ```

---

## Building the App

To generate an APK for Android:
```bash
flutter build apk --release
```

For iOS, ensure you have Xcode set up and run:
```bash
flutter build ios
```

---

## Screens

### Task Management Screen
- **Features**:
  - Input field and button for adding tasks.
  - ListView to display tasks with checkboxes for marking completion.
  - Delete functionality for removing tasks.

### API Data Screen
- **Features**:
  - Display posts fetched from the API.
  - Search box at the top to filter posts by user ID.

---

## Error Handling
- Prevent adding empty tasks.
- Graceful handling of API errors with user feedback.

---

## Evaluation Criteria

1. **Dart Programming Skills**:
   - Clean, efficient, and maintainable code.
   - Proper use of asynchronous programming (`Future`, `async/await`).

2. **UI/UX Design**:
   - Visually appealing and responsive layout.
   - Smooth navigation and user experience.

3. **API Integration**:
   - Efficient data fetching and lifecycle management.
   - Robust error handling for API failures.

4. **Code Quality**:
   - Maintainable and clear code.
   - Use of Flutter best practices.

---



Feel free to fork this repository and contribute! If you have any questions, please open an issue or reach out.
```