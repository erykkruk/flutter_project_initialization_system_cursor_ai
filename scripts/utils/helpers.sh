#!/bin/bash

# Function to print colored output
print_step() {
    echo -e "${BLUE}🚀 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

print_file() {
    echo -e "${PURPLE}📄 $1${NC}"
}

# Function to backup files safely
backup_file() {
    local file_path="$1"
    if [ -f "$file_path" ]; then
        cp "$file_path" "${file_path}.backup"
        print_warning "Backed up existing $file_path to ${file_path}.backup"
        return 0
    fi
    return 1
}

# Function to create directory if it doesn't exist
ensure_directory() {
    local dir_path="$1"
    if [ ! -d "$dir_path" ]; then
        mkdir -p "$dir_path"
        print_info "Created directory: $dir_path"
    fi
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if we're in a Flutter project
is_flutter_project() {
    [ -f "pubspec.yaml" ] && grep -q "flutter:" pubspec.yaml
}

# Function to get current Flutter version
get_current_flutter_version() {
    if command_exists flutter; then
        flutter --version | head -n 1 | sed 's/Flutter //' | cut -d' ' -f1
    elif command_exists fvm && [ -f ".fvmrc" ]; then
        cat .fvmrc
    elif command_exists fvm; then
        fvm list | grep "active" | awk '{print $1}' || echo "unknown"
    else
        echo "none"
    fi
}

# Function to check if specific Flutter version is available via FVM
is_flutter_version_available() {
    local version="$1"
    if command_exists fvm; then
        fvm list | grep -q "^$version" || fvm releases | grep -q "^$version"
    else
        false
    fi
}

# Function to ask user about Flutter version
confirm_flutter_version() {
    local current_version="$1"
    local suggested_version="$2"
    
    if [ "$current_version" = "none" ]; then
        print_error "No Flutter installation found!"
        print_info "Please install Flutter first or use FVM to manage Flutter versions"
        exit 1
    fi
    
    if [ "$current_version" = "$suggested_version" ]; then
        print_success "Current Flutter version ($current_version) matches suggested version"
        return 0
    fi
    
    print_warning "Current Flutter version: $current_version"
    print_warning "Suggested version for this template: $suggested_version"
    echo ""
    print_info "Options:"
    echo "  1. Continue with current version ($current_version)"
    echo "  2. Switch to suggested version ($suggested_version) and continue"
    echo "  3. Exit and manually set desired version"
    echo ""
    read -p "Enter your choice (1/2/3): " choice
    
    case $choice in
        1)
            print_success "Continuing with current Flutter version: $current_version"
            return 0
            ;;
        2)
            if is_flutter_version_available "$suggested_version"; then
                print_info "Switching to Flutter $suggested_version..."
                if command_exists fvm; then
                    fvm use "$suggested_version" || {
                        print_error "Failed to switch to Flutter $suggested_version"
                        print_info "Installing Flutter $suggested_version..."
                        fvm install "$suggested_version" && fvm use "$suggested_version" || {
                            print_error "Failed to install Flutter $suggested_version"
                            exit 1
                        }
                    }
                    print_success "Switched to Flutter $suggested_version"
                    return 0
                else
                    print_error "FVM not available. Please install FVM or manually switch Flutter version"
                    exit 1
                fi
            else
                print_error "Flutter version $suggested_version not available"
                exit 1
            fi
            ;;
        3)
            print_info "Exiting. Please set your desired Flutter version and run the script again"
            print_info "Example: fvm use <your_desired_version>"
            exit 0
            ;;
        *)
            print_error "Invalid choice. Exiting."
            exit 1
            ;;
    esac
} 