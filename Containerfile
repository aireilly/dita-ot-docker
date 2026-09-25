FROM eclipse-temurin:17-jre AS builder

ARG VERSION
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -q && \
    apt-get install -qy --no-install-recommends unzip curl && \
    rm -rf /var/lib/apt/lists/*

RUN test -n "$VERSION" && \
    curl -fSL --retry 5 --retry-delay 5 --connect-timeout 30 --max-time 900 \
      -o /tmp/dita-ot.zip \
      "https://github.com/dita-ot/dita-ot/releases/download/$VERSION/dita-ot-$VERSION.zip" && \
    unzip -qq /tmp/dita-ot.zip -d /tmp/ && \
    mkdir -p /opt/app && \
    cd "/tmp/dita-ot-$VERSION" && \
    mv bin config lib plugins build.xml integrator.xml /opt/app/ && \
    chmod 755 /opt/app/bin/dita && \
    /opt/app/bin/dita --install

FROM eclipse-temurin:17-jre

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

LABEL "maintainer"="DITA Open Toolkit project"
LABEL "org.opencontainers.image.authors"="https://www.dita-ot.org/who_we_are"
LABEL "org.opencontainers.image.documentation"="https://www.dita-ot.org/"
LABEL "org.opencontainers.image.vendor"="DITA Open Toolkit project"
LABEL "org.opencontainers.image.licenses"="Apache-2.0"
LABEL "org.opencontainers.image.title"="DITA Open Toolkit"
LABEL "org.opencontainers.image.description"="Publishing engine for content authored in the Darwin Information Typing Architecture."
LABEL "org.opencontainers.image.source"="https://github.com/dita-ot/dita-ot"

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -q && \
    apt-get install -qy --no-install-recommends locales tzdata && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -ms /bin/bash dita-ot

COPY --from=builder --chown=dita-ot:dita-ot /opt/app /opt/app

USER dita-ot

ENV DITA_HOME=/opt/app
ENV PATH=${PATH}:${DITA_HOME}/bin

WORKDIR $DITA_HOME

ENTRYPOINT ["/opt/app/bin/dita"]
