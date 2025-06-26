#!/bin/bash

# Core Files and Sample Feature Creation Script
# Creates main.dart, core exception classes, and sample home feature

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/helpers.sh"

print_info "Creating core files and sample feature..."

# Create main.dart
print_file "Creating lib/main.dart"
cat > lib/main.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/config_tools/injection.dart';
import 'core/config_tools/app_router.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set portrait orientation only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configure dependencies
  await configureDependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = inject<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Clean Architecture',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: _appRouter.router,
      localizationsDelegates: const [
        Translations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: Translations.delegate.supportedLocales,
    );
  }
}
EOF

# Create initialization.dart
print_file "Creating lib/initialization.dart"
cat > lib/initialization.dart << 'EOF'
import 'dart:async';
import 'package:flutter/foundation.dart';

/// Initialize app data asynchronously
/// This can include:
/// - Database initialization
/// - Remote config
/// - Analytics
/// - Crash reporting
/// - Feature flags
Future<void> initializeDataAsynchronously() async {
  // Run initialization tasks that don't block app startup
  unawaited(_initializeServices());
}

Future<void> _initializeServices() async {
  try {
    // Add your async initialization here
    // Example:
    // await FirebaseAuth.instance.authStateChanges().first;
    // await RemoteConfig.instance.fetchAndActivate();
    
    if (kDebugMode) {
      print('✅ Async initialization completed');
    }
  } catch (e) {
    if (kDebugMode) {
      print('❌ Async initialization failed: $e');
    }
  }
}
EOF

# Create basic exceptions
print_file "Creating lib/core/exceptions/app_exception.dart"
cat > lib/core/exceptions/app_exception.dart << 'EOF'
/// Base class for all application exceptions
abstract class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => 'AppException: $message';
}

/// Exception thrown when a network operation fails
class NetworkException extends AppException {
  const NetworkException(super.message);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when data validation fails
class ValidationException extends AppException {
  const ValidationException(super.message);

  @override
  String toString() => 'ValidationException: $message';
}

/// Exception thrown when authentication fails
class AuthException extends AppException {
  const AuthException(super.message);

  @override
  String toString() => 'AuthException: $message';
}

/// Exception thrown when a resource is not found
class NotFoundException extends AppException {
  const NotFoundException(super.message);

  @override
  String toString() => 'NotFoundException: $message';
}

/// Exception thrown when an operation times out
class TimeoutException extends AppException {
  const TimeoutException(super.message);

  @override
  String toString() => 'TimeoutException: $message';
}
EOF

# Create Result pattern
print_file "Creating lib/core/exceptions/result.dart"
cat > lib/core/exceptions/result.dart << 'EOF'
/// A generic Result class that encapsulates success and failure states
abstract class Result<T> {
  const Result();

  /// Returns true if the result is a success
  bool get isSuccess => this is Success<T>;

  /// Returns true if the result is a failure
  bool get isFailure => this is Failure<T>;

  /// Executes the appropriate callback based on the result state
  R when<R>({
    required R Function(T data) success,
    required R Function(String message) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else {
      return failure((this as Failure<T>).message);
    }
  }

  /// Maps the success value to a new type
  Result<R> map<R>(R Function(T) mapper) {
    if (this is Success<T>) {
      try {
        return Success(mapper((this as Success<T>).data));
      } catch (e) {
        return Failure(e.toString());
      }
    } else {
      return Failure((this as Failure<T>).message);
    }
  }
}

/// Represents a successful result
class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success(data: $data)';
}

/// Represents a failed result
class Failure<T> extends Result<T> {
  const Failure(this.message);

  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => 'Failure(message: $message)';
}
EOF

# Create sample home feature
print_info "Creating sample home feature..."
ensure_directory "lib/features/home/domain/entities"
ensure_directory "lib/features/home/domain/repositories"
ensure_directory "lib/features/home/domain/services"
ensure_directory "lib/features/home/data/models"
ensure_directory "lib/features/home/data/datasources"
ensure_directory "lib/features/home/data/repositories"
ensure_directory "lib/features/home/presentation/screens"
ensure_directory "lib/features/home/presentation/widgets"
ensure_directory "lib/features/home/presentation/cubits"

# Home screen
print_file "Creating lib/features/home/presentation/screens/home_screen.dart"
cat > lib/features/home/presentation/screens/home_screen.dart << 'EOF'
import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = Translations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(translations.appTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flutter_dash,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24.0),
            Text(
              translations.welcomeMessage,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Clean Architecture with FVM Flutter',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48.0),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(translations.buttonPressed),
                  ),
                );
              },
              child: Text(translations.getStarted),
            ),
          ],
        ),
      ),
    );
  }
}
EOF

# Create basic localization file
print_file "Creating assets/localizations/intl_en.arb"
cat > assets/localizations/intl_en.arb << 'EOF'
{
  "appTitle": "My App",
  "@appTitle": {
    "description": "The title of the application"
  },
  "welcomeMessage": "Welcome to Flutter Clean Architecture!",
  "@welcomeMessage": {
    "description": "Welcome message shown to users on the home screen"
  },
  "getStarted": "Get Started",
  "@getStarted": {
    "description": "Button text to start using the app"
  },
  "buttonPressed": "Button was pressed!",
  "@buttonPressed": {
    "description": "Message shown when button is pressed"
  }
}
EOF

# Test helpers removed - create custom test doubles when needed in specific tests

# Create project README.md
print_info "Creating project README.md from template..."

# Get current Flutter version for README
CURRENT_FLUTTER_VERSION="${FLUTTER_VERSION:-$(get_current_flutter_version)}"

# Get the template path
TEMPLATE_PATH="$(dirname "$(dirname "$0")")/templates/README_template.md"

if [[ -f "$TEMPLATE_PATH" ]]; then
    # Copy template and replace placeholders
    sed "s/{{PROJECT_NAME}}/$PROJECT_NAME/g; s/{{FLUTTER_VERSION}}/$CURRENT_FLUTTER_VERSION/g" "$TEMPLATE_PATH" > "$PROJECT_DIR/README.md"
    print_success "README.md created from template"
else
    # Fallback to basic README if template not found
    print_warning "Template not found, creating basic README.md..."
    cat > "$PROJECT_DIR/README.md" << EOF
# $PROJECT_NAME

A Flutter application built with Clean Architecture principles.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK $CURRENT_FLUTTER_VERSION
- FVM (Flutter Version Management) - optional
- Dart SDK

### Setup
1. **Using FVM (recommended)**:
   \`\`\`bash
   # Install FVM if not already installed
   dart pub global activate fvm
   
   # Use the project's Flutter version (if needed)
   # fvm use $CURRENT_FLUTTER_VERSION
   \`\`\`

2. **Using system Flutter**:
   \`\`\`bash
   # Make sure you have compatible Flutter version installed
   flutter --version
   \`\`\`

3. **Install dependencies**:
   \`\`\`bash
   fvm flutter pub get
   \`\`\`

4. **Generate code**:
   \`\`\`bash
   fvm flutter pub run build_runner build
   \`\`\`

5. **Generate translations**:
   \`\`\`bash
   fvm flutter pub run intl_utils:generate
   \`\`\`

6. **Run the app**:
   \`\`\`bash
   fvm flutter run
   \`\`\`

## 🏗 Architecture

This project follows Clean Architecture with clear separation of concerns:

- **Domain Layer**: Business logic and entities
- **Data Layer**: Data sources and repositories  
- **Presentation Layer**: UI and state management

## 🛠 Technology Stack

- **State Management**: flutter_bloc (Cubit pattern)
- **Dependency Injection**: get_it + injectable
- **Navigation**: go_router
- **HTTP Client**: dio + retrofit
- **Code Generation**: build_runner + freezed
- **Storage**: shared_preferences
- **Internationalization**: flutter_intl

## 🧪 Testing

\`\`\`bash
# Run all tests
fvm flutter test

# Run tests with coverage
fvm flutter test --coverage
\`\`\`

## 🔧 Development

### Code Generation
After adding new models or modifying existing ones:
\`\`\`bash
fvm flutter pub run build_runner build
\`\`\`

### Adding New Features
1. Create feature structure following Clean Architecture
2. Implement domain layer (entities, repositories, use cases)
3. Implement data layer (models, data sources, repository implementations)
4. Implement presentation layer (pages, widgets, cubits)
5. Add corresponding tests

For detailed information, refer to the generated documentation and code comments.

---

**Happy coding! 🚀**

EOF
fi

print_success "Core files and sample feature created successfully" 