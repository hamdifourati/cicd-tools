FROM alpine:3.7
MAINTAINER "Hamdi Fourati <contact@hamdifourati.info>"


WORKDIR /tools
RUN mkdir /tools/bin

ENV PATH=$PATH:/tools/bin

# Tool versions
ENV TERRAFORM_VERSION=0.11.7
ENV HELM_VERSION=v2.9.1
ENV GCLOUD_VERSION=211.0.0

# Install tools

RUN apk add --update --no-cache unzip tar curl openssh-client git bash wget graphviz ttf-freefont

ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip ./
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /tools/bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv kubectl bin/

ADD https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz ./
RUN tar xavf helm-${HELM_VERSION}-linux-amd64.tar.gz 
RUN cp linux-amd64/helm bin/ && rm -rf helm-* linux-amd64/

RUN apk add --update \
    python \
    python-dev \
    py-pip \
    build-base 

ENV PATH=$PATH:/tools/google-cloud-sdk/bin
ENV CLOUDSDK_CORE_DISABLE_PROMPTS=1

ADD https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz ./
RUN tar xavf google-cloud-sdk-*.tar.gz --directory $PWD && \
    gcloud --quiet --verbosity=error components update

