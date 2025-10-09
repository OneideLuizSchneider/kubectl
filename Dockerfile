FROM alpine:latest

ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN apk add --no-cache bash curl

# Download kubectl binary and put it in /usr/local/bin
RUN set -eux; \
    KUBECTL_VERSION="$(curl -fsSL https://dl.k8s.io/release/stable.txt)"; \
    curl -fsSLo kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl"; \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl; \
    rm -f kubectl

ENV HELM_VERSION="v3.19.0"
RUN curl -fSL "https://get.helm.sh/helm-${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" -o helm.tar.gz && \
    tar -zxvf helm.tar.gz && \
    mv ${TARGETOS}-${TARGETARCH}/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    rm -rf "${TARGETOS}-${TARGETARCH}" helm.tar.gz

# Add /usr/local/bin to PATH explicitly (should already be, but just to be sure)
ENV PATH="/usr/local/bin:${PATH}"
