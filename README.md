# Godot Docker

**Unofficial** Docker image for [Godot Engine](https://godotengine.org/) based on Debian Trixie, designed for headless builds, exports, and CI/CD workflows.

> **⚠️ Disclaimer:** This is an unofficial, community-maintained project. It is not affiliated with, endorsed by, or officially supported by the Godot Engine project or its contributors. This software is provided as-is with no warranties or guarantees of any kind.

## Features

- 🐧 Based on Debian Trixie Slim
- 🎮 Godot Engine 4.6 (both Standard and Mono editions)
- 📦 Includes export templates pre-installed
- 🏗️ Multi-architecture support (amd64, arm64, 386, armv7)
- 🔄 Ready for CI/CD pipelines
- 🚀 Optimized for headless operation

## Available Images

Images are published to GitHub Container Registry:

- **GitHub Container Registry:** `ghcr.io/sharkyrawr/godot-docker`

### Tags

- `latest` - Standard edition, latest stable version (4.6)
- `latest-mono` - Mono/.NET edition, latest stable version (4.6)
- `4.6` - Standard edition, specific version
- `4.6-mono` - Mono edition, specific version
- `4.6-standard` - Standard edition, specific version (explicit)
- `4.5.1` - Standard edition, specific version
- `4.5.1-mono` - Mono edition, specific version
- `4.5.1-standard` - Standard edition, specific version (explicit)
- Architecture-specific tags: `latest-amd64`, `latest-arm64`, `latest-386`, `latest-armv7`

## Quick Start

### Pull the image

```bash
# Standard edition
docker pull ghcr.io/sharkyrawr/godot-docker:latest

# Mono edition
docker pull ghcr.io/sharkyrawr/godot-docker:latest-mono
```

### Run Godot headless

```bash
docker run --rm -v $(pwd):/app ghcr.io/sharkyrawr/godot-docker:latest --headless --version
```

### Export your project

```bash
docker run --rm -v $(pwd):/app ghcr.io/sharkyrawr/godot-docker:latest \
  --headless --export-release "Linux/X11" ./build/game.x86_64
```

## Usage Examples

### Building Your Project

```bash
docker run --rm -v $(pwd):/app ghcr.io/sharkyrawr/godot-docker:latest \
  --headless --path /app --build-solutions --quit
```

### Exporting to Multiple Platforms

```bash
# Export for Linux
docker run --rm -v $(pwd):/app ghcr.io/sharkyrawr/godot-docker:latest \
  --headless --export-release "Linux/X11" ./exports/linux/game.x86_64

# Export for Windows (with Mono edition)
docker run --rm -v $(pwd):/app ghcr.io/sharkyrawr/godot-docker:latest-mono \
  --headless --export-release "Windows Desktop" ./exports/windows/game.exe
```

### CI/CD Integration

#### GitHub Actions Example

```yaml
name: Export Game

on:
  push:
    branches: [main]

jobs:
  export:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Export game
        run: |
          docker run --rm -v ${{ github.workspace }}:/app \
            ghcr.io/sharkyrawr/godot-docker:latest \
            --headless --export-release "Linux/X11" ./build/game.x86_64
      
      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: game-linux
          path: build/
```

#### GitLab CI Example

```yaml
export-linux:
  image: ghcr.io/sharkyrawr/godot-docker:latest
  script:
    - godot --headless --export-release "Linux/X11" ./build/game.x86_64
  artifacts:
    paths:
      - build/
```

## Building from Source

### Standard Edition

```bash
docker build -t godot-docker:latest .
```

### Mono Edition

```bash
docker build --build-arg EDITION=_mono -t godot-docker:mono .
```

### Custom Version

```bash
docker build --build-arg VERSION=4.3.0 -t godot-docker:4.3.0 .
```

## Build Arguments

- `EDITION` - Edition to build (`""` for standard, `"_mono"` for Mono/.NET)
- `VERSION` - Godot version to install (default: `4.6`)

## Architecture Support

This image supports the following architectures:

- `linux/amd64` (x86_64)
- `linux/arm64` (aarch64)
- `linux/386` (x86_32)
- `linux/arm/v7` (arm32)

Docker will automatically pull the correct image for your platform.

## Environment Variables

- `EDITION` - The edition of Godot installed (`""` or `"_mono"`)
- `GODOT_VERSION` - The version of Godot installed

## Volume

The working directory `/app` is exposed as a volume. Mount your Godot project directory here:

```bash
docker run --rm -v /path/to/your/project:/app ghcr.io/sharkyrawr/godot-docker:latest [commands]
```

## Installed Packages

The image includes the following dependencies:

- unzip, wget, ca-certificates
- X11 libraries (libx11-6, libxcursor1, libxinerama1, libxrandr2, libxi6)
- OpenGL (libgl1)
- Font configuration (libfontconfig1)
- Compression tools (xz-utils, zstd)

## Troubleshooting

### Permission Issues

If you encounter permission issues with exported files:

```bash
docker run --rm -v $(pwd):/app --user $(id -u):$(id -g) \
  ghcr.io/sharkyrawr/godot-docker:latest [commands]
```

### Export Templates Not Found

Export templates are pre-installed in `~/.local/share/godot/export_templates/`. If you encounter issues, verify the image was built correctly.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

**NO WARRANTY:** This software is provided "AS IS", WITHOUT WARRANTY OF ANY KIND, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.

## Links

- [Godot Engine](https://godotengine.org/) (Official)
- [Godot Documentation](https://docs.godotengine.org/) (Official)
- [GitHub Repository](https://github.com/SharkyRawr/godot-docker)

## Acknowledgments

Built with ❤️ for the Godot community. Not affiliated with the official Godot Engine project.
