FROM vaultwarden/server:latest

USER root

RUN apt-get update && apt-get install -y --no-install-recommends openssl && rm -rf /var/lib/apt/lists/*

RUN printf '#!/bin/sh\n\
if [ ! -f /data/fullchain.pem ] || [ ! -f /data/privkey.pem ]; then\n\
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /data/privkey.pem \
        -out /data/fullchain.pem \
        -subj "/CN=vaultwarden.local"\n\
fi\n\
export ROCKET_TLS="{certs=\\"/data/fullchain.pem\\",key=\\"/data/privkey.pem\\"}"\n\
exec /start.sh' > /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]