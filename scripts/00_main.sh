#!/bin/bash

# Flutter Clean Architecture Project Initializer - Main Script
# This script orchestrates the creation/transformation of Flutter projects

set -e  # Exit on any error

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/helpers.sh"

# Define suggested Flutter version (can be updated as needed)
SUGGESTED_FLUTTER_VERSION="3.29.2"

# Check Flutter version and ask user for confirmation
print_step "Checking Flutter version..."
CURRENT_FLUTTER_VERSION=$(get_current_flutter_version)
print_info "Current Flutter version: $CURRENT_FLUTTER_VERSION"

confirm_flutter_version "$CURRENT_FLUTTER_VERSION" "$SUGGESTED_FLUTTER_VERSION"

# Update CURRENT_FLUTTER_VERSION in case it was changed
CURRENT_FLUTTER_VERSION=$(get_current_flutter_version)
export FLUTTER_VERSION="$CURRENT_FLUTTER_VERSION"

# Check if we're in an existing Flutter project
IS_EXISTING_PROJECT=false
if [ -f "pubspec.yaml" ] && grep -q "flutter:" pubspec.yaml; then
    IS_EXISTING_PROJECT=true
    PROJECT_NAME=$(grep "^name:" pubspec.yaml | cut -d' ' -f2)
    print_success "Detected existing Flutter project: $PROJECT_NAME"
    print_step "Transforming to Clean Architecture..."
else
    # Check if project name is provided for new project
    if [ $# -eq 0 ]; then
        print_error "Usage: $0 <project_name> [organization_name]"
        print_warning "Example: $0 my_awesome_app com.mycompany"
        print_warning "Or run in existing Flutter project directory without arguments"
        exit 1
    fi
    PROJECT_NAME=$1
    ORG_NAME=${2:-"com.yourcompany"}  # Default organization if not provided
    print_step "Creating new Flutter project: $PROJECT_NAME with organization: $ORG_NAME"
fi

# Step 1: Create directory structure
print_step "Step 1/6: Creating Clean Architecture structure..."
if [ "$IS_EXISTING_PROJECT" = false ]; then
    # For new projects, we need to create the project directory first
    mkdir -p "$PROJECT_NAME"
    cd "$PROJECT_NAME"
fi
"$SCRIPT_DIR/01_create_structure.sh" "$IS_EXISTING_PROJECT"

# Step 2: Setup dependencies
print_step "Step 2/6: Setting up dependencies..."
"$SCRIPT_DIR/02_setup_dependencies.sh" "$PROJECT_NAME" "$IS_EXISTING_PROJECT"

# Step 3: Create theme system
print_step "Step 3/6: Creating theme system..."
"$SCRIPT_DIR/03_create_theme.sh"

# Step 4: Setup dependency injection and routing
print_step "Step 4/6: Setting up dependency injection and routing..."
"$SCRIPT_DIR/04_setup_di_routing.sh"

# Step 5: Create core files and sample feature
print_step "Step 5/6: Creating core files and sample feature..."
"$SCRIPT_DIR/05_create_core_files.sh"

# Step 6: Setup configuration files
print_step "Step 6/6: Setting up configuration files..."
"$SCRIPT_DIR/06_setup_config.sh" "$IS_EXISTING_PROJECT"

# Finalize setup
print_step "Finalizing setup..."
print_info "Project setup completed!"
print_warning "Next steps:"

# Determine which Flutter command to show based on what's available
if command_exists fvm && [ -f ".fvmrc" ]; then
    FLUTTER_CMD="fvm flutter"
else
    FLUTTER_CMD="flutter"
fi

echo "  1. Run: $FLUTTER_CMD pub get"
echo "  2. Run: $FLUTTER_CMD pub run build_runner build"
echo "  3. Run: $FLUTTER_CMD pub run intl_utils:generate"
echo "  4. Run: $FLUTTER_CMD run"

print_success "🎉 Setup completed successfully!"
print_info "Using Flutter version: $CURRENT_FLUTTER_VERSION"

# Step 7: Generate missing files and fix linting issues
print_step "Step 7/7: Generating missing files and fixing linting issues..."
"$SCRIPT_DIR/generate_missing_files.sh"

# Final verification
print_success "✅ Setup completed successfully!"
print_info "Using Flutter version: $CURRENT_FLUTTER_VERSION" 