# House to Motive

A Flutter application for connecting users and sharing experiences.

## Prerequisites

Before you begin, ensure you have the following installed:
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (>=3.7.0)
- [Dart SDK](https://dart.dev/get-dart) (>=3.7.0)
- Xcode (for iOS development)
- Android Studio (for Android development)
- VS Code with Flutter and Dart extensions (recommended)

## Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd house-to-motive
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Environment Variables

The app uses environment variables for API keys and other sensitive configuration. Create a `.env` file in the project root:

```bash
# Create .env file
touch .env
```

Add your environment variables to the `.env` file:

```env
GOOGLE_MAPS_API_KEY=your_google_maps_api_key_here
```

**Important:** The `.env` file is already added to `.gitignore` to keep your API keys secure. Never commit this file to version control.

### 4. iOS Setup (macOS only)

For iOS development, you'll need to:

1. Install CocoaPods dependencies:
   ```bash
   cd ios
   pod install
   cd ..
   ```

2. Open the project in Xcode to configure signing:
   ```bash
   open ios/Runner.xcworkspace
   ```

## Running the App

### Using VS Code

1. Open the project in VS Code
2. Ensure you have the Flutter and Dart extensions installed
3. Select a launch configuration from the debug panel:
   - **Flutter (iOS Debug)** - Run on iOS simulator/device in debug mode
   - **Flutter (Android Debug)** - Run on Android emulator/device in debug mode
   - **Flutter (Chrome)** - Run in Chrome browser
4. Press `F5` or click the Run button

The launch configurations automatically load environment variables from the `.env` file using `--dart-define-from-file`.

### Using Command Line

#### Run on iOS

```bash
# Debug mode
flutter run --dart-define-from-file=.env -d ios

# Release mode
flutter run --dart-define-from-file=.env --release -d ios
```

#### Run on Android

```bash
# Debug mode
flutter run --dart-define-from-file=.env -d android

# Release mode
flutter run --dart-define-from-file=.env --release -d android
```

#### Run on Chrome

```bash
flutter run --dart-define-from-file=.env -d chrome
```

### Using the Wrapper Script

You can also use the provided wrapper script that automatically loads environment variables:

```bash
# Run on iOS
./script/flutter_run_with_env.sh run -d ios

# Run on Android
./script/flutter_run_with_env.sh run -d android
```

## Building the App

### Building for iOS

Use the provided build script:

```bash
# Build for release
./script/build_ios.sh release

# Build for debug
./script/build_ios.sh debug
```

The script automatically reads environment variables from `.env` and passes them as `--dart-define` flags during compilation.

**Manual build command:**
```bash
# Extract dart-define arguments from .env
source script/get_dart_defines.sh

# Build with environment variables
flutter build ios --release $DART_DEFINES
```

### Building for Android

#### Using the Build Script

Use the provided build script:

```bash
# Build release APK
./script/build_android.sh release apk

# Build debug APK
./script/build_android.sh debug apk

# Build release App Bundle for Play Store
./script/build_android.sh release appbundle
```

The script automatically reads environment variables from `.env` and passes them as `--dart-define` flags during compilation.

#### Using VS Code Tasks

1. Open the Command Palette (`Cmd+Shift+P` / `Ctrl+Shift+P`)
2. Run "Tasks: Run Task"
3. Select:
   - **Build Android (Release)** - Build release APK
   - **Build Android (Debug)** - Build debug APK
   - **Build Android App Bundle (Release)** - Build release App Bundle for Play Store

#### Using Command Line (Manual)

```bash
# Extract dart-define arguments from .env
source script/get_dart_defines.sh

# Build release APK
flutter build apk --release $DART_DEFINES

# Build debug APK
flutter build apk --debug $DART_DEFINES

# Build App Bundle for Play Store
flutter build appbundle --release $DART_DEFINES
```

## Environment Variables

The following environment variables are required:

| Variable | Description | Required |
|----------|-------------|----------|
| `GOOGLE_MAPS_API_KEY` | Google Maps API key for location services | Yes |

### Adding New Environment Variables

1. Add the variable to your `.env` file:
   ```env
   NEW_VARIABLE=value
   ```

2. Use it in your Dart code:
   ```dart
   const String myVar = String.fromEnvironment('NEW_VARIABLE');
   ```

3. The build scripts and VS Code configurations will automatically include it in builds.

## Project Structure

```
house-to-motive/
├── lib/                    # Dart source code
│   ├── controller/        # State management controllers
│   ├── views/             # UI screens and widgets
│   ├── utils/             # Utility functions
│   └── main.dart          # App entry point
├── ios/                   # iOS native code
├── android/               # Android native code
├── assets/                # Images, fonts, and other assets
├── script/                # Build and utility scripts
│   ├── build_ios.sh       # iOS build script
│   ├── build_android.sh    # Android build script
│   ├── get_dart_defines.sh # Helper to extract env vars
│   └── flutter_run_with_env.sh # Flutter run wrapper
├── .vscode/               # VS Code configuration
│   ├── launch.json        # Launch configurations
│   └── tasks.json         # Build tasks
└── .env                   # Environment variables (not in git)
```

## Troubleshooting

### Environment Variables Not Loading

If environment variables aren't being loaded:

1. **Check `.env` file exists**: Ensure `.env` is in the project root
2. **Check file format**: Ensure variables are in `KEY=value` format (no spaces around `=`)
3. **For VS Code**: The `--dart-define-from-file` flag requires Flutter 3.7+. Update Flutter if needed:
   ```bash
   flutter upgrade
   ```
4. **For command line**: Ensure you're using the wrapper script or manually sourcing the helper:
   ```bash
   source script/get_dart_defines.sh
   ```

### iOS Build Issues

- **CocoaPods**: Run `cd ios && pod install && cd ..`
- **Signing**: Configure signing in Xcode (`ios/Runner.xcworkspace`)
- **Clean build**: `flutter clean && flutter pub get`

### Android Build Issues

- **Gradle sync**: Open Android Studio and sync Gradle files
- **SDK**: Ensure Android SDK is properly configured
- **Clean build**: `flutter clean && flutter pub get`

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [VS Code Flutter Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)

## License

[Add your license information here]
