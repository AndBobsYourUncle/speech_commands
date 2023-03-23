FROM ubuntu:22.04

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        wget \
        build-essential gcc make cmake \
        ca-certificates \
        libsdl2-dev \
        libopenblas-dev && \
    apt-get clean && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN git clone https://github.com/ggerganov/whisper.cpp

WORKDIR /tmp/whisper.cpp

RUN bash ./models/download-ggml-model.sh base.en && bash ./models/download-ggml-model.sh tiny.en

RUN make bench
