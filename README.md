# Learn Docker Multimodal

A comprehensive guide to getting started with Docker Multimodal AI models using Docker Model Runner.

## What is Docker Multimodal?

Docker Multimodal refers to running multimodal AI models locally using **Docker Model Runner** - a tool integrated with Docker Desktop. Multimodal AI models can process and understand multiple types of data inputs:

- 📝 Text (natural language)
- 🖼️ Images (photos, graphics)
- 🎵 Audio (speech, sound)
- 🎥 Video (motion)

This allows you to build applications that can understand and process complex, multi-sensory inputs - like asking questions about images, analyzing audio with context, or combining text and visual data.

## Why Use Docker for Multimodal AI?

- **🔒 Privacy**: All processing happens locally - your data never leaves your device
- **⚡ Speed**: Local inference is much faster than remote API calls
- **🛠️ Easy to Use**: Simple CLI and OpenAI-compatible API
- **🔄 Flexible**: Works with various quantized models (GGUF format)
- **💻 Hardware Agnostic**: Runs on CPU or GPU

## Prerequisites

1. **Docker Desktop** (version 4.36 or later)
   - Download from: https://www.docker.com/products/docker-desktop
   
2. **System Requirements**:
   - macOS, Windows, or Linux
   - At least 8GB RAM (16GB+ recommended for larger models)
   - Sufficient disk space (models can be 1-10GB+)

## Installation

### Step 1: Install Docker Desktop

Download and install Docker Desktop for your operating system:
- macOS: https://docs.docker.com/desktop/install/mac-install/
- Windows: https://docs.docker.com/desktop/install/windows-install/
- Linux: https://docs.docker.com/desktop/install/linux-install/

### Step 2: Enable Model Runner

Docker Model Runner is included with Docker Desktop (v4.36+). Once installed, you can access it through:
- The Docker Desktop GUI
- The command line using `docker model` commands

## Getting Started

### Quick Start: Running Your First Multimodal Model

1. **List available models**:
```bash
docker model list
```

2. **Run a multimodal model** (e.g., Gemma3):
```bash
docker model run gemma3
```

3. **Ask a question with an image**:
```bash
docker model run gemma3 "What's in this image? /path/to/your/image.jpg"
```

### Popular Multimodal Models

Here are some popular models you can try:

- **Moondream2**: Lightweight vision-language model
- **Gemma3**: Google's multimodal model
- **Smolvlm**: Small, efficient vision-language model
- **LLaVA**: Large Language and Vision Assistant

## Basic Usage Examples

### Example 1: Image Analysis

```bash
# Download an image
curl -o cat.jpg https://example.com/cat.jpg

# Ask the model to describe it
docker model run moondream2 "Describe this image in detail. cat.jpg"
```

### Example 2: Visual Question Answering

```bash
docker model run gemma3 "How many people are in this photo? family_photo.jpg"
```

### Example 3: Using the Interactive Mode

```bash
# Start interactive session
docker model run -it gemma3

# Then type your prompts
> What can you help me with?
> Analyze this image: /path/to/image.png
```

## Using the API

Docker Model Runner provides an OpenAI-compatible API, making it easy to integrate with existing tools and frameworks.

### Starting the API Server

```bash
docker model serve gemma3 -p 8080
```

### Making API Requests

**Using curl:**

```bash
curl -X POST http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gemma3",
    "messages": [
      {
        "role": "user",
        "content": [
          {"type": "text", "text": "What is in this image?"},
          {"type": "image_url", "image_url": {"url": "file:///path/to/image.jpg"}}
        ]
      }
    ]
  }'
```

**Using Python:**

```python
from openai import OpenAI

# Point to local Docker Model Runner
client = OpenAI(
    base_url="http://localhost:8080/v1",
    api_key="not-needed"  # API key not required for local usage
)

# Send a request with image
response = client.chat.completions.create(
    model="gemma3",
    messages=[
        {
            "role": "user",
            "content": [
                {"type": "text", "text": "Describe this image"},
                {"type": "image_url", "image_url": {"url": "file:///path/to/image.jpg"}}
            ]
        }
    ]
)

print(response.choices[0].message.content)
```

**Using JavaScript/Node.js:**

```javascript
import OpenAI from 'openai';

const client = new OpenAI({
    baseURL: 'http://localhost:8080/v1',
    apiKey: 'not-needed'
});

const response = await client.chat.completions.create({
    model: 'gemma3',
    messages: [
        {
            role: 'user',
            content: [
                { type: 'text', text: 'What is in this image?' },
                { type: 'image_url', image_url: { url: 'file:///path/to/image.jpg' } }
            ]
        }
    ]
});

console.log(response.choices[0].message.content);
```

## Advanced Usage

### Managing Models

```bash
# List all models
docker model list

# Pull a specific model
docker model pull moondream2

# Remove a model
docker model rm moondream2

# Show model details
docker model inspect gemma3
```

### Using with LangChain

```python
from langchain_openai import ChatOpenAI

# Create LangChain client pointing to local model
llm = ChatOpenAI(
    base_url="http://localhost:8080/v1",
    api_key="not-needed",
    model="gemma3"
)

# Use it in your LangChain application
response = llm.invoke("Analyze this image...")
print(response.content)
```

### Using with LlamaIndex

```python
from llama_index.llms.openai_like import OpenAILike

llm = OpenAILike(
    api_base="http://localhost:8080/v1",
    api_key="not-needed",
    model="gemma3"
)

response = llm.complete("What's in this image?")
print(response)
```

## How Multimodal Models Work

Multimodal models process different types of input through a sophisticated pipeline:

1. **Input Modules**: Specialized encoders for each data type
   - Text: Tokenizers and text transformers
   - Images: Convolutional Neural Networks (CNNs) or Vision Transformers
   - Audio: Acoustic feature extractors

2. **Fusion Module**: Combines encoded features using:
   - Cross-modal attention mechanisms
   - Early fusion (combine raw inputs)
   - Late fusion (combine processed features)

3. **Output Module**: Generates responses based on fused understanding
   - Text generation
   - Classification
   - Reasoning and analysis

## Common Use Cases

### 1. Visual Question Answering
Ask natural language questions about images:
```bash
docker model run gemma3 "What color is the car in this image? photo.jpg"
```

### 2. Image Captioning
Generate descriptions of images:
```bash
docker model run moondream2 "Generate a detailed caption for this image. landscape.jpg"
```

### 3. Document Analysis
Analyze documents with both text and images:
```bash
docker model run gemma3 "Summarize the content of this document. report.pdf"
```

### 4. Accessibility Tools
Help describe images for visually impaired users:
```bash
docker model run gemma3 "Describe this image in detail for a blind person. scene.jpg"
```

### 5. Content Moderation
Analyze images and text for inappropriate content:
```bash
docker model run gemma3 "Does this image contain any inappropriate content? image.jpg"
```

## Best Practices

1. **Model Selection**
   - Start with smaller models (Moondream2, Smolvlm) for faster inference
   - Use larger models (LLaVA) when you need higher accuracy

2. **Image Preparation**
   - Use common formats: JPEG, PNG
   - Reasonable resolution (most models work well with 512x512 to 1024x1024)
   - Avoid extremely large images to save processing time

3. **Prompt Engineering**
   - Be specific in your questions
   - Provide context when needed
   - Use clear, direct language

4. **Resource Management**
   - Monitor memory usage (Docker Desktop → Resources)
   - Stop models when not in use: `docker model stop`
   - Clean up unused models to free disk space

## Troubleshooting

### Model won't start
```bash
# Check Docker Desktop is running
docker info

# Check available disk space
df -h

# Try pulling the model again
docker model pull <model-name>
```

### Out of memory errors
- Close other applications
- Use a smaller model
- Increase Docker Desktop memory allocation (Settings → Resources)

### Slow inference
- First inference is always slower (model loading)
- Consider using GPU acceleration if available
- Try quantized models (GGUF format)

### API connection issues
```bash
# Verify the server is running
docker model list

# Check the port isn't in use
lsof -i :8080  # macOS/Linux
netstat -an | grep 8080  # Windows
```

## Additional Resources

- [Docker Model Runner Official Docs](https://docs.docker.com/desktop/features/model-runner/)
- [Docker Blog: Multimodal AI Models](https://www.docker.com/blog/how-to-use-multimodel-ai-with-model-runner/)
- [Hugging Face Model Hub](https://huggingface.co/models?pipeline_tag=image-text-to-text)
- [OpenAI API Reference](https://platform.openai.com/docs/api-reference)

## Contributing

This is a learning repository! Feel free to:
- Add more examples
- Share your use cases
- Improve documentation
- Report issues or suggestions

## License

This project is licensed under the terms specified in the LICENSE file.

---

**Happy Learning! 🚀**

Start experimenting with multimodal AI locally and discover the power of combining text, images, and more in your applications!