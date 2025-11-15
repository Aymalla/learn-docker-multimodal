#!/usr/bin/env python3
"""
Simple Image Analysis Example using Docker Model Runner

This script demonstrates how to use Docker Model Runner to analyze images
using multimodal AI models through the OpenAI-compatible API.

Prerequisites:
- Docker Desktop installed (v4.36+)
- Python 3.7+
- OpenAI Python library: pip install openai

Usage:
1. Start the model server: docker model serve gemma3 -p 8080
2. Run this script: python simple_image_analysis.py /path/to/image.jpg
"""

import sys
from openai import OpenAI


def analyze_image(image_path: str, question: str = "Describe this image in detail"):
    """
    Analyze an image using Docker Model Runner's multimodal AI.
    
    Args:
        image_path: Path to the image file
        question: Question to ask about the image
        
    Returns:
        The AI model's response
    """
    # Create client pointing to local Docker Model Runner
    client = OpenAI(
        base_url="http://localhost:8080/v1",
        api_key="not-needed"  # API key not required for local usage
    )
    
    print(f"Analyzing image: {image_path}")
    print(f"Question: {question}\n")
    
    try:
        # Send request with image and text
        response = client.chat.completions.create(
            model="gemma3",
            messages=[
                {
                    "role": "user",
                    "content": [
                        {"type": "text", "text": question},
                        {
                            "type": "image_url",
                            "image_url": {"url": f"file://{image_path}"}
                        }
                    ]
                }
            ],
            max_tokens=500
        )
        
        return response.choices[0].message.content
        
    except Exception as e:
        return f"Error: {str(e)}\n\nMake sure Docker Model Runner is running:\n  docker model serve gemma3 -p 8080"


def main():
    """Main function to run the image analysis."""
    if len(sys.argv) < 2:
        print("Usage: python simple_image_analysis.py <image_path> [question]")
        print("\nExample:")
        print("  python simple_image_analysis.py photo.jpg")
        print('  python simple_image_analysis.py photo.jpg "What colors are in this image?"')
        sys.exit(1)
    
    image_path = sys.argv[1]
    question = sys.argv[2] if len(sys.argv) > 2 else "Describe this image in detail"
    
    result = analyze_image(image_path, question)
    print("AI Response:")
    print("-" * 50)
    print(result)
    print("-" * 50)


if __name__ == "__main__":
    main()
