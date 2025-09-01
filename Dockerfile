FROM alpine:latest

RUN apk add --no-cache bash curl

# Download kubectl binary and put it in /usr/local/bin
RUN curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm -f kubectl

ENV HELM_VERSION="v3.18.6"
RUN curl -fSL "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" -o helm.tar.gz && \
    tar -zxvf helm.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    rm -rf linux-amd64 helm.tar.gz

# Add /usr/local/bin to PATH explicitly (should already be, but just to be sure)
ENV PATH="/usr/local/bin:${PATH}"
