FROM docker.io/eclipse-temurin:17-jre

ARG NEXUS_VERSION=3.74.0-05
ARG NEXUS_DOWNLOAD_URL=https://download.sonatype.com/nexus/3/nexus-$NEXUS_VERSION-unix.tar.gz

# configure nexus runtime
ENV SONATYPE_DIR=/opt/sonatype
ENV NEXUS_HOME=${SONATYPE_DIR}/nexus \
    NEXUS_CONTEXT='' \
    SONATYPE_WORK=${SONATYPE_DIR}/sonatype-work

# Install Java & tar
# hadolint ignore=DL3008,SC1070
RUN set -eux; \
    apt-get update && apt-get upgrade -y; \
    apt-get install -yq --no-install-recommends \
        tar gzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*; \
    groupadd --gid 1001 -r nexus && \
    useradd --uid 1001 -r nexus -g nexus -s /sbin/nologin -d /opt/sonatype/nexus

USER 1001
WORKDIR "$SONATYPE_DIR"

# Download nexus & setup directories
RUN curl -sSfL "$NEXUS_DOWNLOAD_URL" --output "nexus-$NEXUS_VERSION-unix.tar.gz" \
    && tar -xvf "nexus-$NEXUS_VERSION-unix.tar.gz" \
    && rm -f "nexus-$NEXUS_VERSION-unix.tar.gz" \
    && mv "nexus-$NEXUS_VERSION" "$NEXUS_HOME"

ENTRYPOINT ["/opt/sonatype/nexus/bin/nexus"]
CMD ["run"]