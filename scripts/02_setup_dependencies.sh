#!/bin/bash

# Dependencies Setup Script
# Adds dependencies using fvm flutter pub add and configures minimal pubspec.yaml additions

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/helpers.sh"

PROJECT_NAME="$1"
IS_EXISTING_PROJECT="$2"

print_info "Setting up dependencies for $PROJECT_NAME..."

# Determine which Flutter command to use
if command_exists fvm && [ -f ".fvmrc" ]; then
    FLUTTER_CMD="fvm flutter"
    print_info "Using FVM Flutter command"
else
    FLUTTER_CMD="flutter"
    print_info "Using system Flutter command"
fi

# Add core dependencies
print_info "Adding core dependencies..."

# State Management
$FLUTTER_CMD pub add flutter_bloc
$FLUTTER_CMD pub add rxdart

# Navigation
$FLUTTER_CMD pub add go_router

# Dependency Injection
$FLUTTER_CMD pub add get_it
$FLUTTER_CMD pub add injectable

# Code Generation
$FLUTTER_CMD pub add freezed_annotation
$FLUTTER_CMD pub add json_annotation

# Localization
$FLUTTER_CMD pub add intl
$FLUTTER_CMD pub add flutter_localizations --sdk=flutter

# Storage
$FLUTTER_CMD pub add shared_preferences
$FLUTTER_CMD pub add flutter_secure_storage

# Network
$FLUTTER_CMD pub add dio
$FLUTTER_CMD pub add retrofit
$FLUTTER_CMD pub add connectivity_plus

# Database
$FLUTTER_CMD pub add sqflite

# Utilities
$FLUTTER_CMD pub add share_plus
$FLUTTER_CMD pub add flutter_svg

# UI
$FLUTTER_CMD pub add cupertino_icons

print_success "Core dependencies added"

# Add development dependencies
print_info "Adding development dependencies..."

# Code Generation
$FLUTTER_CMD pub add build_runner --dev
$FLUTTER_CMD pub add freezed --dev
$FLUTTER_CMD pub add json_serializable --dev
$FLUTTER_CMD pub add injectable_generator --dev
$FLUTTER_CMD pub add retrofit_generator --dev

# Testing
$FLUTTER_CMD pub add mocktail --dev
$FLUTTER_CMD pub add bloc_test --dev

# Linting & Code Quality
$FLUTTER_CMD pub add flutter_lints --dev
# Note: dart_code_metrics removed due to analyzer version conflicts with freezed and flutter_svg
# $FLUTTER_CMD pub add dart_code_metrics --dev
# $FLUTTER_CMD pub add dart_code_metrics_presets --dev
$FLUTTER_CMD pub add very_good_analysis --dev

# Utils
$FLUTTER_CMD pub add intl_utils --dev

print_success "Development dependencies added"

# Add flutter_intl configuration and assets to pubspec.yaml
print_info "Adding flutter_intl configuration and assets..."

# Check if flutter_intl section already exists
if ! grep -q "flutter_intl:" pubspec.yaml; then
    echo "" >> pubspec.yaml
    echo "flutter_intl:" >> pubspec.yaml
    echo "  enabled: true" >> pubspec.yaml
    echo "  arb_dir: assets/localizations" >> pubspec.yaml
    echo "  output_dir: lib/generated" >> pubspec.yaml
    echo "  class_name: Translations" >> pubspec.yaml
    print_success "flutter_intl configuration added"
else
    print_warning "flutter_intl configuration already exists"
fi

# Check if we need to add/update the flutter section for assets
if grep -q "flutter:" pubspec.yaml; then
    # flutter section exists, check if assets are already there
    if ! grep -q "assets:" pubspec.yaml; then
        # Add assets section to existing flutter section
        # Find the flutter: line and add assets after it
        sed -i.backup '/flutter:/a\
  assets:\
    - assets/images/\
    - assets/icons/\
    - assets/fonts/\
    - assets/localizations/\
    - assets/splash/\
\
  # fonts:\
  #   - family: YourCustomFont\
  #     fonts:\
  #       - asset: assets/fonts/YourCustomFont-Regular.ttf\
  #         weight: 400
' pubspec.yaml
        print_success "Assets configuration added to existing flutter section"
    else
        print_warning "Assets configuration already exists"
    fi
else
    # No flutter section exists, add it with assets
    echo "" >> pubspec.yaml
    echo "flutter:" >> pubspec.yaml
    echo "  assets:" >> pubspec.yaml
    echo "    - assets/images/" >> pubspec.yaml
    echo "    - assets/icons/" >> pubspec.yaml
    echo "    - assets/fonts/" >> pubspec.yaml
    echo "    - assets/localizations/" >> pubspec.yaml
    echo "    - assets/splash/" >> pubspec.yaml
    echo "" >> pubspec.yaml
    echo "  # fonts:" >> pubspec.yaml
    echo "  #   - family: YourCustomFont" >> pubspec.yaml
    echo "  #     fonts:" >> pubspec.yaml
    echo "  #       - asset: assets/fonts/YourCustomFont-Regular.ttf" >> pubspec.yaml
    echo "  #         weight: 400" >> pubspec.yaml
    print_success "Flutter section with assets added"
fi

# Get dependencies to ensure everything is properly installed
print_info "Getting dependencies..."
$FLUTTER_CMD pub get
print_success "Dependencies setup completed"

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "${YELLOW}[Step 2/6] Setting up dependencies and generating code...${NC}"

cd "$PROJECT_ROOT"

# Update dependencies first
print_info "Updating Flutter dependencies..."
if fvm flutter pub get; then
    print_success "Dependencies updated successfully"
else
    print_error "Failed to update dependencies"
    exit 1
fi

# Generate localization files
print_info "Generating localization files..."
if fvm flutter gen-l10n; then
    print_success "Localization files generated successfully"
else
    print_error "Failed to generate localization files"
    exit 1
fi

# Generate dependency injection code
print_info "Generating dependency injection code..."
if fvm dart run build_runner build --delete-conflicting-outputs; then
    print_success "Dependency injection code generated successfully"
else
    print_error "Failed to generate dependency injection code"
    exit 1
fi

# Verify generated files exist
print_info "Verifying generated files..."

GENERATED_FILES=(
    "lib/generated/l10n.dart"
    "lib/core/config_tools/injection.config.dart"
)

MISSING_FILES=()
for file in "${GENERATED_FILES[@]}"; do
    if [[ ! -f "$file" ]]; then
        MISSING_FILES+=("$file")
    fi
done

if [[ ${#MISSING_FILES[@]} -eq 0 ]]; then
    print_success "All generated files are present"
else
    print_warning "Some generated files are missing:"
    for file in "${MISSING_FILES[@]}"; do
        echo "  - $file"
    done
    print_info "This is normal if this is the first run. Files will be generated in later steps."
fi

# Run flutter analyze to check for any issues
print_info "Running Flutter analyze to check for issues..."
ANALYZE_OUTPUT=$(fvm flutter analyze 2>&1)
ANALYZE_EXIT_CODE=$?

if [[ $ANALYZE_EXIT_CODE -eq 0 ]]; then
    print_success "No analysis issues found"
else
    echo "$ANALYZE_OUTPUT" | grep -E "(error|warning)" | head -10
    print_warning "Found analysis issues. They may be resolved after all setup steps complete."
fi

print_success "Step 2/6 completed: Dependencies and code generation" 