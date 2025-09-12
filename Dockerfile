FROM debian:trixie AS builder
WORKDIR /app

ARG VERSION_NAME=4.4.1-stable
ARG VERSION_TEMPLATES=4.4.1.stable

VOLUME [ "/app" ]

# Use BuildKit cache for apt packages
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    apt update && apt install -y --no-install-recommends \
    unzip wget ca-certificates libx11-6 libfontconfig1 \
    xz-utils zstd && \
    apt clean

RUN export dpkgArch=`dpkg --print-architecture` && echo ARCH=$dpkgArch && \
  if [ "$dpkgArch" = "amd64" ]; then \
      wget -q -O godot.zip "https://github.com/godotengine/godot-builds/releases/download/${VERSION_NAME}/Godot_v${VERSION_NAME}_linux.x86_64.zip"; \
    elif [ "$dpkgArch" = "arm64" ]; then \
      wget -q -O godot.zip "https://github.com/godotengine/godot-builds/releases/download/${VERSION_NAME}/Godot_v${VERSION_NAME}_linux.arm64.zip"; \
    else \
      echo "No compatible architecture: ${dpkgArch}" && exit 1; \
    fi

RUN unzip godot.zip && rm godot.zip && mv -v Godot* /usr/local/bin/godot

# Use BuildKit cache for export templates
RUN wget -O export.zip -q "https://github.com/godotengine/godot-builds/releases/download/${VERSION_NAME}/Godot_v${VERSION_NAME}_export_templates.tpz" && \
  mkdir -p ~/.local/share/godot/export_templates/${VERSION_TEMPLATES} && \
  unzip export.zip -d ~/.local/share/godot/export_templates/${VERSION_TEMPLATES} && \
  mv -v ~/.local/share/godot/export_templates/${VERSION_TEMPLATES}/templates/*  ~/.local/share/godot/export_templates/${VERSION_TEMPLATES}

CMD [ "/usr/local/bin/godot", "--headless" ]
