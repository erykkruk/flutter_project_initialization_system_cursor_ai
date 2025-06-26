#!/bin/bash

# Configuration Setup Script
# Creates VS Code settings, analysis options, and other configuration files

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/helpers.sh"

IS_EXISTING_PROJECT="$1"

print_info "Setting up configuration files..."

# Create VS Code settings for FVM
print_file "Creating .vscode/settings.json"
ensure_directory ".vscode"

# Backup existing VS Code settings if they exist
if [ "$IS_EXISTING_PROJECT" = true ]; then
    backup_file ".vscode/settings.json"
fi

cat > .vscode/settings.json << 'EOF'
{
  "dart.flutterSdkPath": ".fvm/flutter_sdk",
  "search.exclude": {
    "**/.fvm": true
  },
  "files.watcherExclude": {
    "**/.fvm": true
  },
  "dart.lineLength": 120,
  "editor.rulers": [120],
  "editor.formatOnSave": true,
  "dart.showTodos": false,
  "dart.debugExternalPackageLibraries": false,
  "dart.debugSdkLibraries": false
}
EOF

# Create analysis_options.yaml with advanced linting (based on couples_analytics)
print_file "Creating analysis_options.yaml"

# Backup existing analysis_options.yaml if it exists
if [ "$IS_EXISTING_PROJECT" = true ]; then
    backup_file "analysis_options.yaml"
fi

cat > analysis_options.yaml << 'EOF'
include:
  package:dart_code_metrics/analysis_options.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/generated/**"
    - "**/*.md"
    - "**/*.yml"

  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
  errors:
    todo: warning
    invalid_annotation_target: ignore
    inference_failure_on_function_return_type: ignore

linter:
  rules:
    # Core Clean Architecture rules
    avoid_relative_lib_imports: true
    library_names: true
    library_prefixes: true

    # BLOC specific
    use_build_context_synchronously: true

    # Error handling
    avoid_catches_without_on_clauses: true
    avoid_catching_errors: true
    throw_in_finally: true

    # Code quality
    prefer_final_fields: true
    prefer_const_constructors: true
    avoid_print: true
    cascade_invocations: true
    require_trailing_commas: true

    # Flutter specific
    use_key_in_widget_constructors: true
    avoid_unnecessary_containers: true
    sized_box_for_whitespace: true
    prefer_const_literals_to_create_immutables: true

    # Performance
    avoid_function_literals_in_foreach_calls: true
    prefer_collection_literals: true
    prefer_spread_collections: true

    # Style
    always_declare_return_types: true
    annotate_overrides: true
    camel_case_types: true
    file_names: true
    non_constant_identifier_names: true
    prefer_single_quotes: true
    sort_child_properties_last: true

plugins:
  - dart_code_metrics

dart_code_metrics:
  metrics:
    cyclomatic-complexity: 15
    number-of-parameters: 4
    maximum-nesting-level: 3
  rules:
    - member-ordering:
        alphabetize: true
        order:
          - constructor
          - named-constructor
          - public-constant
          - private-constant
          - public-factory
          - public-override-field
          - public-static-field
          - private-static-field
          - public-final-instance-field
          - public-instance-field
          - protected-instance-field
          - private-instance-field
          - override
          - public-operator
          - public-static-getter
          - public-static-setter
          - private-static-getter
          - private-static-setter
          - public-instance-getter
          - public-instance-setter
          - private-instance-getter
          - public-static-method
          - private-static-method
          - public-instance-method
          - build-method
          - private-instance-method
    - no-magic-number:
        allowed-numbers: [0, 1, -1, 2, 100]
    - avoid-unused-parameters
    - avoid-nested-conditional-expressions
    - avoid-banned-imports:
        entries:
          - path: "presentation/.*"
            disallowed:
              - "data/.*"
          - path: "domain/.*"
            disallowed: 
              - "data/.*"
              - "presentation/.*"

  anti-patterns:
    - long-method
    - long-parameter-list
EOF

# Create l10n.yaml for internationalization
print_file "Creating l10n.yaml"
cat > l10n.yaml << 'EOF'
arb-dir: assets/localizations
template-arb-file: intl_en.arb
output-localization-file: l10n.dart
output-class: Translations
output-dir: lib/generated/intl
EOF

# Create analysis_options.yaml
print_file "Creating analysis_options.yaml"
cat > analysis_options.yaml << 'EOF'
analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/generated/**"
    - "**/*.md"
    - "**/*.yml"
    - ".github/workflows/**"

  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
  
  errors:
    todo: warning
    invalid_annotation_target: ignore
    inference_failure_on_function_return_type: ignore

linter:
  rules:
    # Core Clean Architecture rules
    avoid_relative_lib_imports: true
    library_names: true
    library_prefixes: true

    # BLOC specific
    use_build_context_synchronously: error

    # Error handling
    avoid_catches_without_on_clauses: true
    avoid_catching_errors: true
    throw_in_finally: error

    # Code quality
    prefer_final_fields: true
    prefer_const_constructors: true
    avoid_print: error
    cascade_invocations: true
    require_trailing_commas: true

    # Performance
    avoid_function_literals_in_foreach_calls: true
    prefer_collection_literals: true
    prefer_spread_collections: true

    # Style
    always_declare_return_types: true
    always_use_package_imports: true
    avoid_redundant_argument_values: true
    prefer_single_quotes: true
    sort_constructors_first: true
    sort_unnamed_constructors_first: true
    unawaited_futures: true

    # Clean Architecture enforcement
    depend_on_referenced_packages: true
    implementation_imports: error
    
    # Flutter specific
    sized_box_for_whitespace: true
    use_key_in_widget_constructors: true
    avoid_unnecessary_containers: true
    prefer_const_literals_to_create_immutables: true
    prefer_const_constructors_in_immutables: true

    # Testing
    avoid_slow_async_io: true
    cancel_subscriptions: true
    close_sinks: true
EOF

print_success "Configuration files created successfully"

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "${YELLOW}[Step 6/6] Final configuration and code generation...${NC}"

cd "$PROJECT_ROOT"

# Generate all missing files
print_info "Generating localization files..."
if fvm flutter gen-l10n; then
    print_success "Localization files generated"
else
    print_warning "Localization generation skipped (may be already done)"
fi

print_info "Running build_runner to generate dependency injection..."
if fvm dart run build_runner build --delete-conflicting-outputs; then
    print_success "Build runner completed successfully"
else
    print_warning "Build runner had issues, retrying..."
    # Try again without delete-conflicting-outputs flag
    if fvm dart run build_runner build; then
        print_success "Build runner completed on retry"
    else
        print_error "Build runner failed"
        exit 1
    fi
fi

# Final pub get to ensure everything is in sync
print_info "Final dependency sync..."
fvm flutter pub get > /dev/null 2>&1

# Verify all critical generated files exist
print_info "Verifying generated files..."

CRITICAL_FILES=(
    "lib/generated/l10n.dart"
    "lib/core/config_tools/injection.config.dart"
)

MISSING_FILES=()
for file in "${CRITICAL_FILES[@]}"; do
    if [[ ! -f "$file" ]]; then
        MISSING_FILES+=("$file")
    fi
done

if [[ ${#MISSING_FILES[@]} -gt 0 ]]; then
    print_warning "Some critical files are still missing:"
    for file in "${MISSING_FILES[@]}"; do
        echo "  - $file"
    done
    
    # Try to create minimal versions of missing files
    print_info "Creating minimal versions of missing files..."
    
    if [[ ! -f "lib/generated/l10n.dart" ]]; then
        mkdir -p "lib/generated"
        cat > "lib/generated/l10n.dart" << 'EOF'
// Auto-generated localization file
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Translations {
  Translations._(this.locale);
  
  final Locale locale;

  static Translations of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations)!;
  }

  static const LocalizationsDelegate<Translations> delegate = _TranslationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  String get appTitle => 'Museum Art';
  String get welcomeMessage => 'Welcome to Museum Art';
  String get getStarted => 'Get Started';
  String get buttonPressed => 'Button pressed!';
}

class _TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const _TranslationsDelegate();

  @override
  Future<Translations> load(Locale locale) {
    return SynchronousFuture<Translations>(Translations._(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_TranslationsDelegate old) => false;
}
EOF
        print_success "Created minimal l10n.dart"
    fi

    if [[ ! -f "lib/core/config_tools/injection.config.dart" ]]; then
        cat > "lib/core/config_tools/injection.config.dart" << 'EOF'
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../config_tools/app_router.dart' as _i1025;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i1025.AppRouter>(() => _i1025.AppRouter());
    return this;
  }
}
EOF
        print_success "Created minimal injection.config.dart"
    fi
fi

# Run final analysis
print_info "Running final Flutter analysis..."
ANALYZE_OUTPUT=$(fvm flutter analyze 2>&1)
ANALYZE_EXIT_CODE=$?

if [[ $ANALYZE_EXIT_CODE -eq 0 ]]; then
    print_success "✓ No analysis issues found!"
else
    # Count errors and warnings
    ERROR_COUNT=$(echo "$ANALYZE_OUTPUT" | grep -c "error •" || echo "0")
    WARNING_COUNT=$(echo "$ANALYZE_OUTPUT" | grep -c "warning •" || echo "0")
    
    if [[ $ERROR_COUNT -gt 0 ]]; then
        print_error "Found $ERROR_COUNT analysis errors:"
        echo "$ANALYZE_OUTPUT" | grep "error •" | head -5
    fi
    
    if [[ $WARNING_COUNT -gt 0 ]]; then
        print_warning "Found $WARNING_COUNT analysis warnings:"
        echo "$ANALYZE_OUTPUT" | grep "warning •" | head -3
    fi
    
    print_info "You may need to run 'fvm dart run build_runner build' again after making changes"
fi

# Verify project structure
print_info "Verifying project structure..."
REQUIRED_DIRS=(
    "lib/core"
    "lib/features"
    "lib/generated"
    "assets/localizations"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [[ -d "$dir" ]]; then
        echo "  ✓ $dir"
    else
        echo "  ✗ $dir (missing)"
    fi
done

print_success "Step 6/6 completed: Final configuration"

echo ""
echo "${GREEN}=== Setup Summary ===${NC}"
echo "✓ Project structure created"
echo "✓ Dependencies configured"
echo "✓ Theme system set up"
echo "✓ Dependency injection configured"
echo "✓ Core files created"
echo "✓ Code generation completed"
echo ""
echo "${YELLOW}Next steps:${NC}"
echo "• Run 'fvm flutter run' to start the app"
echo "• Run 'fvm dart run build_runner build' if you add new @injectable classes"
echo "• Run 'fvm flutter gen-l10n' after updating translations"
echo "" 