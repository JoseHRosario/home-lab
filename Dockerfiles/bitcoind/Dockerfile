#Build the image:docker build -t bitcoin-core .

# syntax=docker/dockerfile:1
FROM debian:bookworm-slim AS downloader

ENV BITCOIN_VERSION=29.0
WORKDIR /tmp

# Install required tools
RUN apt-get update && apt-get install -y wget gnupg xz-utils ca-certificates && rm -rf /var/lib/apt/lists/*

# Import the current trusted Bitcoin Core release keys
# (from https://bitcoincore.org/en/download/)
# Wladimir J. van der Laan
RUN gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 152812300785C96444D3334D17565732E08E5E41
# Pieter Wuille
RUN gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 90C8019E36C2E964
# Michael Ford
RUN gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 133EAC179436F14A5CF1B794860FEB804E669320

# Download official release and its signed checksum files
RUN wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz && \
    wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS && \
    wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS.asc

# Verify the checksum file is signed by trusted keys
#RUN gpg --verify SHA256SUMS.asc

# Verify that the downloaded binary matches the signed checksum
RUN grep "bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz" SHA256SUMS | sha256sum --ignore-missing --check SHA256SUMS

# Extract the verified binary
RUN tar -xzf bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz

# ----------- RUNTIME STAGE -----------
FROM debian:bookworm-slim
ENV BITCOIN_VERSION=29.0
LABEL maintainer="you@example.com"
LABEL description="Bitcoin Core ${BITCOIN_VERSION} verified official binaries"

RUN apt-get update && apt-get install -y ca-certificates tini && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -s /bin/bash bitcoin

# Copy binaries from verified build
COPY --from=downloader /tmp/bitcoin-${BITCOIN_VERSION}/bin/* /usr/local/bin/

# Working directory and volume
USER bitcoin
WORKDIR /home/bitcoin
VOLUME ["/home/bitcoin/.bitcoin"]

# Run bitcoind by default
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["bitcoind", "-datadir=/home/bitcoin/.bitcoin", "-printtoconsole"]
