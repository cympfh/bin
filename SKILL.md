---
name: mybin
description: |
  ~/bin/ is a personal utility script collection in PATH containing 65+ executable scripts (Python, Bash, Ruby).
  These are production-ready command-line tools covering AI/LLM integration, system utilities, media processing,
  web/data manipulation, and development tools. All scripts support standard Unix patterns (pipes, stdin/stdout),
  have --help flags, and can be freely used in any workflow. This file defines when and how Claude Code should
  proactively use these tools to enhance productivity.
---

## AI/LLM Tools

### codegen

**When to use:** When you need to generate code from natural language descriptions or complete code with placeholders.

**Description:** LLM-powered code generation and placeholder completion tool using litellm (supports xAI, Gemini, OpenAI, Anthropic).

**Usage:**
- `codegen chat "write a function to calculate fibonacci"` - Generate code from natural language
- `echo 'def fib(n): {{ implement }}' | codegen complete` - Complete `{{ }}` placeholders
- `codegen chat -p gemini -m gemini-2.0-flash "..."` - Use specific provider/model

**Subcommands:**
- `chat`: Generate code from natural language description
- `complete`: Fill in `{{ }}` placeholders in code

### translate

**When to use:** When you need to translate text between languages, especially when working with multilingual content.

**Description:** Multi-language translation tool with automatic language detection. For Chinese text, provides pinyin annotations.

**Usage:**
- `echo "Hello world" | translate` - Auto-detect and translate
- `translate -t ja "How are you?"` - Translate to Japanese
- `translate -f en -t zh "Hello"` - Translate from English to Chinese (with pinyin)

### zhcomp

**When to use:** When working with Chinese text that needs correction, pinyin conversion, or translation to Japanese.

**Description:** Chinese text processing tool for corrections, pinyin conversion, and Japanese translation.

**Usage:**
- `echo "中国語テキスト" | zhcomp` - Correct Chinese text
- `zhcomp --pinyin "你好"` - Add pinyin annotations
- `zhcomp --ja "中文"` - Translate to Japanese

### ocr

**When to use:** When you need to extract text from images.

**Description:** OCR (Optical Character Recognition) tool to extract text from image files.

**Usage:**
- `ocr image.png` - Extract text from image
- `ocr screenshot.jpg` - Process screenshot

## System Utilities

### withcache

**When to use:** When you need to cache the results of expensive commands to avoid repeated execution.

**Description:** Command result caching with TTL support. Caches command output and reuses it within the TTL period.

**Usage:**
- `withcache --ttl 3600 "slow-command"` - Cache for 1 hour
- `withcache "curl https://api.example.com"` - Cache API response

### weasel

**When to use:** When you need to watch files for changes and execute commands automatically, or run commands at specific times.

**Description:** File watcher and time-based command executor using watchgod.

**Usage:**
- `weasel --watch src/ --exec "make test"` - Watch directory and run tests
- `weasel --at "14:00" --exec "backup.sh"` - Execute at specific time

### clip

**When to use:** When you need to interact with the system clipboard across different platforms.

**Description:** Cross-platform clipboard operations (Linux/WSL/macOS). Automatically detects and uses xsel, pbcopy, or PowerShell.

**Usage:**
- `echo "text" | clip` - Copy to clipboard
- `clip` - Paste from clipboard

### progressbar

**When to use:** When you need to display a progress bar for long-running operations.

**Description:** Display progress bars in terminal.

**Usage:**
- `progressbar --total 100 --current 50` - Show progress bar
- `for i in {1..100}; do progressbar --total 100 --current $i; sleep 0.1; done` - Animated progress

### notify

**When to use:** When you need to send system notifications or alerts.

**Description:** System notification tool for desktop alerts.

**Usage:**
- `notify "Task completed"` - Send notification
- `long-task && notify "Done!"` - Notify after command completes

## Media & Graphics

### imagediff

**When to use:** When you need to compare two images and detect differences.

**Description:** Image comparison tool to find differences between images.

**Usage:**
- `imagediff image1.png image2.png` - Compare images
- `imagediff --output diff.png before.png after.png` - Save difference image

### imagehash

**When to use:** When you need to generate perceptual hashes for images (for deduplication or similarity detection).

**Description:** Generate perceptual hashes for images.

**Usage:**
- `imagehash image.png` - Generate hash
- `imagehash *.jpg` - Hash multiple images

### imagick

**When to use:** When you need to perform ImageMagick operations with AI assistance or QR code generation.

**Description:** ImageMagick wrapper with AI subcommand for intelligent image operations.

**Usage:**
- `imagick ai "resize to 800x600"` - AI-powered image operations
- `imagick convert input.png output.jpg` - Standard ImageMagick operations

### pixelart

**When to use:** When working with pixel art images.

**Description:** Pixel art processing tool.

**Usage:**
- `pixelart image.png` - Process pixel art

### amesh

**When to use:** When you need to fetch weather radar images for Japan.

**Description:** Fetch weather radar images from amesh.jp.

**Usage:**
- `amesh` - Download latest radar image
- `amesh --save weather.png` - Save to specific file

## Web & Data Processing

### tenki

**When to use:** When you need weather information.

**Description:** Weather information tool using OpenWeatherMap API.

**Usage:**
- `tenki` - Get current weather
- `tenki Tokyo` - Weather for specific location

### html-title

**When to use:** When you need to extract the title from HTML content or URLs.

**Description:** Extract HTML title tags.

**Usage:**
- `echo "<html><head><title>Test</title></head></html>" | html-title` - Extract title
- `html-title https://example.com` - Get title from URL

### html-encode

**When to use:** When you need to HTML-encode or decode text.

**Description:** HTML encoding/decoding utility.

**Usage:**
- `echo "<div>" | html-encode` - Encode HTML entities
- `html-encode --decode "&lt;div&gt;"` - Decode HTML entities

### json2yaml

**When to use:** When you need to convert JSON to YAML format.

**Description:** Convert JSON to YAML.

**Usage:**
- `echo '{"key": "value"}' | json2yaml` - Convert JSON to YAML
- `json2yaml data.json` - Convert file

### yaml2json

**When to use:** When you need to convert YAML to JSON format.

**Description:** Convert YAML to JSON.

**Usage:**
- `echo 'key: value' | yaml2json` - Convert YAML to JSON
- `yaml2json config.yaml` - Convert file

### toml2json

**When to use:** When you need to convert TOML to JSON format.

**Description:** Convert TOML to JSON.

**Usage:**
- `toml2json pyproject.toml` - Convert TOML file to JSON
- `echo '[section]\nkey = "value"' | toml2json` - Convert TOML to JSON

### uri-encode

**When to use:** When you need to URL-encode or decode strings.

**Description:** URL encoding/decoding utility.

**Usage:**
- `echo "hello world" | uri-encode` - Encode URL
- `uri-encode --decode "hello%20world"` - Decode URL

### http-status

**When to use:** When you need to look up HTTP status code meanings.

**Description:** HTTP status code lookup with descriptions.

**Usage:**
- `http-status 404` - Get description of status code
- `http-status 200` - Explain status code

### toqr

**When to use:** When you need to generate QR codes from text or URLs.

**Description:** Generate QR codes.

**Usage:**
- `echo "https://example.com" | toqr` - Generate QR code
- `toqr --output qr.png "text"` - Save QR code to file

## Time & Date Tools

### jdate

**When to use:** When you need Japanese calendar information, sunrise/sunset times.

**Description:** Japanese calendar and astronomical calculations (sunrise, sunset).

**Usage:**
- `jdate` - Show today's info
- `jdate 2024-01-01` - Info for specific date
- `jdate --sunrise` - Get sunrise time
- `jdate --sunset` - Get sunset time

### timer

**When to use:** When you need to measure time or set a countdown timer.

**Description:** Time measurement and countdown tool.

**Usage:**
- `timer 60` - 60-second countdown
- `timer --stopwatch` - Start stopwatch

### calendar

**When to use:** When you need an enhanced calendar view with additional features.

**Description:** Enhanced calendar with extended functionality.

**Usage:**
- `calendar` - Show current month
- `calendar 2024 12` - Show specific month

## Development & Text Processing

### jinja2

**When to use:** When you need to process Jinja2 templates.

**Description:** Jinja2 template processing from command line.

**Usage:**
- `echo "Hello {{ name }}" | jinja2 --var name=World` - Process template
- `jinja2 template.j2 --var key=value` - Process template file

### filename

**When to use:** When you need to manipulate or sanitize filenames.

**Description:** Filename manipulation utility.

**Usage:**
- `echo "My File.txt" | filename --sanitize` - Sanitize filename
- `filename --normalize "file name.doc"` - Normalize filename

## Configuration

### llm-config

**When to use:** When you need to configure LLM settings for codegen, translate, zhcomp, and other AI tools.

**Description:** LLM configuration management for AI-powered tools.

**Usage:**
- `llm-config --list` - List current configuration
- `llm-config --set provider=gemini` - Set default provider
- `llm-config --set model=grok-4-fast-reasoning` - Set default model

## General Guidelines

### Using These Tools

Claude Code should proactively use these tools when:

1. **AI/LLM Tools**: When generating code, translating text, or processing language content
2. **System Utilities**: When caching is beneficial, watching files, or interacting with clipboard
3. **Media & Graphics**: When processing, comparing, or analyzing images
4. **Web & Data**: When converting data formats or fetching web content
5. **Time & Date**: When calendar or time calculations are needed
6. **Development**: When template processing or filename manipulation is required

### Integration Patterns

- Most tools support pipe input: `echo "data" | tool`
- Most tools have `-h` or `--help` flags for detailed usage
- Tools are designed to work in shell pipelines
- Error messages are sent to stderr, output to stdout

### Environment Requirements

- Python tools require the `.venv` environment (already set up)
- LLM tools require appropriate API keys in environment variables
- All tools are in PATH and can be called directly

### Performance Considerations

- Use `withcache` for expensive operations
- LLM tools support provider/model selection for speed/quality tradeoffs
- Prefer specific tools over general-purpose commands when available
