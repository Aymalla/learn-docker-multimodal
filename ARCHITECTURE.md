# Docker Multimodal Architecture

Understanding how Docker Model Runner works with multimodal AI models.

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Your Application                        │
│  (Python, JavaScript, CLI, or any OpenAI-compatible client) │
└────────────────────┬────────────────────────────────────────┘
                     │
                     │ HTTP/API Calls
                     │ (OpenAI-compatible)
                     ▼
┌─────────────────────────────────────────────────────────────┐
│              Docker Model Runner (API Server)                │
│                  Port: 8080 (configurable)                  │
└────────────────────┬────────────────────────────────────────┘
                     │
                     │ Model Management
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                  Multimodal AI Model                        │
│                    (e.g., Gemma3)                           │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │Text Encoder  │  │Image Encoder │  │Audio Encoder │     │
│  │(Transformer) │  │(Vision CNN)  │  │(Acoustic)    │     │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘     │
│         │                  │                  │             │
│         └──────────────────┼──────────────────┘             │
│                            │                                │
│                    ┌───────▼───────┐                        │
│                    │ Fusion Layer  │                        │
│                    │(Cross-Modal   │                        │
│                    │ Attention)    │                        │
│                    └───────┬───────┘                        │
│                            │                                │
│                    ┌───────▼───────┐                        │
│                    │Output Generator│                       │
│                    │(Text Response) │                       │
│                    └───────────────┘                        │
└─────────────────────────────────────────────────────────────┘
                     │
                     │ Results
                     ▼
              Back to Application
```

## Component Breakdown

### 1. Application Layer

Your application interacts with Docker Model Runner through:
- **CLI**: Direct command-line interface
- **API**: OpenAI-compatible REST API
- **SDKs**: Python, JavaScript, or other language clients

**Example Interactions:**
```bash
# CLI
docker model run gemma3 "Describe image.jpg"

# API (Python)
client.chat.completions.create(model="gemma3", messages=[...])
```

### 2. Docker Model Runner

The middleware layer that:
- Manages model lifecycle (download, load, unload)
- Provides API endpoints
- Handles request/response formatting
- Manages model resources (CPU/GPU/memory)

**Key Features:**
- OpenAI-compatible API
- Model caching
- Automatic resource management
- Multi-model support

### 3. Multimodal AI Model

The core AI model that processes multiple input types:

#### Input Encoders
Each modality has a specialized encoder:

- **Text Encoder**: 
  - Tokenizes text input
  - Uses transformer architecture
  - Creates text embeddings

- **Image Encoder**: 
  - Processes image pixels
  - Uses CNN or Vision Transformer
  - Extracts visual features

- **Audio Encoder** (if supported):
  - Analyzes audio signals
  - Extracts acoustic features
  - Creates audio embeddings

#### Fusion Layer
Combines information from different modalities:
- **Cross-Modal Attention**: Links text, image, and audio features
- **Feature Alignment**: Ensures different modalities work together
- **Context Integration**: Understands relationships between inputs

#### Output Generator
Produces the final response:
- Generates natural language text
- Can describe, analyze, or reason about inputs
- Produces coherent, contextual answers

## Data Flow Example

### Analyzing an Image with Text Question

```
Input: "What colors are in this image?" + image.jpg
                     │
                     ▼
┌────────────────────────────────────────┐
│ Step 1: Input Processing               │
├────────────────────────────────────────┤
│ • Text: Tokenized and embedded         │
│ • Image: Resized and preprocessed      │
└────────────────┬───────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────┐
│ Step 2: Encoding                       │
├────────────────────────────────────────┤
│ • Text → 768-dim embeddings            │
│ • Image → Visual feature map           │
└────────────────┬───────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────┐
│ Step 3: Fusion                         │
├────────────────────────────────────────┤
│ • Cross-attention between text & image │
│ • Creates unified representation       │
└────────────────┬───────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────┐
│ Step 4: Generation                     │
├────────────────────────────────────────┤
│ • Autoregressive text generation       │
│ • Produces answer token by token       │
└────────────────┬───────────────────────┘
                 │
                 ▼
Output: "The image contains predominantly blue and 
         green colors, with hints of yellow..."
```

## Model Storage

Models are stored locally:

```
~/.docker/models/
├── gemma3/
│   ├── model.gguf      # Model weights (quantized)
│   ├── config.json     # Model configuration
│   └── tokenizer.json  # Tokenizer data
├── moondream2/
│   └── ...
└── llava/
    └── ...
```

**Storage Details:**
- Models are in GGUF format (quantized)
- Typical size: 1-10GB per model
- Cached locally for fast loading
- Shared between containers

## Resource Management

### CPU Mode (Default)
```
┌─────────────────────┐
│   Docker Desktop    │
│                     │
│  ┌───────────────┐  │
│  │  Model Runner │  │
│  │  (CPU Thread) │  │
│  └───────────────┘  │
│         │           │
│         ▼           │
│    Host CPU Cores   │
└─────────────────────┘
```

### GPU Mode (If Available)
```
┌─────────────────────┐
│   Docker Desktop    │
│                     │
│  ┌───────────────┐  │
│  │  Model Runner │  │
│  │   (GPU Mode)  │  │
│  └───────┬───────┘  │
│          │          │
│          ▼          │
│    Host GPU (CUDA)  │
└─────────────────────┘
```

## API Request Flow

```
Client Request
     │
     │ POST /v1/chat/completions
     ▼
┌─────────────────────────┐
│   API Gateway           │
│   (Authentication,      │
│    Rate Limiting)       │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│  Request Parser         │
│  (Validate & Format)    │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│  Model Interface        │
│  (Load Model if needed) │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│  Model Inference        │
│  (Generate Response)    │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│  Response Formatter     │
│  (OpenAI-compatible)    │
└──────────┬──────────────┘
           │
           ▼
     JSON Response
```

## Scalability Considerations

### Single Model Server
- Best for: Development, testing, personal use
- Resources: 1 model loaded at a time
- Throughput: Sequential requests

### Multiple Model Servers
- Best for: Production, high availability
- Resources: Multiple models, load balanced
- Throughput: Parallel requests

```
Load Balancer
     │
     ├─────────┬─────────┬─────────┐
     ▼         ▼         ▼         ▼
 Model A   Model B   Model C   Model D
 (Port     (Port     (Port     (Port
  8080)     8081)     8082)     8083)
```

## Security Architecture

```
┌──────────────────────────────────┐
│      Local Environment Only      │
│                                  │
│  ┌────────────────────────────┐  │
│  │   Your Application         │  │
│  └────────┬───────────────────┘  │
│           │                      │
│           ▼                      │
│  ┌────────────────────────────┐  │
│  │   Docker Model Runner      │  │
│  │   (localhost:8080)         │  │
│  └────────┬───────────────────┘  │
│           │                      │
│           ▼                      │
│  ┌────────────────────────────┐  │
│  │   Local AI Model           │  │
│  │   (No external calls)      │  │
│  └────────────────────────────┘  │
│                                  │
└──────────────────────────────────┘
     ▲
     │
     └── No data leaves your machine
```

**Security Features:**
- All processing is local
- No external API calls
- Data privacy guaranteed
- No internet required (after model download)

## Performance Optimization

### Model Loading
```
First Request:      Subsequent Requests:
     │                      │
     ▼                      ▼
Load Model (slow)      Use Cached Model (fast)
  ~10-30 sec              ~0.1-2 sec
     │                      │
     ▼                      ▼
Generate Response      Generate Response
```

### Tips for Better Performance
1. **Keep model loaded**: Don't stop/restart frequently
2. **Use smaller models**: For faster responses
3. **Optimize images**: Resize to reasonable dimensions
4. **Batch requests**: Process multiple items together
5. **Use GPU**: If available (much faster)

## Comparison: Local vs Cloud

```
┌─────────────────────────┬─────────────────────────┐
│   Docker Model Runner   │      Cloud API          │
│       (Local)           │                         │
├─────────────────────────┼─────────────────────────┤
│ ✓ Private (local)       │ ✗ Data sent to cloud    │
│ ✓ Fast (after loading)  │ ~ Network latency       │
│ ✓ Free (after download) │ ✗ Pay per request       │
│ ~ Requires storage      │ ✓ No local storage      │
│ ~ Initial setup needed  │ ✓ Ready immediately     │
│ ~ Limited by hardware   │ ✓ Unlimited scale       │
└─────────────────────────┴─────────────────────────┘
```

## Further Reading

- [Main README](README.md) - Getting started guide
- [Quick Start](QUICKSTART.md) - 5-minute setup
- [Examples](examples/README.md) - Code examples
- [Docker Model Runner Docs](https://docs.docker.com/desktop/features/model-runner/)

---

**Understanding the architecture helps you use Docker Multimodal more effectively!**
