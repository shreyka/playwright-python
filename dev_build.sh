#!/bin/bash

# Development build script for playwright-python with custom driver

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to clean all artifacts
clean_all() {
    print_status "Cleaning all build artifacts..."
    rm -rf build/ dist/ playwright.egg-info/ driver/ playwright/driver/ .eggs/
    find . -name "*.pyc" -delete
    find . -name "__pycache__" -delete -type d
    print_status "Clean complete"
}

# Function to clean just driver artifacts
clean_driver() {
    print_status "Cleaning driver artifacts..."
    rm -rf driver/ playwright/driver/
    print_status "Driver clean complete"
}

# Function to build wheel
build_wheel() {
    print_status "Building wheel..."
    python -m build --wheel
    print_status "Wheel build complete"
}

# Function to build Linux wheel
build_linux_wheel() {
    print_status "Building Linux wheel for deployment..."
    PLAYWRIGHT_TARGET_WHEEL=manylinux1_x86_64.whl python -m build --wheel
    print_status "Linux wheel build complete"
}

# Function to build all platform wheels
build_all_wheels() {
    print_status "Building wheels for all platforms..."
    clean_all
    
    # Build for current platform
    python -m build --wheel
    
    # Build for Linux (most common deployment target)
    PLAYWRIGHT_TARGET_WHEEL=manylinux1_x86_64.whl python -m build --wheel
    
    # Build for other platforms if needed
    # PLAYWRIGHT_TARGET_WHEEL=win_amd64.whl python -m build --wheel
    # PLAYWRIGHT_TARGET_WHEEL=macosx_11_0_arm64.whl python -m build --wheel
    
    print_status "All wheels built. Available wheels:"
    ls -la dist/*.whl
}

# Function to show available wheels
show_wheels() {
    print_status "Available wheels:"
    if [ -d "dist" ] && [ "$(ls -A dist/*.whl 2>/dev/null)" ]; then
        ls -la dist/*.whl
    else
        print_warning "No wheels found. Run './dev_build.sh build' or './dev_build.sh linux' first."
    fi
}

# Function to install editable
install_editable() {
    print_status "Installing in editable mode..."
    pip uninstall playwright -y 2>/dev/null || true
    pip install -e .
    print_status "Editable install complete"
}

# Function to install wheel
install_wheel() {
    print_status "Installing from wheel..."
    pip install --force-reinstall dist/*.whl
    print_status "Wheel install complete"
}

# Function to test installation
test_install() {
    print_status "Testing installation..."
    python -c "
from playwright._repo_version import version
print(f'Version: {version}')

from playwright._impl._driver import compute_driver_executable
node_path, cli_path = compute_driver_executable()
import os
print(f'Driver found: {os.path.exists(cli_path) if cli_path else False}')
print('Installation test passed!')
"
}

# Function to install browsers
install_browsers() {
    print_status "Installing browsers..."
    python -m playwright install
    print_status "Browser installation complete"
}

# Function to check browser status
check_browsers() {
    print_status "Checking browser installations..."
    python -c "
from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    print('Browser status:')
    for browser_name in ['chromium', 'firefox', 'webkit']:
        try:
            browser_type = getattr(p, browser_name)
            print(f'  {browser_name}: ✅ Available at {browser_type.executable_path}')
        except Exception as e:
            print(f'  {browser_name}: ❌ Not available - {str(e)[:50]}...')
"
}

# Function for full setup
full_setup() {
    print_status "Full development setup..."
    clean_driver
    install_editable
    test_install
    install_browsers
    check_browsers
    print_status "Full setup complete! Ready for development."
}

# Main command handling
case "${1:-help}" in
    "clean")
        clean_all
        ;;
    "clean-driver")
        clean_driver
        ;;
    "build")
        build_wheel
        ;;
    "dev")
        print_status "Setting up development environment..."
        clean_driver
        install_editable
        test_install
        ;;
    "wheel")
        print_status "Building and installing wheel..."
        clean_all
        build_wheel
        install_wheel
        test_install
        ;;
    "quick")
        print_status "Quick driver rebuild..."
        clean_driver
        build_wheel
        install_wheel
        test_install
        ;;
    "test")
        test_install
        ;;
    "browsers")
        install_browsers
        ;;
    "check")
        check_browsers
        ;;
    "setup")
        full_setup
        ;;
    "linux")
        build_linux_wheel
        ;;
    "all")
        build_all_wheels
        ;;
    "show")
        show_wheels
        ;;
    "help"|*)
        echo "Usage: $0 {clean|clean-driver|build|dev|wheel|quick|test|browsers|check|setup|linux|all|show}"
        echo ""
        echo "Commands:"
        echo "  clean        - Clean all build artifacts"
        echo "  clean-driver - Clean only driver artifacts"
        echo "  build        - Build wheel only"
        echo "  dev          - Setup for development (editable install)"
        echo "  wheel        - Full clean wheel build and install"
        echo "  quick        - Quick driver rebuild (no full clean)"
        echo "  test         - Test current installation"
        echo "  browsers     - Install browser binaries"
        echo "  check        - Check browser installation status"
        echo "  setup        - Full setup (dev + browsers)"
        echo "  linux        - Build Linux wheel for deployment"
        echo "  all          - Build wheels for all platforms"
        echo "  show         - Show available wheels"
        echo "  help         - Show this help"
        ;;
esac 