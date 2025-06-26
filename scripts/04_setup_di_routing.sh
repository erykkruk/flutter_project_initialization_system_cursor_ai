#!/bin/bash

# Dependency Injection and Routing Setup Script
# Creates DI configuration and routing setup

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/helpers.sh"

print_info "Setting up dependency injection and routing..."

# Create dependency injection configuration
print_file "Creating lib/core/config_tools/injection.dart"
cat > lib/core/config_tools/injection.dart << 'EOF'
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final GetIt inject = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await inject.init();
}
EOF

# Create app router configuration
print_file "Creating lib/core/config_tools/app_router.dart"
cat > lib/core/config_tools/app_router.dart << 'EOF'
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import '../../features/home/presentation/screens/home_screen.dart';

@singleton
class AppRouter {
  static const String homeRoute = '/';
  static const String settingsRoute = '/settings';

  final GoRouter router = GoRouter(
    initialLocation: homeRoute,
    routes: [
      GoRoute(
        path: homeRoute,
        builder: (context, state) => const HomeScreen(),
      ),
      // Add more routes here as your app grows
      // GoRoute(
      //   path: settingsRoute,
      //   builder: (context, state) => const SettingsScreen(),
      // ),
    ],
  );
}
EOF

print_success "Dependency injection and routing setup completed" 