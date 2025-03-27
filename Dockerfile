# Use a specific Python version on Alpine if possible for stability
# Python 3.11 is available on Alpine 3.18
FROM alpine:3.18

LABEL maintainer="herve.leclerc@alterway.fr"

# Combine RUN commands where logical to reduce layers
# Add musl-dev for compiling native extensions on Alpine
# Add build-base as a meta-package for common build tools (includes gcc, make, etc.)
# Update pip first
RUN apk -U add \
        docker \
        python3 \
        py3-pip \
        perl \
        vim \
        # build-base includes make, gcc, g++, etc.
        build-base \
        # Explicitly add musl-dev needed for compiling on Alpine
        musl-dev \
        # Rust toolchain
        rust \
        cargo \
        # Dependencies often needed for Python packages
        pkgconfig \
        openssl \
        openssl-dev \
    && rm -rf /var/cache/apk/* \
    # Upgrade pip first
    && python3 -m pip install --upgrade pip \
    && cargo install --root /usr/local --locked stork-search \
    # Install python packages, use --no-cache-dir to ensure fresh builds/downloads
    && python3 -m pip install --no-cache-dir \
        "pelican[markdown]" \
        rtoml \
        pygments \
        typogrify \
        pelican-syntax-highlighting \
        code2html \
        pelican-search \
    # Optional: Verify rtoml installation immediately after install
    && python3 -c "import rtoml; print(f'Successfully imported rtoml version: {rtoml.__version__}')"

COPY start.sh /start.sh
RUN chmod +x /start.sh
EXPOSE 8000

CMD ["/bin/sh", "/start.sh"]