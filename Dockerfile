FROM node:buster

RUN apt-get update && apt-get install -y \
      wget \
      && rm -rf /var/lib/apt/lists/*

ENV LILYPOND_VERSION 2.22.0-1

# Lilypond
RUN cd /tmp && \
    wget https://lilypond.org/download/binaries/linux-64/lilypond-${LILYPOND_VERSION}.linux-64.sh && \
    echo -e "\n" | sh lilypond-${LILYPOND_VERSION}.linux-64.sh && \
    rm -rf lilypond-${LILYPOND_VERSION} && \
    apt-get remove wget -y

WORKDIR /app
COPY . .
RUN npm install

CMD node src/index.js
