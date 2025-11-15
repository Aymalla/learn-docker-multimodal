# Docker Multimodal Examples

This directory contains practical examples demonstrating how to use Docker Model Runner with multimodal AI models.

## Prerequisites

Before running these examples, ensure you have:

1. **Docker Desktop** (v4.36 or later) installed and running
2. **A model server running**:
   ```bash
   docker model serve gemma3 -p 8080
   ```

## Available Examples

### 1. Simple Image Analysis (Python)

**File**: `simple_image_analysis.py`

Basic example showing how to analyze a single image with a custom question.

**Setup**:
```bash
pip install openai
```

**Usage**:
```bash
# Basic usage with default question
python simple_image_analysis.py /path/to/image.jpg

# With custom question
python simple_image_analysis.py photo.jpg "What objects are visible?"
```

### 2. Simple Image Analysis (JavaScript)

**File**: `simple_image_analysis.js`

JavaScript/Node.js version of the image analysis example.

**Setup**:
```bash
npm install openai
```

**Usage**:
```bash
# Basic usage with default question
node simple_image_analysis.js /path/to/image.jpg

# With custom question
node simple_image_analysis.js photo.jpg "What colors are prominent?"
```

### 3. Batch Image Analysis (Python)

**File**: `batch_image_analysis.py`

Analyze multiple images in a directory automatically.

**Setup**:
```bash
pip install openai
```

**Usage**:
```bash
python batch_image_analysis.py /path/to/images/folder
```

This will analyze all image files (jpg, png, gif, bmp, webp) in the specified directory.

### 4. CLI Tool Example

**File**: `cli_tool.sh`

Simple bash script demonstrating CLI-based interaction with Docker Model Runner.

**Usage**:
```bash
chmod +x cli_tool.sh

# Interactive mode
./cli_tool.sh

# Analyze an image directly
docker model run gemma3 "Describe this image: /path/to/image.jpg"
```

## Common Issues

### 1. Connection Refused

**Error**: `Connection refused to localhost:8080`

**Solution**: Make sure the model server is running:
```bash
docker model serve gemma3 -p 8080
```

### 2. Model Not Found

**Error**: `Model not found`

**Solution**: Pull the model first:
```bash
docker model pull gemma3
```

### 3. Out of Memory

**Error**: Memory-related errors

**Solutions**:
- Try a smaller model (e.g., `moondream2`)
- Increase Docker Desktop memory allocation
- Close other applications

### 4. File Not Found

**Error**: Image file cannot be found

**Solution**: 
- Use absolute paths: `/full/path/to/image.jpg`
- Or resolve relative paths properly in your code

## Tips for Best Results

1. **Image Quality**: Use clear, well-lit images (512x512 to 1024x1024 pixels work well)
2. **Specific Questions**: Ask precise questions for better answers
3. **Model Selection**: 
   - `moondream2` - Fast, lightweight
   - `gemma3` - Balanced performance
   - `llava` - High accuracy, slower
4. **Response Length**: Adjust `max_tokens` based on your needs

## Next Steps

After trying these examples, you can:

1. Integrate with frameworks like **LangChain** or **LlamaIndex**
2. Build a web application using these APIs
3. Create custom workflows combining multiple models
4. Experiment with different prompting strategies

## Resources

- [Main README](../README.md) - Full documentation
- [Docker Model Runner Docs](https://docs.docker.com/desktop/features/model-runner/)
- [OpenAI API Reference](https://platform.openai.com/docs/api-reference)

## Contributing

Have a useful example? Feel free to add it! Make sure to:
- Include clear comments
- Add usage instructions
- Test with Docker Model Runner
- Update this README
