## Quiz App

This is a simple quiz app built using Flutter, a popular framework for developing cross-platform mobile applications. The app allows users to answer questions within a specific time limit and provides feedback on their performance.

### Installation

To run the app, make sure you have Flutter installed. If not, you can [install Flutter](https://flutter.dev/docs/get-started/install).

Clone the repository:

```bash
git clone <repository-url>
cd <repository-folder>
```

Install dependencies:

```bash
flutter pub get
```

### How to Use

1. **Opening Screen:**

   When you launch the app, you will see an opening screen with your name and an option to start the quiz or log in for more features.

   - **Play Now:**
     - Click on "Play Now!" to start the quiz.
     - You will be presented with a series of questions.
     - Answer the questions within the time limit to earn points.
     - Your score and the number of correct/wrong answers will be displayed at the end.

   - **Login:**
     - Click on "Login" to access additional features (Phase 2 content).

### App Structure

- **`main.dart`:**
  - The entry point of the app.
  - Initializes the app and sets up the main widget (`MyApp`).

- **`opening_screen_widgets/opening_screen_app_bar.dart`:**
  - Contains the app bar widget for the opening screen.

- **`screens/question_screen.dart`:**
  - Implements the quiz functionality.
  - Displays questions and handles user input.
  - Uses a timer to limit the time for each question.

- **`widgets/question_screen_widgets/custom_keyboard.dart`:**
  - Custom keyboard widget for entering answers.

- **`widgets/question_screen_widgets/question_screen_app_bar.dart`:**
  - App bar widget for the quiz screen.
  - Displays user information, quiz number, and score.
  - Provides an option to quit the game.

### Technologies Used

- **Flutter:** A framework for building natively compiled applications for mobile, web, and desktop from a single codebase.

- **Quiver:** A set of utility libraries for Dart that makes using many Dart libraries easier and more convenient, or adds additional functionality.

Happy quizzing!