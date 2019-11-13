FROM alpine:3.8

LABEL maintainer="romain.guichard@alterway.fr"


RUN apk -U add \
    python3 \
    py-pip \
    perl \
    make \
    && rm -rf /var/cache/apk/* \
    && pip install pelican==4.2 markdown

COPY start.sh /start.sh
RUN chmod +x /start.sh
EXPOSE 8000

CMD ["/bin/sh", "/start.sh"]
