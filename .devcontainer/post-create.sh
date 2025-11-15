#!/bin/bash

# Post-create script for setting up the development environment

set -e

echo "🚀 Setting up Docker Multimodal development environment..."

# Install Python dependencies
echo "📦 Installing Python dependencies..."
cd /workspaces/learn-docker-multimodal/examples
pip install --user -r requirements.txt

# Install Node.js dependencies
echo "📦 Installing Node.js dependencies..."
npm install

# Make shell scripts executable
echo "🔧 Making shell scripts executable..."
chmod +x cli_tool.sh

# Return to workspace root
cd /workspaces/learn-docker-multimodal

echo "✅ Development environment setup complete!"
echo ""
echo "📚 Quick Start:"
echo "  - Python examples: cd examples && python simple_image_analysis.py"
echo "  - Node.js examples: cd examples && node simple_image_analysis.js"
echo "  - CLI tool: cd examples && ./cli_tool.sh"
echo ""
echo "🐳 Docker Model Runner commands:"
echo "  - List models: docker model list"
echo "  - Run a model: docker model run gemma3 'Hello!'"
echo "  - Start API server: docker model serve gemma3 -p 8080"
echo ""
echo "📖 Documentation: Check README.md, QUICKSTART.md, and FAQ.md"
