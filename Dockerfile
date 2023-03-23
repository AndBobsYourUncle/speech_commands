FROM ubuntu:22.04

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        wget \
        build-essential gcc make cmake \
        ca-certificates \
        libsdl2-dev \
        libopenblas-dev \
        libcurlpp-dev && \
    apt-get clean && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN git clone https://github.com/ggerganov/whisper.cpp && \
    cd whisper.cpp && \
    cmake . && \
    make && \
    make install && \
    cd ../ && \
    rm -r whisper.cpp

COPY . /root/speech_commands

WORKDIR /root/speech_commands

RUN bash ./models/download-ggml-model.sh base.en && bash ./models/download-ggml-model.sh tiny.en

RUN cmake . && make

RUN chmod +x entrypoint.sh

CMD [ "/bin/bash", "-c", "/root/speech_commands/entrypoint.sh" ]
