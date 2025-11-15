#!/usr/bin/env python3
"""
Batch Image Analysis Example using Docker Model Runner

This script demonstrates how to analyze multiple images in batch
using Docker Model Runner's multimodal AI capabilities.

Prerequisites:
- Docker Desktop installed (v4.36+)
- Python 3.7+
- OpenAI Python library: pip install openai

Usage:
1. Start the model server: docker model serve gemma3 -p 8080
2. Run this script: python batch_image_analysis.py /path/to/images/folder
"""

import sys
import os
from pathlib import Path
from openai import OpenAI


def analyze_images_in_directory(directory_path: str):
    """
    Analyze all images in a directory using Docker Model Runner.
    
    Args:
        directory_path: Path to directory containing images
    """
    # Create client pointing to local Docker Model Runner
    client = OpenAI(
        base_url="http://localhost:8080/v1",
        api_key="not-needed"
    )
    
    # Supported image extensions
    image_extensions = {'.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'}
    
    # Find all image files
    directory = Path(directory_path)
    image_files = [
        f for f in directory.iterdir()
        if f.is_file() and f.suffix.lower() in image_extensions
    ]
    
    if not image_files:
        print(f"No image files found in {directory_path}")
        return
    
    print(f"Found {len(image_files)} image(s) to analyze\n")
    print("=" * 70)
    
    # Analyze each image
    for idx, image_path in enumerate(image_files, 1):
        print(f"\n[{idx}/{len(image_files)}] Analyzing: {image_path.name}")
        print("-" * 70)
        
        try:
            response = client.chat.completions.create(
                model="gemma3",
                messages=[
                    {
                        "role": "user",
                        "content": [
                            {
                                "type": "text",
                                "text": "Describe this image in 2-3 sentences."
                            },
                            {
                                "type": "image_url",
                                "image_url": {"url": f"file://{image_path.absolute()}"}
                            }
                        ]
                    }
                ],
                max_tokens=200
            )
            
            result = response.choices[0].message.content
            print(f"Description: {result}")
            
        except Exception as e:
            print(f"Error analyzing {image_path.name}: {str(e)}")
        
        print("-" * 70)
    
    print("\n" + "=" * 70)
    print("Batch analysis complete!")


def main():
    """Main function to run batch image analysis."""
    if len(sys.argv) < 2:
        print("Usage: python batch_image_analysis.py <directory_path>")
        print("\nExample:")
        print("  python batch_image_analysis.py ./my_images")
        print("\nThis will analyze all image files in the specified directory.")
        sys.exit(1)
    
    directory_path = sys.argv[1]
    
    if not os.path.isdir(directory_path):
        print(f"Error: '{directory_path}' is not a valid directory")
        sys.exit(1)
    
    print("Docker Model Runner - Batch Image Analysis")
    print("=" * 70)
    print(f"Directory: {directory_path}\n")
    
    try:
        analyze_images_in_directory(directory_path)
    except Exception as e:
        print(f"\nError: {str(e)}")
        print("\nMake sure Docker Model Runner is running:")
        print("  docker model serve gemma3 -p 8080")
        sys.exit(1)


if __name__ == "__main__":
    main()
