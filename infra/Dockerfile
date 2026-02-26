FROM ghcr.io/openclaw/openclaw:2026.2.15

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

COPY telegram-mcp/requirements.txt /opt/telegram-mcp/requirements.txt
RUN pip install --break-system-packages --no-cache-dir \
    -r /opt/telegram-mcp/requirements.txt

COPY telegram-mcp/main.py /opt/telegram-mcp/main.py

RUN chown -R node:node /opt/telegram-mcp

RUN npm install -g mcporter

COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

USER node

ENTRYPOINT ["/opt/entrypoint.sh"]
