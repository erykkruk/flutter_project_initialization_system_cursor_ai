# {{PROJECT_NAME}}

A Flutter application built with Clean Architecture principles.

## 🏗 Architecture

This project follows Clean Architecture with clear separation of concerns:

``` architecture
lib/
├── core/                 # Shared utilities and services
│   ├── clients/         # HTTP clients and network configuration
│   ├── config_tools/    # App configuration and environment
│   ├── constants/       # App-wide constants
│   ├── exceptions/      # Custom exceptions and error handling
│   ├── services/        # Core services (storage, analytics, etc.)
│   ├── theme/          # Theme system (colors, typography, dimensions)
│   └── widgets/        # Reusable UI components
└── features/           # Feature modules
    └── feature_name/
        ├── domain/     # Business logic and entities
        │   ├── entities/
        │   ├── repositories/
        │   └── usecases/
        ├── data/       # Data layer implementation
        │   ├── datasources/
        │   ├── models/
        │   └── repositories/
        └── presentation/ # UI and state management
            ├── pages/
            ├── widgets/
            └── cubit/
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK {{FLUTTER_VERSION}}
- FVM (Flutter Version Management)
- Dart SDK

### Setup

1. **Install FVM** (if not already installed):

   ```bash
   dart pub global activate fvm
   ```

2. **Use the correct Flutter version**:

   ```bash
   fvm use {{FLUTTER_VERSION}}
   ```

3. **Install dependencies**:

   ```bash
   fvm flutter pub get
   ```

4. **Generate code**:

   ```bash
   fvm flutter pub run build_runner build
   ```

5. **Generate translations** (if using internationalization):

   ```bash
   fvm flutter pub run intl_utils:generate
   ```

6. **Run the app**:

   ```bash
   fvm flutter run
   ```

## 🛠 Technology Stack

### Core Dependencies

- **State Management**: flutter_bloc (Cubit pattern)
- **Dependency Injection**: get_it + injectable
- **Navigation**: go_router
- **HTTP Client**: dio + retrofit
- **Code Generation**: build_runner + freezed
- **Storage**: shared_preferences
- **Internationalization**: flutter_intl

### Development Dependencies

- **Testing**: flutter_test + mocktail
- **Code Quality**: dart_code_metrics + very_good_analysis
- **Code Generation**: Various generators for serialization and DI

## 🎨 Theme System

The app uses a comprehensive theme system with:

### Color Palette

- **Primary Colors**: 50-900 shades for main brand colors
- **Secondary Colors**: Complementary palette
- **Accent Colors**: Highlight and emphasis colors
- **Neutral Colors**: Text and background variations
- **Semantic Colors**: Success, warning, error, info states

### Typography

- **Display**: Large headlines and hero text
- **Headline**: Section headers
- **Title**: Subsection titles
- **Label**: UI element labels
- **Body**: Content and reading text

### Spacing System

8-point grid system: 4, 8, 12, 16, 24, 32, 48, 64

## 🧪 Testing

### Running Tests

```bash
# Run all tests
fvm flutter test

# Run tests with coverage
fvm flutter test --coverage

# Run specific test file
fvm flutter test test/features/home/presentation/cubit/home_cubit_test.dart
```

### Test Structure

Tests mirror the app structure:

``` test architecture
test/
├── core/               # Core utilities tests
└── features/           # Feature tests
    └── feature_name/
        ├── domain/     # Business logic tests
        ├── data/       # Data layer tests
        └── presentation/ # UI and cubit tests
```

## 🔧 Development Workflow

### Code Generation

After adding new models or modifying existing ones:

```bash
fvm flutter pub run build_runner build
```

For clean rebuild:

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

### Adding New Features

1. **Create feature structure**:

   ```bash
   mkdir -p lib/features/new_feature/{domain,data,presentation}
   mkdir -p lib/features/new_feature/domain/{entities,repositories,usecases}
   mkdir -p lib/features/new_feature/data/{datasources,models,repositories}
   mkdir -p lib/features/new_feature/presentation/{pages,widgets,cubit}
   ```

2. **Create corresponding tests**:

   ```bash
   mkdir -p test/features/new_feature/{domain,data,presentation}
   ```

3. **Implement following Clean Architecture principles**:
   - Domain layer: Pure business logic, no external dependencies
   - Data layer: External data sources, implement domain repositories
   - Presentation layer: UI components and state management

### Code Quality

The project includes strict linting rules and code metrics:

```bash
# Analyze code
fvm flutter analyze

# Check code metrics
fvm flutter pub run dart_code_metrics:metrics analyze lib

# Fix auto-fixable issues
fvm flutter analyze --fix-apply
```

## 🌐 Internationalization

The app supports multiple languages using flutter_intl:

### Adding New Translations

1. Add keys to `lib/l10n/intl_en.arb`
2. Run: `fvm flutter pub run intl_utils:generate`
3. Use in code: `context.l10n.your_key`

### Supported Languages

- English (en) - Default

## 📱 Build & Deployment

### Debug Build

```bash
fvm flutter run
```

### Release Build

```bash
# Android APK
fvm flutter build apk --release

# Android App Bundle
fvm flutter build appbundle --release

# iOS
fvm flutter build ios --release
```

## 🔍 Project Structure Details

### Core Layer

- **clients/**: HTTP clients and API configuration
- **config_tools/**: Environment and app configuration
- **constants/**: App-wide constants and enums
- **exceptions/**: Custom exceptions and error types
- **services/**: Core services (storage, analytics, logging)
- **theme/**: Complete theming system
- **widgets/**: Reusable UI components

### Feature Layer

Each feature follows the same structure:

- **domain/**: Business logic, entities, and abstract repositories
- **data/**: Concrete implementations and external data sources
- **presentation/**: UI components and state management

### Dependency Rules

- **Domain**: No dependencies on other layers
- **Data**: Can depend on Domain only
- **Presentation**: Can depend on Domain only
- **Core**: Can be used by any layer

## 🤝 Contributing

### Code Style

- Follow Dart/Flutter conventions
- Use meaningful variable and function names
- Add documentation for public APIs
- Write tests for new features

### Commit Messages

Use conventional commits:

- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation
- `test:` for tests
- `refactor:` for refactoring

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Troubleshooting

### Common Issues

**Build runner conflicts**:

```bash
fvm flutter pub run build_runner clean
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

**FVM issues**:

```bash
fvm install {{FLUTTER_VERSION}}
fvm use {{FLUTTER_VERSION}}
```

**Dependency conflicts**:

```bash
fvm flutter clean
fvm flutter pub get
```

**Analysis errors**:

```bash
fvm flutter analyze --fix-apply
```

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Bloc State Management](https://bloclibrary.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Flutter Testing Guide](https://docs.flutter.dev/testing)

---
