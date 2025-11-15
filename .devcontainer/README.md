# Dev Container Configuration

This directory contains the development container configuration for the Docker Multimodal learning repository.

## What's Included

### Base Environment
- **Python 3.12** - For running Python examples
- **Node.js LTS** - For running JavaScript examples
- **Docker-in-Docker** - Full Docker support inside the container
- **Zsh with Oh My Zsh** - Enhanced shell experience

### Pre-installed Tools
- `pip` - Python package manager
- `npm` - Node.js package manager
- `docker` - Docker CLI
- `git` - Version control

### VS Code Extensions
- **Python** - Python language support with IntelliSense
- **Pylance** - Fast Python language server
- **ESLint** - JavaScript linting
- **Prettier** - Code formatting
- **Docker** - Docker container management
- **GitHub Copilot** - AI pair programming

### Python Dependencies
- `openai>=1.0.0` - OpenAI API client for Docker Model Runner

### Node.js Dependencies
- `openai^4.0.0` - OpenAI API client for Docker Model Runner

## Getting Started

### Using with VS Code

1. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
2. Open this repository in VS Code
3. Click "Reopen in Container" when prompted (or use Command Palette: `Dev Containers: Reopen in Container`)
4. Wait for the container to build and setup to complete

### Using with GitHub Codespaces

1. Click the "Code" button in GitHub
2. Select "Codespaces" tab
3. Click "Create codespace on [branch]"
4. Wait for the environment to be ready

## What Happens on Container Creation

The `post-create.sh` script automatically:
1. Installs Python dependencies from `examples/requirements.txt`
2. Installs Node.js dependencies from `examples/package.json`
3. Makes shell scripts executable
4. Displays helpful quick start information

## Docker Support

The container includes Docker-in-Docker support, allowing you to:
- Run Docker Model Runner commands (`docker model ...`)
- Manage containers and images
- Use Docker Compose

**Note**: Docker Model Runner requires Docker Desktop, which may need to be running on your host machine for full functionality in some environments.

## Workspace Configuration

### Python Settings
- Default interpreter: `/usr/local/bin/python`
- Formatter: Black (auto-format on save)
- Linting: Enabled
- Tab size: 4 spaces

### JavaScript Settings
- Formatter: Prettier (auto-format on save)
- Tab size: 2 spaces

### Network
- Host networking enabled for easy access to Docker Model Runner API (port 8080)

## Customization

To customize this dev container:

1. Edit `.devcontainer/devcontainer.json` to:
   - Add more VS Code extensions
   - Change base image
   - Add additional features
   - Modify settings

2. Edit `.devcontainer/post-create.sh` to:
   - Install additional tools
   - Run custom setup commands
   - Configure additional services

## Troubleshooting

### Container won't start
- Ensure Docker is running on your host machine
- Check Docker Desktop version (should be recent)
- Try rebuilding: Command Palette → `Dev Containers: Rebuild Container`

### Docker commands don't work
- Verify Docker socket is mounted correctly
- Check Docker is running on the host
- Ensure Docker-in-Docker feature is enabled

### Dependencies not installed
- Manually run: `bash .devcontainer/post-create.sh`
- Or install individually:
  ```bash
  cd examples
  pip install -r requirements.txt
  npm install
  ```

## Resources

- [Dev Containers Documentation](https://code.visualstudio.com/docs/devcontainers/containers)
- [Dev Container Features](https://containers.dev/features)
- [Docker Model Runner Docs](https://docs.docker.com/desktop/features/model-runner/)
