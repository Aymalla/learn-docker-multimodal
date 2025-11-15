#!/bin/bash
#
# Docker Model Runner CLI Tool Example
#
# This script demonstrates various ways to use Docker Model Runner
# from the command line for multimodal AI tasks.
#
# Prerequisites:
# - Docker Desktop installed (v4.36+)
#
# Usage:
#   chmod +x cli_tool.sh
#   ./cli_tool.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored message
print_info() {
    echo -e "${BLUE}ℹ ${1}${NC}"
}

print_success() {
    echo -e "${GREEN}✓ ${1}${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ ${1}${NC}"
}

print_error() {
    echo -e "${RED}✗ ${1}${NC}"
}

# Check if Docker is running
check_docker() {
    if ! docker info >/dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker Desktop."
        exit 1
    fi
    print_success "Docker is running"
}

# List available models
list_models() {
    print_info "Available models:"
    docker model list
}

# Run a simple text query
run_text_query() {
    local model=$1
    local query=$2
    
    print_info "Running query on ${model}..."
    docker model run "${model}" "${query}"
}

# Run image analysis
run_image_analysis() {
    local model=$1
    local image_path=$2
    local question=${3:-"Describe this image in detail"}
    
    if [ ! -f "${image_path}" ]; then
        print_error "Image file not found: ${image_path}"
        return 1
    fi
    
    print_info "Analyzing image: ${image_path}"
    docker model run "${model}" "${question} ${image_path}"
}

# Interactive mode
interactive_mode() {
    local model=${1:-gemma3}
    
    print_info "Starting interactive session with ${model}"
    print_info "Type your questions below (Ctrl+C to exit)"
    echo ""
    
    docker model run -it "${model}"
}

# Main menu
show_menu() {
    echo ""
    echo "=================================="
    echo "Docker Model Runner CLI Tool"
    echo "=================================="
    echo ""
    echo "1) List available models"
    echo "2) Run text query"
    echo "3) Analyze an image"
    echo "4) Interactive mode"
    echo "5) Pull a new model"
    echo "6) Exit"
    echo ""
}

# Main function
main() {
    print_info "Docker Model Runner CLI Tool"
    echo ""
    
    check_docker
    
    while true; do
        show_menu
        read -p "Select an option (1-6): " choice
        
        case $choice in
            1)
                list_models
                ;;
            2)
                read -p "Enter model name (default: gemma3): " model
                model=${model:-gemma3}
                read -p "Enter your question: " query
                run_text_query "${model}" "${query}"
                ;;
            3)
                read -p "Enter model name (default: gemma3): " model
                model=${model:-gemma3}
                read -p "Enter image path: " image_path
                read -p "Enter question (or press Enter for default): " question
                run_image_analysis "${model}" "${image_path}" "${question}"
                ;;
            4)
                read -p "Enter model name (default: gemma3): " model
                model=${model:-gemma3}
                interactive_mode "${model}"
                ;;
            5)
                read -p "Enter model name to pull: " model
                if [ -n "${model}" ]; then
                    print_info "Pulling model: ${model}"
                    docker model pull "${model}"
                    print_success "Model pulled successfully"
                fi
                ;;
            6)
                print_info "Goodbye!"
                exit 0
                ;;
            *)
                print_error "Invalid option. Please select 1-6."
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
    done
}

# Quick examples function (can be called directly)
quick_examples() {
    echo "Quick Examples:"
    echo ""
    echo "1. List models:"
    echo "   docker model list"
    echo ""
    echo "2. Simple query:"
    echo "   docker model run gemma3 'What is Docker?'"
    echo ""
    echo "3. Analyze image:"
    echo "   docker model run gemma3 'Describe this image: photo.jpg'"
    echo ""
    echo "4. Interactive mode:"
    echo "   docker model run -it gemma3"
    echo ""
    echo "5. Start API server:"
    echo "   docker model serve gemma3 -p 8080"
}

# Parse command line arguments
if [ $# -gt 0 ]; then
    case $1 in
        --examples)
            quick_examples
            exit 0
            ;;
        --help)
            echo "Usage: $0 [--examples|--help]"
            echo ""
            echo "Options:"
            echo "  --examples    Show quick example commands"
            echo "  --help        Show this help message"
            echo ""
            echo "Run without arguments for interactive menu"
            exit 0
            ;;
    esac
fi

# Run main function
main
