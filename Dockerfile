FROM ubuntu:16.04
MAINTAINER "Hamdi Fourati <contact@hamdifourati.info>"


WORKDIR /tools
RUN mkdir /tools/bin

ENV PATH=$PATH:/tools/bin

# Tool versions
ENV TERRAFORM_VERSION=0.11.13
ENV HELM_VERSION=v2.13.0
ENV GCLOUD_VERSION=239.0.0

# Install tools

RUN apt -qq update && \
    apt -qq install -y \
    vim \
    jq \
    unzip \
    tar \
    curl \
    openssh-client \
    git \
    wget \
    graphviz \
    ttf-freefont

RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
   unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /tools/bin && \
   rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN curl -sLO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv kubectl bin/

RUN wget https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
   tar xavf helm-${HELM_VERSION}-linux-amd64.tar.gz && \
   cp linux-amd64/helm bin/ && rm -rf helm-* linux-amd64/

RUN apt -qq update && \
    apt -qq install -y \
    python \
    python-dev \
    python-pip \
    build-essential

ENV PATH=$PATH:/tools/google-cloud-sdk/bin
ENV CLOUDSDK_CORE_DISABLE_PROMPTS=1

RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz && \
    tar xavf google-cloud-sdk-*.tar.gz --directory $PWD && \
    gcloud --quiet --verbosity=error components update
