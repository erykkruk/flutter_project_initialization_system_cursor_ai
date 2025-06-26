#!/bin/bash

# Directory Structure Creation Script
# Creates Clean Architecture folder structure

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/colors.sh"
source "$SCRIPT_DIR/utils/helpers.sh"

IS_EXISTING_PROJECT="$1"

print_info "Creating Clean Architecture directory structure..."

# Core directories
ensure_directory "lib/core/clients"
ensure_directory "lib/core/config_tools"
ensure_directory "lib/core/constants"
ensure_directory "lib/core/converters"
ensure_directory "lib/core/exceptions"
ensure_directory "lib/core/network"
ensure_directory "lib/core/presentation"
ensure_directory "lib/core/services"
ensure_directory "lib/core/theme/styles"
ensure_directory "lib/core/widgets"

# Features directory  
ensure_directory "lib/features"

# Generated directory
ensure_directory "lib/generated/intl"

# Assets directories (only if they don't exist)
ensure_directory "assets/fonts"
ensure_directory "assets/icons"
ensure_directory "assets/images"
ensure_directory "assets/localizations"
ensure_directory "assets/splash"

# Test directories
ensure_directory "test/core"
ensure_directory "test/features"

# Warn if existing lib structure found
if [ "$IS_EXISTING_PROJECT" = true ]; then
    if [ -d "lib" ] && [ "$(ls -A lib 2>/dev/null)" ]; then
        print_warning "Found existing lib/ structure. Some files may be preserved."
        print_warning "Check for conflicts and merge manually if needed."
        
        # Show existing files that might need migration
        print_info "Existing files that may need migration:"
        find lib -name "*.dart" -not -path "lib/core/*" -not -path "lib/features/*" -not -path "lib/generated/*" -not -name "main.dart" 2>/dev/null | while read file; do
            if [ -f "$file" ]; then
                print_file "$file -> Consider moving to appropriate feature or core directory"
            fi
        done
    fi
fi

print_success "Directory structure created successfully" 