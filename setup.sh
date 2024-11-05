#!/bin/bash

# Create a Swift package
mkdir BlueskyModelGenerator
cd BlueskyModelGenerator

# Initialize Swift package
swift package init --type executable

# Replace the main.swift content
cat > Sources/BlueskyModelGenerator/main.swift << 'EOL'
// main.swift
import Foundation

// MARK: - File Processing

struct LexiconProcessor {
    let inputPath: String
    let outputPath: String
    let generator: SwiftModelGenerator
    
    init(inputPath: String, outputPath: String) {
        self.inputPath = inputPath
        self.outputPath = outputPath
        self.generator = SwiftModelGenerator(outputDirectory: outputPath)
    }
    
    func process() throws {
        // Create output directory if it doesn\'t exist
        try FileManager.default.createDirectory(
            atPath: outputPath,
            withIntermediateDirectories: true
        )
        
        // Process all lexicon files
        let lexicons = try collectLexiconFiles(from: inputPath)
        let combinedLexicon = try combineLexicons(from: lexicons)
        try generator.generate(from: combinedLexicon)
    }
    
    private func collectLexiconFiles(from path: String) throws -> [URL] {
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(
            at: URL(fileURLWithPath: path),
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles]
        )
        
        var lexiconFiles: [URL] = []
        
        while let fileURL = enumerator?.nextObject() as? URL {
            let fileAttributes = try fileURL.resourceValues(forKeys: [.isRegularFileKey])
            if fileAttributes.isRegularFile == true && fileURL.pathExtension == "json" {
                lexiconFiles.append(fileURL)
            }
        }
        
        return lexiconFiles
    }
    
    private func combineLexicons(from files: [URL]) throws -> String {
        var lexicons: [[String: Any]] = []
        
        for fileURL in files {
            let data = try Data(contentsOf: fileURL)
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                lexicons.append(json)
            }
        }
        
        let combinedData = try JSONSerialization.data(withJSONObject: lexicons)
        return String(data: combinedData, encoding: .utf8) ?? ""
    }
}

// MARK: - Command Line Interface

func printUsage() {
    print("""
    Usage: generate-models <input-directory> <output-directory>
    
    Arguments:
      input-directory   Directory containing lexicon JSON files
      output-directory  Directory where Swift files will be generated
    
    Example:
      generate-models ./lexicons ./Models
    """)
}

// MARK: - Main

func main() {
    let arguments = Array(CommandLine.arguments.dropFirst())
    
    guard arguments.count == 2 else {
        printUsage()
        exit(1)
    }
    
    let inputPath = arguments[0]
    let outputPath = arguments[1]
    
    do {
        let processor = LexiconProcessor(inputPath: inputPath, outputPath: outputPath)
        try processor.process()
        print("✅ Successfully generated Bluesky models!")
    } catch {
        print("❌ Error: \(error)")
        exit(1)
    }
}

main()
EOL

# Build and install
swift build -c release
cp .build/release/BlueskyModelGenerator /usr/local/bin/generate-models

# Make it executable
chmod +x /usr/local/bin/generate-models

# Usage example
# generate-models ./lexicons ./GeneratedModels
