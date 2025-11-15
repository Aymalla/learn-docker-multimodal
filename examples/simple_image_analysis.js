#!/usr/bin/env node
/**
 * Simple Image Analysis Example using Docker Model Runner
 * 
 * This script demonstrates how to use Docker Model Runner to analyze images
 * using multimodal AI models through the OpenAI-compatible API.
 * 
 * Prerequisites:
 * - Docker Desktop installed (v4.36+)
 * - Node.js 16+
 * - OpenAI library: npm install openai
 * 
 * Usage:
 * 1. Start the model server: docker model serve gemma3 -p 8080
 * 2. Run this script: node simple_image_analysis.js /path/to/image.jpg
 */

import OpenAI from 'openai';
import { readFileSync } from 'fs';
import { resolve } from 'path';

/**
 * Analyze an image using Docker Model Runner's multimodal AI
 * @param {string} imagePath - Path to the image file
 * @param {string} question - Question to ask about the image
 * @returns {Promise<string>} The AI model's response
 */
async function analyzeImage(imagePath, question = "Describe this image in detail") {
    // Create client pointing to local Docker Model Runner
    const client = new OpenAI({
        baseURL: 'http://localhost:8080/v1',
        apiKey: 'not-needed'  // API key not required for local usage
    });
    
    console.log(`Analyzing image: ${imagePath}`);
    console.log(`Question: ${question}\n`);
    
    try {
        // Send request with image and text
        const response = await client.chat.completions.create({
            model: 'gemma3',
            messages: [
                {
                    role: 'user',
                    content: [
                        { type: 'text', text: question },
                        {
                            type: 'image_url',
                            image_url: { url: `file://${resolve(imagePath)}` }
                        }
                    ]
                }
            ],
            max_tokens: 500
        });
        
        return response.choices[0].message.content;
        
    } catch (error) {
        return `Error: ${error.message}\n\nMake sure Docker Model Runner is running:\n  docker model serve gemma3 -p 8080`;
    }
}

/**
 * Main function to run the image analysis
 */
async function main() {
    const args = process.argv.slice(2);
    
    if (args.length < 1) {
        console.log('Usage: node simple_image_analysis.js <image_path> [question]');
        console.log('\nExample:');
        console.log('  node simple_image_analysis.js photo.jpg');
        console.log('  node simple_image_analysis.js photo.jpg "What colors are in this image?"');
        process.exit(1);
    }
    
    const imagePath = args[0];
    const question = args[1] || "Describe this image in detail";
    
    const result = await analyzeImage(imagePath, question);
    
    console.log('AI Response:');
    console.log('-'.repeat(50));
    console.log(result);
    console.log('-'.repeat(50));
}

// Run the main function
main().catch(console.error);
