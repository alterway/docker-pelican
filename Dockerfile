# Blog dev Dockerfile

FROM gliderlabs/alpine

MAINTAINER vSense <docker@vsense.fr>

RUN apk-install \
    python \
    git \
    py-pip \
    perl \
    make \
    && rm -rf /var/cache/apk/* \
    && pip install pelican markdown

COPY start.sh /start.sh
RUN chmod +x /start.sh
EXPOSE 8000

CMD ["/bin/sh", "/start.sh"]
