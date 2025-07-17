# RepRight

## Getting Started

1. Set Up Flutter for macOS + iOS

   Ensure your machine is ready to build Flutter iOS apps:

   🔗 [Flutter macOS + iOS Setup Guide](https://docs.flutter.dev/get-started/install/macos/mobile-ios#add-flutter-to-your-path)

2. Clone the repository
   ```
   git clone <your-repo-url>
   cd fitness-ui
   ```
3. Open the project in VSCode

   ```sh
   cd fitness-ui
   code .
   ```

4. Install dependencies

   ```sh
   flutter pub get
   ```

5. macOS: Install CocoaPods Using `rbenv` Ruby

   a. Install rbenv and Ruby 3.2:

   ```
   brew install rbenv
   rbenv init
   ```

   > Restart your terminal or run:

   ```
   eval "$(rbenv init -)"

   ```

   b. Install Ruby (Recommended: 3.2.2):

   ```
   rbenv install 3.2.2
   rbenv global 3.2.2
   ```

   c. Verify Ruby version:

   ```
   ruby -v  # should say 3.2.2
   which ruby # Should point to ~/.rbenv
   ```

6. Install CocoaPods (Using rbenv Ruby)

   ```
   gem install cocoapods
   ```

7. Choose a Device in VS Code

   At the lower-left corner of VS Code:

   - Select a target device
   - Choose iOS Simulator (e.g., iPhone 15)

   > You can also run this command to list devices:

   ```
   flutter devices
   ```

8. Run the app
   ```sh
   flutter run
   ```

## Developer Notes

- Always run `flutter pub get` after pulling new changes.
- Run `flutter clean` if you encounter strange build issues.
- If adding new packages, run `flutter pub get` and commit `pubspec.lock`.
- Test on both Android and iOS (or macOS) when possible.
- Prefer using `const` constructors and widgets when possible.
- Use `flutter analyze` to check for linter warnings.
- Use `flutter format .` to auto-format code before committing.

## Useful Flutter Commands

- `flutter doctor` — Diagnose environment issues.
- `flutter pub outdated` — Check for outdated packages.
- `flutter pub run build_runner build` — (if using codegen)
- `flutter run -d macos` — Run on macOS.

## Contributing

- Create a new branch for your feature or bugfix.
- Open a pull request with a clear title and description.
- Follow naming conventions and keep PRs concise.
- Tag someone for review.
