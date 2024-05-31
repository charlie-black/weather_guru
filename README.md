
```markdown
# Flutter App

Welcome to the Weather Guru App! This README will guide you through the steps to clone the project from GitHub and run it on your local machine.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed on your machine.
- [Git](https://git-scm.com/) installed on your machine.
- An IDE such as [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/) with Flutter and Dart plugins installed.

## Getting Started

Follow these steps to get the project up and running:

### 1. Clone the Repository

Open your terminal or command prompt and run the following command to clone the repository:

```bash
git clone https://github.com/charlie-black/weather_guru.git
```

### 2. Navigate to the Project Directory

```bash
cd weather_guru
```

### 3. Create the `environments.dart` File

In the `lib` directory, create a file named `environments.dart` and add the following code:

```dart
import 'package:flutter/foundation.dart';

const String endPointUrl = kReleaseMode
    ? "https://api.openweathermap.org/data/2.5/"
    : "https://api.openweathermap.org/data/2.5/";

const String citiesEndpointUrl = "https://api.api-ninjas.com/v1/city?name=";
const String xAPIKey = "Your-Open-Weather-Api-Key";
const String citiesXApiKey = "Cities-Api_key";
```

This file is gitignored because it contains sensitive API keys. Ensure this file is not shared publicly.

### 4. Get the Dependencies

Run the following command to fetch all the necessary dependencies:

```bash
flutter pub get
```

### 5. Run the App

Connect a device or start an emulator, then use the following command to run the app:

```bash
flutter run
```

If you are using an IDE like Android Studio or Visual Studio Code, you can also run the app by clicking the 'Run' button.

## Additional Commands

Here are some additional commands you might find useful:

- **Run in Debug Mode**: `flutter run --debug`
- **Run in Release Mode**: `flutter run --release`
- **Run with Specific Device**: `flutter run -d <device_id>`

## Project Structure

Here is a brief overview of the project structure:

```plaintext
weather_guru/
├── analysis_options.yaml
├── android
│   ├── app
│   ├── build.gradle
│   ├── gradle
│   ├── gradle.properties
│   ├── gradlew
│   ├── gradlew.bat
│   ├── local.properties
│   ├── settings.gradle
│   └── weather_guru_android.iml
├── assets
│   ├── animations
│   ├── icons
│   ├── images
│   └── json
├── build
│   ├── a1232790088bd56dac5807c1ef77dc36
│   ├── app
│   ├── d0fba9d69bbb661a03572ff4dd941e4b.cache.dill.track.dill
│   ├── fluttertoast
│   ├── google_api_headers
│   ├── kotlin
│   ├── last_build_run.json
│   ├── package_info_plus
│   ├── path_provider_android
│   ├── shared_preferences_android
│   └── sqflite
├── ios
│   ├── Flutter
│   ├── Runner
│   ├── RunnerTests
│   ├── Runner.xcodeproj
│   └── Runner.xcworkspace
├── lib
│   ├── blocs
│   ├── environment.dart
│   ├── generated
│   ├── main.dart
│   ├── screens
│   └── utils
├── linux
│   ├── CMakeLists.txt
│   ├── flutter
│   ├── main.cc
│   ├── my_application.cc
│   └── my_application.h
├── macos
│   ├── Flutter
│   ├── Runner
│   ├── RunnerTests
│   ├── Runner.xcodeproj
│   └── Runner.xcworkspace
├── pubspec.lock
├── pubspec.yaml
├── README.md
├── weather_guru.iml
├── web
│   ├── favicon.png
│   ├── icons
│   ├── index.html
│   └── manifest.json
└── windows
    ├── CMakeLists.txt
    ├── flutter
    └── runner

```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

## Contact

If you have any questions or suggestions, feel free to contact me at [omwacharles@gmail.com](mailto:omwacharles@gmail.com).

Happy coding!
```

