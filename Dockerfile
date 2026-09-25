FROM eclipse-temurin:17-jre AS builder

ARG VERSION=4.3.4
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -q && \
    apt-get install -qy --no-install-recommends unzip curl && \
    rm -rf /var/lib/apt/lists/*

RUN if [ -z "$VERSION" ]; then echo "ERROR: VERSION build arg is not set" >&2; exit 1; fi && \
    curl -fSL --retry 5 --retry-delay 5 --connect-timeout 30 --max-time 900 \
      -o /tmp/dita-ot.zip \
      "https://github.com/dita-ot/dita-ot/releases/download/$VERSION/dita-ot-$VERSION.zip" && \
    unzip -qq /tmp/dita-ot.zip -d /tmp/ && \
    mkdir -p /opt/app && \
    cd "/tmp/dita-ot-$VERSION" && \
    mv bin config lib plugins build.xml integrator.xml /opt/app/ && \
    chmod 755 /opt/app/bin/dita && \
    /opt/app/bin/dita --install
