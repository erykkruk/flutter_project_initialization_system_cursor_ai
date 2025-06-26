#!/bin/bash

# Theme System Creation Script
# Creates core theme system files: colors, typography, and dimensions

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/helpers.sh"

print_info "Creating core theme system files..."

# Colors
print_file "Creating lib/core/theme/styles/colors.dart"
cat > lib/core/theme/styles/colors.dart << 'EOF'
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Light theme colors
  static const Color primaryLight = Color(0xFF2196F3);
  static const Color primaryVariantLight = Color(0xFF1976D2);
  static const Color secondaryLight = Color(0xFF03DAC6);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color errorLight = Color(0xFFB00020);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onSecondaryLight = Color(0xFF000000);
  static const Color onSurfaceLight = Color(0xFF000000);
  static const Color onBackgroundLight = Color(0xFF000000);
  static const Color onErrorLight = Color(0xFFFFFFFF);

  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
}
EOF

# Dimensions
print_file "Creating lib/core/theme/styles/dimensions.dart"
cat > lib/core/theme/styles/dimensions.dart << 'EOF'
class AppDimensions {
  AppDimensions._();

  // Spacing (8-point grid system)
  static const double spacing2xs = 4.0;
  static const double spacingXs = 8.0;
  static const double spacingS = 12.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXl = 32.0;
  static const double spacing2xl = 48.0;
  static const double spacing3xl = 64.0;

  // Border Radius
  static const double radiusXs = 2.0;
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusRound = 999.0;

  // Component Sizes
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 32.0;
  static const double buttonHeightLarge = 56.0;
  static const double inputHeight = 56.0;
  static const double iconSize = 24.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeLarge = 32.0;

  // Layout
  static const double maxContentWidth = 1200.0;
  static const double sidebarWidth = 280.0;
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 80.0;

  // Elevation
  static const double elevationNone = 0.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
}
EOF

# Typography
print_file "Creating lib/core/theme/styles/typography.dart"
cat > lib/core/theme/styles/typography.dart << 'EOF'
import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  // Font families
  static const String primaryFontFamily = 'Roboto';
  static const String secondaryFontFamily = 'Roboto';

  // Text styles - Display
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57.0,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 45.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    height: 1.16,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    height: 1.22,
  );

  // Text styles - Headline
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    height: 1.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    height: 1.29,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    height: 1.33,
  );

  // Text styles - Title
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    height: 1.27,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.50,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  // Text styles - Body
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.50,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  // Text styles - Label
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );
}
EOF

print_success "Core theme system files created successfully" 