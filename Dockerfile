FROM ubuntu:20.04

RUN useradd -m -u 1000 ubuntu

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

# install resty template
RUN wget -O /usr/local/openresty/lualib/resty/template.lua \
      https://raw.githubusercontent.com/bungle/lua-resty-template/master/lib/resty/template.lua

# lilypond
ENV LILYPOND_VERSION 2.22.1-1
RUN cd /tmp && \
      wget https://lilypond.org/download/binaries/linux-64/lilypond-${LILYPOND_VERSION}.linux-64.sh && \
      echo -e "\n" | sh lilypond-${LILYPOND_VERSION}.linux-64.sh && \
      rm -rf lilypond-${LILYPOND_VERSION} && \
      apt-get remove wget -y

RUN mkdir -p /app/ly && chown ubuntu:ubuntu /app/ly
CMD openresty -p `pwd` -c conf/nginx.conf -g 'daemon off;'
