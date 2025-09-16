FROM debian:trixie
WORKDIR /app

ARG VERSION_NAME=4.5-stable
ARG VERSION_TEMPLATES=4.5.stable

VOLUME [ "/app" ]

RUN apt update && apt install -y --no-install-recommends \
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

RUN wget -O export.zip -q "https://github.com/godotengine/godot-builds/releases/download/${VERSION_NAME}/Godot_v${VERSION_NAME}_export_templates.tpz" && \
  mkdir -p ~/.local/share/godot/export_templates/${VERSION_TEMPLATES} && \
  unzip export.zip -d ~/.local/share/godot/export_templates/${VERSION_TEMPLATES} && \
  mv -v ~/.local/share/godot/export_templates/${VERSION_TEMPLATES}/templates/*  ~/.local/share/godot/export_templates/${VERSION_TEMPLATES}

CMD [ "/usr/local/bin/godot", "--headless" ]

LABEL org.opencontainers.image.title="godot-dockerhub" \
      org.opencontainers.image.description="Godot Engine Docker image based on Debian trixie and the latest Godot stable release including export templates." \
      org.opencontainers.image.authors="SharkyRawr" \
      org.opencontainers.image.url="https://github.com/SharkyRawr/godot-dockerhub" \
      org.opencontainers.image.source="https://github.com/SharkyRawr/godot-dockerhub" \
      org.opencontainers.image.licenses="Apache-2.0"