FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
      wget \
      gnupg \
      ca-certificates \
      && rm -rf /var/lib/apt/lists/*

# openresty
RUN wget -qO - https://openresty.org/package/pubkey.gpg | apt-key add - && \
      echo "deb http://openresty.org/package/ubuntu focal main" | tee /etc/apt/sources.list.d/openresty.list && \
      apt-get update && \
      apt-get -y install --no-install-recommends openresty

# lilypond
ENV LILYPOND_VERSION 2.22.0-1
RUN cd /tmp && \
      wget https://lilypond.org/download/binaries/linux-64/lilypond-${LILYPOND_VERSION}.linux-64.sh && \
      echo -e "\n" | sh lilypond-${LILYPOND_VERSION}.linux-64.sh && \
      rm -rf lilypond-${LILYPOND_VERSION} && \
      apt-get remove wget -y

CMD openresty -p `pwd` -c config/nginx.conf -g 'daemon off;'
