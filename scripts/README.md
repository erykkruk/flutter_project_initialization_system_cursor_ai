# Flutter Project Initialization Scripts

This directory contains a modular script system for initializing new Flutter projects or transforming existing ones to follow Clean Architecture principles based on the `couples_analytics` project structure.

## Overview

The script system is broken down into focused, reusable modules that can be run individually or together through the main orchestrator script.

## Script Structure

### Main Orchestrator

- **`00_main.sh`** - Main script that runs all other scripts in the correct order

### Utility Scripts

- **`utils/colors.sh`** - Color definitions for terminal output
- **`utils/helpers.sh`** - Common functions used across all scripts

### Individual Setup Scripts

1. **`01_create_structure.sh`** - Clean Architecture directory structure
2. **`02_setup_dependencies.sh`** - pubspec.yaml configuration with all dependencies
3. **`03_create_theme.sh`** - Complete theme system (colors, typography, dimensions)
4. **`04_setup_di_routing.sh`** - Dependency injection and GoRouter setup
5. **`05_create_core_files.sh`** - Core files, exceptions, Result pattern, sample feature, README.md
6. **`06_setup_config.sh`** - Configuration files (VS Code, analysis_options, l10n)

### Removed Scripts (No Longer Used)

- ~~`01_setup_environment.sh`~~ - Manual FVM setup required instead
- ~~`02_create_project.sh`~~ - Manual Flutter project creation required instead
- ~~`02_setup_existing.sh`~~ - Logic moved to main script

### Template Files

- **`../templates/README_template.md`** - Template for project README with placeholders

## Usage

### Quick Start (Recommended)

**For new projects:**

```bash
# 1. Create Flutter project first
fvm flutter create my_new_project
cd my_new_project

# 2. Run the setup scripts
/path/to/scripts/00_main.sh my_new_project
```

**For existing projects:**

```bash
# Run from project root directory
cd my_existing_project
/path/to/scripts/00_main.sh
```

### Individual Script Usage

```bash
# Run specific setup steps (from project directory)
/path/to/scripts/01_create_structure.sh
/path/to/scripts/03_create_theme.sh
/path/to/scripts/05_create_core_files.sh
```

### Complete Workflow for New Projects

```bash
# 1. Prerequisites (one-time setup)
dart pub global activate fvm
fvm install 3.29.2
fvm global 3.29.2

# 2. Create new Flutter project
fvm flutter create my_awesome_app
cd my_awesome_app

# 3. Transform to Clean Architecture
/path/to/init_project/scripts/00_main.sh my_awesome_app

# 4. Install dependencies and generate code
fvm flutter pub get
fvm flutter pub run build_runner build
fvm flutter pub run intl_utils:generate

# 5. Run the app
fvm flutter run
```

### Prerequisites

- **Flutter SDK 3.29.2** (installed and configured)
- **FVM (Flutter Version Management)** - Install with: `dart pub global activate fvm`
- **Git** - For version control
- **Dart SDK** - Usually comes with Flutter
- **Internet connection** - For downloading dependencies

### Required Setup Before Running Scripts

1. **Install FVM**:

   ```bash
   dart pub global activate fvm
   ```

2. **Install Flutter 3.29.2 with FVM**:

   ```bash
   fvm install 3.29.2
   fvm global 3.29.2
   ```

3. **Verify installation**:

   ```bash
   fvm flutter doctor
   ```

## What Gets Created

### New Projects

- Complete Flutter project with Clean Architecture
- FVM configuration (Flutter 3.29.2)
- All dependencies pre-configured
- Theme system with semantic naming
- Dependency injection setup
- Router configuration
- Internationalization support
- Testing infrastructure
- VS Code configuration
- Linting rules matching couples_analytics

### Existing Projects

- Backup of important files (*.backup)
- Clean Architecture structure overlay
- Dependencies added to pubspec.yaml
- Theme system files
- Core infrastructure files
- Configuration updates
- Migration guidance provided

## Features Included

### Architecture

- Clean Architecture with domain/data/presentation layers
- Feature-based organization
- Dependency injection with get_it/injectable
- Result pattern for error handling

### State Management

- flutter_bloc with Cubit pattern
- Immutable state with freezed
- Event/State separation

### Navigation

- GoRouter for type-safe navigation
- Named routes
- Route protection

### Theming

- Semantic color system
- Typography scales
- 8-point grid dimensions
- Dark/light theme support

### Code Quality

- Strict linting rules
- dart_code_metrics integration
- Import restrictions between layers
- Member ordering rules

### Testing

- Unit test structure
- Widget test setup
- Mock utilities
- Test coverage configuration

### Internationalization

- flutter_intl setup
- ARB file configuration
- Localization utilities

## Configuration Files

### Analysis Options

Uses the same `analysis_options.yaml` as `couples_analytics` with:

- dart_code_metrics integration
- Strict analyzer settings
- BLOC-specific rules
- Clean Architecture enforcement
- Member ordering rules
- Magic number restrictions
- Import restrictions between layers

### VS Code Settings

- Dart/Flutter extensions configuration
- Code formatting rules
- File associations
- Recommended extensions

## Post-Setup Steps

After running the scripts:

1. **Code Generation**

   ```bash
   flutter pub run build_runner build
   ```

2. **Test Setup**

   ```bash
   flutter test
   ```

3. **Run App**

   ```bash
   flutter run
   ```

4. **Internationalization**

   ```bash
   flutter pub run intl_utils:generate
   ```

## Customization

Each script can be modified independently:

- Edit theme colors in `05_create_theme.sh`
- Modify dependencies in `04_setup_dependencies.sh`
- Adjust linting rules in `08_setup_config.sh`
- Update Flutter version in `01_setup_environment.sh`

## Safety Features

- Automatic backup of existing files
- Project type detection
- Safe file overwriting with confirmation
- Detailed logging of all operations
- Error handling and rollback capabilities

## Integration with Cursor Rules

The generated project structure works seamlessly with the modular rules system in `../rules/`:

- Auto-attached rules based on file patterns
- Manual rules for specific scenarios
- Always-applied architecture principles

## Support

For issues or customizations, refer to:

- Individual script comments
- `couples_analytics` project as reference
- Clean Architecture documentation
- Flutter best practices guides
