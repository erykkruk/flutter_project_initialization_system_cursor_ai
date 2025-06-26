#!/bin/bash

# Quick fix script to generate missing files that cause linting errors
# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/helpers.sh"

echo "${YELLOW}Generating missing files to fix linting errors...${NC}"

cd "$PROJECT_ROOT"

# Create lib/generated directory if it doesn't exist
mkdir -p "lib/generated"

# Create minimal l10n.dart file if missing
if [[ ! -f "lib/generated/l10n.dart" ]]; then
    print_info "Creating lib/generated/l10n.dart..."
    cat > "lib/generated/l10n.dart" << 'EOF'
// Auto-generated localization file
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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

  String get appTitle => intl.Intl.message(
    'Museum Art',
    name: 'appTitle',
    desc: '',
    args: [],
  );

  String get welcomeMessage => intl.Intl.message(
    'Welcome to Museum Art',
    name: 'welcomeMessage',
    desc: '',
    args: [],
  );

  String get getStarted => intl.Intl.message(
    'Get Started',
    name: 'getStarted',
    desc: '',
    args: [],
  );

  String get buttonPressed => intl.Intl.message(
    'Button pressed!',
    name: 'buttonPressed',
    desc: '',
    args: [],
  );
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
    print_success "Created lib/generated/l10n.dart"
else
    print_info "lib/generated/l10n.dart already exists"
fi

# Create minimal injection.config.dart file if missing
if [[ ! -f "lib/core/config_tools/injection.config.dart" ]]; then
    print_info "Creating lib/core/config_tools/injection.config.dart..."
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

import 'app_router.dart' as _i1025;

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
    print_success "Created lib/core/config_tools/injection.config.dart"
else
    print_info "lib/core/config_tools/injection.config.dart already exists"
fi

# Run flutter analyze to check current status
print_info "Checking analysis status..."
ANALYZE_OUTPUT=$(fvm flutter analyze 2>&1)
ANALYZE_EXIT_CODE=$?

if [[ $ANALYZE_EXIT_CODE -eq 0 ]]; then
    print_success "✓ No analysis issues found!"
else
    ERROR_COUNT=$(echo "$ANALYZE_OUTPUT" | grep -c "error •" 2>/dev/null || echo "0")
    WARNING_COUNT=$(echo "$ANALYZE_OUTPUT" | grep -c "warning •" 2>/dev/null || echo "0")
    
    echo "${YELLOW}Analysis Summary:${NC}"
    echo "  Errors: $ERROR_COUNT"
    echo "  Warnings: $WARNING_COUNT"
    
    if [[ $ERROR_COUNT -gt 0 ]]; then
        echo ""
        echo "${RED}Remaining errors:${NC}"
        echo "$ANALYZE_OUTPUT" | grep "error •" | head -5
    fi
    
    if [[ $WARNING_COUNT -gt 0 ]]; then
        echo ""
        echo "${YELLOW}Remaining warnings:${NC}"
        echo "$ANALYZE_OUTPUT" | grep "warning •" | head -3
    fi
fi

print_success "Missing files generation completed!"
echo ""
echo "${YELLOW}If you still have errors, run:${NC}"
echo "• fvm dart run build_runner build --delete-conflicting-outputs"
echo "• fvm flutter gen-l10n"
echo "• fvm flutter pub get" 