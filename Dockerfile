FROM alpine:3.18

LABEL maintainer="herve.leclerc@alterway.fr"


RUN apk -U add \
    docker     \
    python3    \
    py-pip     \
    perl       \
    vim        \
    make       \
    && rm -rf /var/cache/apk/* \
    && python3 -m pip install "pelican[markdown]" pygments typogrify pelican-syntax-highlighting code2html pelican-search
    #&& python3 -m pip install pelican markdown MarkupSafe pelican-syntax-highlighting==0.4.2

COPY start.sh /start.sh
RUN chmod +x /start.sh
EXPOSE 8000

CMD ["/bin/sh", "/start.sh"]
