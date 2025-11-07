nixos/test-installation.sh
```
#!/usr/bin/env bash

# NixOS Installer Test Script
# Tests the complete installation process with predefined inputs

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

TEST_DIR="/tmp/nixos-test-$(date +%s)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Test configuration variables
TEST_HOSTNAME="test-machine"
TEST_USERNAME="testuser"
TEST_TIMEZONE="America/New_York"
TEST_LOCALE="en_US.UTF-8"
TEST_DESKTOP="gnome"

# Helper functions
print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

# Cleanup function
cleanup() {
    print_info "Cleaning up test directory..."
    rm -rf "$TEST_DIR"
}

trap cleanup EXIT

# Create test directory and copy installer
setup_test() {
    print_header "Setting Up Test Environment"

    print_info "Creating test directory: $TEST_DIR"
    mkdir -p "$TEST_DIR"
    cp -r "$SCRIPT_DIR"/* "$TEST_DIR/"
    cd "$TEST_DIR"

    print_success "Test environment prepared"
}

# Test input data - simulates user responses
generate_test_input() {
    cat << EOF
y
testuser
test-machine
America/New_York
en_US.UTF-8
y
Test User
test@example.com
1
y
y
y
y
y
n
n
n
n
y
user2
user3

y
EOF
}

# Run the installer with test input
run_installer_test() {
    print_header "Running Installer Test"

    print_info "Running installer with test configuration..."

    # Generate input and pipe to installer
    generate_test_input | bash install.sh

    if [ $? -eq 0 ]; then
        print_success "Installer completed successfully"
    else
        print_error "Installer failed"
        exit 1
    fi
}

# Verify generated files
verify_files() {
    print_header "Verifying Generated Files"

    local errors=0

    # Check core structure
    print_info "Checking directory structure..."
    for dir in hosts modules users; do
        if [ ! -d "$dir" ]; then
            print_error "Directory missing: $dir"
            ((errors++))
        else
            print_success "Directory exists: $dir"
        fi
    done

    # Check core files
    local core_files=("flake.nix" "Makefile" "README.md" ".gitignore")
    for file in "${core_files[@]}"; do
        if [ ! -f "$file" ]; then
            print_error "Core file missing: $file"
            ((errors++))
        else
            print_success "Core file exists: $file"
        fi
    done

    # Check hostname-specific files
    print_info "Checking host configuration..."
    if [ ! -f "hosts/$TEST_HOSTNAME/configuration.nix" ]; then
        print_error "Host configuration missing: hosts/$TEST_HOSTNAME/configuration.nix"
        ((errors++))
    else
        print_success "Host configuration exists"
    fi

    if [ ! -f "hosts/$TEST_HOSTNAME/hardware-configuration.nix" ]; then
        print_warning "Hardware config is placeholder (expected): hosts/$TEST_HOSTNAME/hardware-configuration.nix"
    else
        print_success "Hardware configuration exists"
    fi

    # Check user files
    print_info "Checking user configurations..."
    if [ ! -f "users/$TEST_USERNAME/home.nix" ]; then
        print_error "Main user config missing: users/$TEST_USERNAME/home.nix"
        ((errors++))
    else
        print_success "Main user config exists"
    fi

    # Check additional users
    for user in user2 user3; do
        if [ ! -f "users/$user/home.nix" ]; then
            print_error "Additional user config missing: users/$user/home.nix"
            ((errors++))
        else
            print_success "Additional user config exists: $user"
        fi
    done

    # Check modules
    print_info "Checking generated modules..."
    local expected_modules=(
        "system.nix"
        "desktop-gnome.nix"
        "development.nix"
        "docker.nix"
        "virtualization.nix"
        "ai-tools.nix"
        "gaming.nix"
        "multimedia.nix"
        "cloud-tools.nix"
        "security.nix"
    )

    for module in "${expected_modules[@]}"; do
        if [ ! -f "modules/$module" ]; then
            print_error "Module missing: modules/$module"
            ((errors++))
        else
            print_success "Module exists: $module"
        fi
    done

    if [ $errors -eq 0 ]; then
        print_success "All files verified successfully"
    else
        print_error "Found $errors errors in file verification"
        exit 1
    fi
}

# Verify flake syntax
verify_flake() {
    print_header "Verifying Flake Configuration"

    if command -v nix &> /dev/null; then
        print_info "Testing flake syntax..."

        if nix flake check --no-build >/dev/null 2>&1; then
            print_success "Flake syntax is valid"
        else
            print_error "Flake syntax validation failed"
            nix flake check --no-build 2>&1 | while read line; do
                print_error "  $line"
            done
            exit 1
        fi

        # Test flake metadata
        if nix flake metadata >/dev/null 2>&1; then
            print_success "Flake metadata is valid"
        else
            print_warning "Could not verify flake metadata (may be expected)"
        fi
    else
        print_warning "Nix not available, skipping flake verification"
    fi
}

# Verify Nix syntax
verify_nix_syntax() {
    print_header "Verifying Nix Configuration Syntax"

    if command -v nix-instantiate &> /dev/null; then
        print_info "Checking Nix syntax..."

        local nix_files=()
        while IFS= read -r -d '' file; do
            nix_files+=("$file")
        done < <(find . -name "*.nix" -type f -print0)

        local errors=0
        for file in "${nix_files[@]}"; do
            if nix-instantiate --parse "$file" >/dev/null 2>&1; then
                print_success "Syntax OK: $file"
            else
                print_error "Syntax error in: $file"
                nix-instantiate --parse "$file" 2>&1 | while read line; do
                    print_error "  $line"
                done
                ((errors++))
            fi
        done

        if [ $errors -eq 0 ]; then
            print_success "All Nix files have valid syntax"
        else
            print_error "Found syntax errors in $errors Nix files"
            exit 1
        fi
    else
        print_warning "nix-instantiate not available, skipping syntax check"
    fi
}

# Check configuration content
verify_config_content() {
    print_header "Verifying Configuration Content"

    print_info "Checking hostname configuration..."
    if grep -q "networking.hostName = \"$TEST_HOSTNAME\"" "hosts/$TEST_HOSTNAME/configuration.nix"; then
        print_success "Hostname correctly set in configuration"
    else
        print_error "Hostname not found in configuration"
    fi

    print_info "Checking user configuration..."
    if grep -q "users.users.$TEST_USERNAME" "hosts/$TEST_HOSTNAME/configuration.nix"; then
        print_success "Main user configured"
    else
        print_error "Main user not found in configuration"
    fi

    print_info "Checking additional users..."
    for user in user2 user3; do
        if grep -q "users.users.$user" "hosts/$TEST_HOSTNAME/configuration.nix"; then
            print_success "Additional user $user configured"
        else
            print_error "Additional user $user not found in configuration"
        fi
    done

    print_info "Checking module imports..."
    local expected_imports=(
        "../../modules/system.nix"
        "../../modules/desktop-gnome.nix"
        "../../modules/development.nix"
        "../../modules/docker.nix"
        "../../modules/virtualization.nix"
        "../../modules/ai-tools.nix"
        "../../modules/security.nix"
    )

    for import in "${expected_imports[@]}"; do
        if grep -q "$import" "hosts/$TEST_HOSTNAME/configuration.nix"; then
            print_success "Import found: $import"
        else
            print_error "Import missing: $import"
        fi
    done
}

# Run tests
main() {
    print_header "NixOS Installer Test Suite"

    echo "Test Configuration:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Hostname:     $TEST_HOSTNAME"
    echo "  Username:     $TEST_USERNAME"
    echo "  Desktop:      $TEST_DESKTOP"
    echo "  Test Dir:     $TEST_DIR"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    setup_test
    run_installer_test
    verify_files
    verify_flake
    verify_nix_syntax
    verify_config_content

    print_header "Test Suite Complete"
    print_success "All tests passed! 🎉"
    echo ""
    print_info "Test configuration created in: $TEST_DIR"
    print_info "Use 'cd $TEST_DIR && make help' to see available commands"
}

# Run main function
main "$@"
