ARG NODE_VERSION

FROM node:${NODE_VERSION}

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
    ca-certificates \
    tzdata \
    curl \
    unzip

RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash -\
    && apt-get update \
    && apt-get install -y nodejs \
    && npm i -g npm

RUN curl -q https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable

RUN apt-get update \
    && apt-get install -y \
    locales \
    && sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen \
    && locale-gen ja_JP.UTF-8

RUN apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /tmp/noto
WORKDIR /tmp/noto
ADD https://noto-website.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip ./
RUN unzip NotoSansCJKjp-hinted.zip \
    && mkdir -p /usr/share/fonts/noto \
    && cp *.otf /usr/share/fonts/noto \
    && chmod 644 -R /usr/share/fonts/noto/ \
    && /usr/bin/fc-cache -fv
WORKDIR /
RUN rm -rf /tmp/noto

RUN useradd -g users -m user

ENV TZ=Asia/Tokyo
ENV LANG=ja_JP.UTF-8

USER user
