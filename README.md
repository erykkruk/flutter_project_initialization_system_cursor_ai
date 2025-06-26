# Flutter Project Initialization System

A comprehensive system for creating new Flutter projects or transforming existing ones to follow Clean Architecture principles, based on the battle-tested `couples_analytics` project structure.

## 🚀 Quick Start

### Prerequisites

Before using this system, you need:

- Flutter SDK 3.29.2 (managed with FVM)
- FVM (Flutter Version Management) installed
- Dart SDK

```bash
# Install FVM if not already installed
dart pub global activate fvm

# Use the correct Flutter version
fvm use 3.29.2
```

### For New Projects

```bash
cd /path/to/your/projects
/path/to/init_project/scripts/00_main.sh
```

### For Existing Projects

```bash
cd my_existing_project
/path/to/init_project/scripts/00_main.sh
```

## 📁 System Overview

This initialization system consists of three main components:

### 1. Modular Script System (`scripts/`)

Automates the creation and setup of Flutter projects with Clean Architecture in 6 sequential steps.

### 2. Modular Rules System (`rules/`)

Provides Cursor IDE integration with context-aware rules that automatically apply based on what you're working on.

### 3. Template System (`templates/`)

Provides customizable templates for generated files.

## 🛠 Script System Details

The main script (`00_main.sh`) orchestrates 6 sequential steps:

### Step 1: `01_create_structure.sh`

- Creates Clean Architecture directory structure
- Sets up feature-based organization
- Creates core directories for shared utilities

### Step 2: `02_setup_dependencies.sh`

- Adds dependencies using `fvm flutter pub add` commands
- Configures flutter_intl settings
- Adds assets configuration

### Step 3: `03_create_theme.sh`

- Creates core theme files only:
  - `colors.dart` - Light theme colors and semantic colors
  - `typography.dart` - Complete Material 3 text styles
  - `dimensions.dart` - 8-point grid spacing and component sizes

### Step 4: `04_setup_di_routing.sh`

- Sets up dependency injection with get_it/injectable
- Creates GoRouter configuration
- Configures navigation structure

### Step 5: `05_create_core_files.sh`

- Creates `main.dart` with basic Material 3 theme
- Sets up exception classes and Result pattern
- Creates sample home feature
- Generates localization files
- Creates test helpers and utilities
- Generates README.md from template

### Step 6: `06_setup_config.sh`

- Creates VS Code settings for FVM integration
- Sets up `analysis_options.yaml` with dart_code_metrics
- Configures `l10n.yaml` for internationalization
- Sets line length to 120 characters

## 📖 Dependencies Added

### Core Dependencies (18 packages)

```bash
flutter_bloc rxdart go_router get_it injectable freezed_annotation 
json_annotation intl flutter_localizations shared_preferences 
flutter_secure_storage dio retrofit connectivity_plus sqflite 
share_plus flutter_svg cupertino_icons
```

### Development Dependencies (12 packages)

```bash
build_runner freezed json_serializable injectable_generator 
retrofit_generator mocktail bloc_test flutter_lints dart_code_metrics 
dart_code_metrics_presets very_good_analysis intl_utils
```

## 📋 What You Get

### Architecture & Structure

- ✅ Clean Architecture with clear layer separation
- ✅ Feature-based organization (domain/data/presentation)
- ✅ Dependency injection with get_it/injectable
- ✅ Result pattern for robust error handling

### State Management

- ✅ flutter_bloc with Cubit pattern
- ✅ Immutable state with freezed
- ✅ Type-safe event/state management

### Navigation & Routing

- ✅ GoRouter for type-safe navigation
- ✅ Named routes with parameters
- ✅ Route protection and guards

### Core Theme Files

- ✅ Semantic color system (light theme + semantic colors)
- ✅ Typography scales (display, headline, title, label, body)
- ✅ 8-point grid dimensions system
- ✅ Ready for custom AppTheme implementation

### Code Quality

- ✅ Strict linting rules based on couples_analytics
- ✅ dart_code_metrics integration with presets
- ✅ Import restrictions between layers
- ✅ Member ordering and code organization
- ✅ 120-character line length

### Testing Infrastructure

- ✅ Unit test structure mirroring app architecture
- ✅ Mock utilities for SharedPreferences and FlutterSecureStorage
- ✅ Test helpers and setup utilities
- ✅ Coverage configuration

### Developer Experience

- ✅ VS Code configuration with FVM integration
- ✅ Code generation setup (build_runner)
- ✅ Internationalization (flutter_intl)
- ✅ Basic Material 3 theme ready for customization

## 🎯 Rules System (`rules/`)

The modular rules provide intelligent Cursor IDE integration:

### Always Applied Rules

- **`01_core_architecture.mdc`** - Fundamental Clean Architecture principles

### Auto-Attached Rules (Context-Sensitive)

- **`02_flutter_development.mdc`** - General Flutter best practices (*.dart, pubspec.yaml)
- **`03_state_management.mdc`** - Bloc/Cubit guidelines (*bloc*.dart, *cubit*.dart, *state*.dart)
- **`04_theme_system.mdc`** - Theme and styling rules (*theme*.dart, *color*.dart, *typography*.dart)
- **`05_testing.mdc`** - Testing guidelines (*test*.dart, test/**)

### Manual/Agent Requested Rules

- **`06_code_generation.mdc`** - Code generation patterns
- **`07_performance.mdc`** - Performance optimization
- **`08_project_setup.mdc`** - Project initialization guidance

## 🏗 Architecture Principles

### Layer Separation

```text
lib/
├── core/                 # Shared utilities and services
│   ├── clients/         # HTTP clients, API clients
│   ├── config_tools/    # DI, routing configuration
│   ├── constants/       # App-wide constants
│   ├── exceptions/      # Custom exceptions, Result pattern
│   ├── services/        # Core business services
│   └── theme/           # Theme constants (colors, typography, dimensions)
├── features/            # Feature modules
│   └── feature_name/
│       ├── domain/      # Business logic & entities
│       ├── data/        # Data sources & repositories
│       └── presentation/ # UI & state management
└── generated/           # Auto-generated files
```

### Dependency Flow

```text
Presentation → Domain ← Data
     ↓           ↓       ↓
   Widgets   Use Cases  Repositories
     ↓           ↓       ↓
   Cubits    Entities   Data Sources
```

### Import Restrictions (Enforced by Linting)

- Domain layer: No imports from data/presentation
- Data layer: Can import from domain only
- Presentation layer: Can import from domain only
- Core: Can be imported by any layer

## 🧪 Testing Strategy

### Test Structure

```text
test/
├── helpers/            # Test utilities and mocks
├── core/              # Core utilities tests
└── features/          # Feature tests (mirrors lib structure)
    └── feature_name/
        ├── domain/    # Unit tests
        ├── data/      # Repository & data source tests
        └── presentation/ # Widget & cubit tests
```

### Test Utilities Provided

- Mock implementations for SharedPreferences and FlutterSecureStorage
- Test dependency setup and teardown helpers
- Coverage configuration

## 📱 Post-Setup Workflow

After running the initialization scripts:

### 1. Initial Setup

```bash
cd your_project
fvm flutter pub get
fvm flutter pub run build_runner build
fvm flutter pub run intl_utils:generate
```

### 2. Development Workflow

```bash
# After adding new models/services
fvm flutter pub run build_runner build

# After changing translations
fvm flutter pub run intl_utils:generate

# Before committing
fvm flutter analyze
fvm flutter test
```

### 3. Creating Your AppTheme

The scripts create core theme files but not the AppTheme implementation. Create your own:

```dart
// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'styles/colors.dart';
import 'styles/typography.dart';
import 'styles/dimensions.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        // ... use your color constants
      ),
      textTheme: const TextTheme(
        displayLarge: AppTypography.displayLarge,
        // ... use your typography constants
      ),
      // ... use your dimension constants
    );
  }
}
```

## 🔧 Customization

### Modifying Core Theme Files

Edit the theme creation script:

```bash
# Edit colors, typography, or dimensions
vim scripts/03_create_theme.sh
```

### Adding Dependencies

Edit the dependencies script:

```bash
# Add more packages
vim scripts/02_setup_dependencies.sh
```

### Customizing Analysis Rules

Edit the configuration script:

```bash
# Modify linting rules
vim scripts/06_setup_config.sh
```

## 🤝 Integration with Existing Projects

### Safety Features

- ✅ Automatic backup of existing files (*.backup)
- ✅ Project type detection (checks for pubspec.yaml)
- ✅ Safe file overwriting with warnings
- ✅ Preserves existing project structure

### What Gets Backed Up

- VS Code settings
- analysis_options.yaml
- Any existing files that would be overwritten

## 🆘 Troubleshooting

### Common Issues

#### FVM not found

```bash
# Install FVM
dart pub global activate fvm
```

#### Build runner conflicts

```bash
fvm flutter packages pub run build_runner clean
fvm flutter packages pub run build_runner build --delete-conflicting-outputs
```

#### Analysis issues

```bash
fvm flutter analyze --fix-apply
```

### Script-Specific Issues

#### Permission denied

```bash
chmod +x scripts/*.sh
```

#### Missing utils

All scripts depend on `utils/colors.sh` and `utils/helpers.sh` - ensure they exist.

## 📝 Individual Script Usage

You can run individual scripts for specific setup tasks:

```bash
# Only create directory structure
./scripts/01_create_structure.sh false

# Only setup dependencies
./scripts/02_setup_dependencies.sh my_project false

# Only create theme files
./scripts/03_create_theme.sh

# Only setup DI and routing
./scripts/04_setup_di_routing.sh

# Only create core files
./scripts/05_create_core_files.sh

# Only setup configuration
./scripts/06_setup_config.sh false
```

## 🔄 Updates and Maintenance

### Based on couples_analytics

This system is based on the latest patterns from the `couples_analytics` project. The structure and dependencies reflect a production-ready Flutter application.

### Version Management

- Flutter 3.29.2 (via FVM)
- All dependencies use the latest stable versions
- dart_code_metrics with presets for consistent code quality

## 📄 Templates

### README Template

The system includes a comprehensive README template (`templates/README_template.md`) that gets customized with your project name and generates documentation for:

- Architecture overview
- Setup instructions
- Development workflow
- Technology stack
- Testing guidelines

## 🎯 Perfect For

- ✅ New Flutter projects requiring enterprise-grade architecture
- ✅ Existing projects migrating to Clean Architecture
- ✅ Teams needing consistent project structure
- ✅ Developers learning Clean Architecture patterns
- ✅ Projects requiring strict code quality standards

---

**Ready to build amazing Flutter apps with Clean Architecture?**

```bash
./scripts/00_main.sh your_next_amazing_app
```
