# Frequently Asked Questions (FAQ)

Common questions about Docker Multimodal and Docker Model Runner.

## General Questions

### What is Docker Model Runner?

Docker Model Runner is a feature integrated into Docker Desktop that allows you to run AI models locally on your machine. It provides both a CLI and an OpenAI-compatible API for interacting with multimodal models.

### Do I need to pay for Docker Model Runner?

No! Docker Model Runner is included free with Docker Desktop (v4.36+). However, Docker Desktop itself has different licensing terms for enterprise use.

### What's the difference between Docker Model Runner and cloud-based AI APIs?

| Feature | Docker Model Runner | Cloud APIs |
|---------|-------------------|------------|
| Privacy | ✓ All local | ✗ Data sent to cloud |
| Cost | ✓ Free (after download) | ✗ Pay per request |
| Speed | ✓ Fast (no network) | ~ Network dependent |
| Setup | ~ Initial download | ✓ Instant |
| Scalability | ~ Limited by hardware | ✓ Unlimited |

### Is Docker Model Runner production-ready?

Docker Model Runner is great for:
- ✓ Development and testing
- ✓ Personal projects
- ✓ Privacy-sensitive applications
- ✓ Prototyping

For large-scale production, consider:
- Load balancing multiple instances
- Hardware optimization (GPU)
- Monitoring and logging
- High availability setup

## Installation & Setup

### What version of Docker Desktop do I need?

Docker Desktop version 4.36 or later. Check your version with:
```bash
docker --version
```

### How do I update Docker Desktop?

1. Open Docker Desktop
2. Go to Settings → Software Updates
3. Click "Check for updates"
4. Follow the installation prompts

### Can I use Docker Model Runner without Docker Desktop?

No, Docker Model Runner is currently only available as part of Docker Desktop. It's not available with Docker Engine alone.

### How much disk space do I need?

- Docker Desktop: ~500MB-1GB
- Each AI model: 1-10GB
- Recommended: 20GB+ free space

### Do I need a GPU?

No! Models work on CPU. However, GPU (if available) provides:
- Much faster inference (~10-100x)
- Ability to run larger models
- Better performance for real-time applications

## Using Models

### How do I list available models?

```bash
docker model list
```

### How do I download a model?

Models are automatically downloaded when you first use them:
```bash
docker model run gemma3 "Hello"
```

Or explicitly pull:
```bash
docker model pull gemma3
```

### Which model should I choose?

- **Moondream2**: Fast, lightweight, good for quick tasks
- **Gemma3**: Balanced performance and accuracy
- **Smolvlm**: Small, efficient vision-language model
- **LLaVA**: High accuracy, requires more resources

Start with `gemma3` for a good balance.

### Can I use my own models?

Currently, Docker Model Runner supports models from its official repository. Custom model support may be added in future versions.

### How do I remove a model I don't need?

```bash
docker model rm model-name
```

### Where are models stored?

Models are stored in:
- macOS: `~/.docker/models/`
- Windows: `%USERPROFILE%\.docker\models\`
- Linux: `~/.docker/models/`

## Performance

### Why is the first request so slow?

The first request loads the model into memory (~10-30 seconds). Subsequent requests are much faster (~0.1-2 seconds).

### How can I make it faster?

1. **Keep the model running** - Don't stop/restart frequently
2. **Use smaller models** - Moondream2 is faster than LLaVA
3. **Optimize images** - Resize to 512x512 or 1024x1024
4. **Use GPU** - If available
5. **Increase resources** - Docker Desktop → Settings → Resources

### How many requests can it handle per second?

Depends on:
- Model size (smaller = faster)
- Hardware (CPU vs GPU)
- Input complexity
- System resources

Typical: 0.5-10 requests/second on CPU, 10-100+ on GPU.

### Can I run multiple models at once?

Yes! Start different models on different ports:
```bash
docker model serve gemma3 -p 8080
docker model serve moondream2 -p 8081
```

## API Usage

### Is the API compatible with OpenAI's API?

Yes! The API is OpenAI-compatible, so most OpenAI client libraries work:
- Python: `openai` package
- JavaScript: `openai` npm package
- Any OpenAI-compatible tool

Just point the `base_url` to `http://localhost:8080/v1`.

### Do I need an API key?

No! Since it's running locally, no authentication is required. Use any string for the API key parameter:
```python
api_key="not-needed"
```

### Can I use it with LangChain?

Yes! Example:
```python
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(
    base_url="http://localhost:8080/v1",
    api_key="not-needed",
    model="gemma3"
)
```

### Can I use it with LlamaIndex?

Yes! Example:
```python
from llama_index.llms.openai_like import OpenAILike

llm = OpenAILike(
    api_base="http://localhost:8080/v1",
    api_key="not-needed",
    model="gemma3"
)
```

### How do I handle errors?

Wrap API calls in try-catch blocks:
```python
try:
    response = client.chat.completions.create(...)
except Exception as e:
    print(f"Error: {e}")
    # Check if server is running
```

## Image Processing

### What image formats are supported?

Common formats work: JPEG, PNG, GIF, BMP, WebP

### What's the optimal image size?

- Minimum: 224x224 pixels
- Optimal: 512x512 to 1024x1024
- Maximum: Model-dependent (usually 2048x2048)

Larger images take more time and memory.

### Can I analyze videos?

Not directly. You need to:
1. Extract video frames
2. Analyze each frame individually
3. Combine results

### Can I analyze PDFs or documents?

Some models can analyze document images. Convert PDF pages to images first:
```bash
convert document.pdf page.jpg  # ImageMagick
```

### Does it support OCR?

Some models have OCR-like capabilities - they can read text in images. Try:
```bash
docker model run gemma3 "What text is in this image? document.jpg"
```

## Troubleshooting

### "Command not found: docker model"

**Solutions:**
1. Update Docker Desktop to v4.36+
2. Restart Docker Desktop
3. Restart your terminal

### "Cannot connect to Docker daemon"

**Solution:** Make sure Docker Desktop is running.

### "Out of memory" errors

**Solutions:**
1. Try a smaller model (moondream2)
2. Increase Docker memory: Settings → Resources → Memory
3. Close other applications
4. Restart Docker Desktop

### Model downloads fail

**Solutions:**
1. Check internet connection
2. Check firewall settings
3. Try again (downloads can be interrupted)
4. Check disk space

### "Port already in use"

**Solution:** Another service is using the port. Try a different port:
```bash
docker model serve gemma3 -p 8081
```

Or find and stop the conflicting service:
```bash
# macOS/Linux
lsof -i :8080

# Windows
netstat -an | findstr 8080
```

### Results are not accurate

**Tips:**
1. **Be specific** - Clear, detailed questions get better answers
2. **Use good images** - Clear, well-lit, high-resolution
3. **Try different models** - Some are better for specific tasks
4. **Adjust prompts** - Experiment with wording
5. **Use context** - Provide relevant background information

### Slow on macOS with Apple Silicon

Docker Desktop on Apple Silicon (M1/M2/M3) runs models well. If slow:
1. Update to latest Docker Desktop
2. Check Resources allocation
3. Close other applications

## Privacy & Security

### Is my data sent anywhere?

No! All processing happens locally on your machine. No data leaves your device.

### Do I need internet after downloading models?

No! After models are downloaded, everything works offline.

### Are the models safe to use?

Models from Docker's official repository are vetted. However:
- They're AI models and can make mistakes
- Don't use for critical decisions without human review
- Be aware of potential biases in AI models

### Can I use this for sensitive data?

Yes! Since everything is local, it's suitable for:
- Medical images
- Financial documents
- Personal photos
- Confidential information

Just ensure your device itself is secure.

## Advanced Topics

### Can I fine-tune models?

Not currently supported directly. Fine-tuning typically requires:
- Original model weights
- Training infrastructure
- Significant compute resources

### Can I deploy this in production?

Yes, but consider:
- Load balancing
- Resource monitoring
- Auto-scaling
- Backup strategies
- Error handling

### How do I monitor performance?

Use Docker Desktop's built-in monitoring:
1. Open Docker Desktop
2. View resource usage (CPU, Memory)
3. Check container logs

For production, consider external monitoring tools.

### Can I run this in a container?

Docker Model Runner itself manages containers. For deploying applications that use it:
- Your app can run in a container
- It connects to Model Runner on the host
- Use host networking or appropriate port mapping

### What's the technology stack?

- **Runtime**: Docker containers
- **Models**: GGUF format (quantized)
- **API**: OpenAI-compatible REST
- **Inference**: llama.cpp or similar backends

## Getting Help

### Where can I get more help?

1. **Documentation**:
   - [Quick Start Guide](QUICKSTART.md)
   - [Main README](README.md)
   - [Architecture Guide](ARCHITECTURE.md)

2. **Examples**:
   - [Code Examples](examples/)

3. **Community**:
   - [Docker Community Forums](https://forums.docker.com/)
   - [Docker Blog](https://www.docker.com/blog/)

4. **Official Resources**:
   - [Docker Model Runner Docs](https://docs.docker.com/desktop/features/model-runner/)
   - [Docker Desktop Docs](https://docs.docker.com/desktop/)

### How do I report bugs?

For Docker Model Runner bugs:
1. Visit [Docker Desktop GitHub Issues](https://github.com/docker/desktop/issues)
2. Check if already reported
3. Create new issue with details

For this learning repository:
- Open an issue on this repository
- Provide clear description
- Include relevant code/commands

### How can I contribute?

See [CONTRIBUTING.md](CONTRIBUTING.md) for:
- Adding examples
- Improving documentation
- Reporting issues
- Suggesting features

---

**Still have questions? Open an issue or check the [official documentation](https://docs.docker.com/desktop/features/model-runner/)!**
