FROM alpine:3.18

LABEL maintainer="herve.leclerc@alterway.fr"

# --- Installation des dépendances système et outils ---
RUN apk -U add --no-cache \
        docker \
        python3 \
        py3-pip \
        perl \
        build-base \
        musl-dev \
        rust \
        cargo \
        pkgconfig \
        openssl \
        openssl-dev \
        libffi-dev \
    && rm -rf /var/cache/apk/* \
    && python3 -m pip install --upgrade pip

# --- Installation Stork ---
RUN cargo install --root /usr/local --locked stork-search

# --- Installation des paquets Python (laissant pip installer rtoml 0.9.0 cassé) ---
RUN echo ">>> Installing Python packages (will likely install broken rtoml 0.9.0)..." \
    && python3 -m pip install --no-cache-dir \
        "pelican[markdown]" \
        pygments \
        typogrify \
        pelican-syntax-highlighting \
        code2html \
        pelican-search \
    && echo ">>> Broken rtoml 0.9.0 install likely complete. Proceeding to fix..."

# --- Forcer la réinstallation/mise à jour de rtoml depuis la source ---
RUN echo ">>> Force-reinstalling latest rtoml from source..." \
    # --force-reinstall: Désinstalle la version existante (0.9.0) avant d'installer
    # --no-binary rtoml: Compile la dernière version depuis les sources
    # --upgrade: S'assure qu'on obtient bien la dernière version (ex: 0.12.0)
    && python3 -m pip install --no-cache-dir --force-reinstall --upgrade -vvv rtoml \
    && echo ">>> Verifying rtoml import after force-reinstall..." \
    && python3 -c "import rtoml; print(f'>>> OK: Fixed rtoml. Version {rtoml.__version__} imported successfully.')"

# --- Configuration finale ---
COPY start.sh /start.sh
RUN chmod +x /start.sh
EXPOSE 8000

CMD ["/bin/sh", "/start.sh"]