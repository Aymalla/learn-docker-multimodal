# Quick Start Guide - Docker Multimodal

Get up and running with Docker Multimodal AI in 5 minutes!

## Step 1: Install Docker Desktop

Download and install Docker Desktop (v4.36+):
- **macOS**: https://docs.docker.com/desktop/install/mac-install/
- **Windows**: https://docs.docker.com/desktop/install/windows-install/
- **Linux**: https://docs.docker.com/desktop/install/linux-install/

Launch Docker Desktop after installation.

## Step 2: Try Your First Command

Open your terminal and run:

```bash
docker model run gemma3 "What is artificial intelligence?"
```

This will:
1. Download the Gemma3 model (if not already downloaded)
2. Run the model
3. Return a response to your question

## Step 3: Analyze an Image

Download a sample image or use your own:

```bash
# Download a sample image
curl -o sample.jpg https://picsum.photos/800/600

# Analyze it
docker model run gemma3 "Describe this image: sample.jpg"
```

## Step 4: Start Interactive Mode

For a conversation-style experience:

```bash
docker model run -it gemma3
```

Now you can type questions and get responses interactively. Type `exit` or press `Ctrl+C` to quit.

## Step 5: Use the API

Start a model server:

```bash
docker model serve gemma3 -p 8080
```

In another terminal, test the API:

```bash
curl -X POST http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gemma3",
    "messages": [
      {"role": "user", "content": "Hello! Can you help me?"}
    ]
  }'
```

## Next Steps

### Try Different Models

```bash
# List available models
docker model list

# Try a lightweight vision model
docker model run moondream2 "What's in this image? photo.jpg"

# Use LLaVA for detailed analysis
docker model run llava "Analyze this image in detail: screenshot.png"
```

### Use with Programming Languages

**Python**:
```bash
pip install openai
python examples/simple_image_analysis.py your-image.jpg
```

**JavaScript**:
```bash
npm install openai
node examples/simple_image_analysis.js your-image.jpg
```

### Explore Examples

Check out the `examples/` directory for:
- Simple image analysis (Python & JavaScript)
- Batch processing multiple images
- CLI tool with menu interface
- Integration examples

### Read Full Documentation

See [README.md](README.md) for comprehensive documentation including:
- How multimodal models work
- Advanced usage patterns
- Integration with LangChain and LlamaIndex
- Best practices and troubleshooting

## Common Commands Cheat Sheet

```bash
# List models
docker model list

# Pull a model
docker model pull moondream2

# Run with text
docker model run gemma3 "Your question here"

# Run with image
docker model run gemma3 "Describe this: image.jpg"

# Interactive mode
docker model run -it gemma3

# Start API server
docker model serve gemma3 -p 8080

# Stop a running model
docker model stop

# Remove a model
docker model rm gemma3

# Get model info
docker model inspect gemma3
```

## Troubleshooting Quick Fixes

**Problem**: Command not found
- **Solution**: Update Docker Desktop to v4.36 or later

**Problem**: Out of memory
- **Solution**: Try a smaller model like `moondream2`

**Problem**: Slow performance
- **Solution**: First run is always slower (downloading model)

**Problem**: Connection refused (API)
- **Solution**: Make sure server is running: `docker model serve gemma3 -p 8080`

## Get Help

- 📖 [Full Documentation](README.md)
- 💻 [Example Code](examples/)
- 🐳 [Docker Docs](https://docs.docker.com/desktop/features/model-runner/)
- 💬 [Docker Community Forums](https://forums.docker.com/)

---

**You're all set! Start building amazing multimodal AI applications! 🚀**
