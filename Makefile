IMAGE := openclaw:local
PORT  ?= 18789

# Prompt for AGENT if not provided and the target needs it
NEEDS_AGENT := start stop restart logs shell add-userbot
ifeq ($(AGENT),)
ifneq ($(filter $(NEEDS_AGENT),$(MAKECMDGOALS)),)
AGENT := $(shell bash -c 'read -p "Agent name: " a && echo $$a' </dev/tty)
endif
endif

DC = sudo env IMAGE=$(IMAGE) AGENT_NAME=$(AGENT) PORT=$(PORT) docker compose -p openclaw-$(AGENT) -f infra/docker-compose.yml

# ── Build custom image ──────────────────────────────────
build:
	sudo docker build -t $(IMAGE) -f infra/Dockerfile infra/

# ── Create new agent (interactive) ───────────────────────
create: build
	read -p "Create agent name: " AGENT_NAME; \
	mkdir -p $$AGENT_NAME && \
	sudo docker run -it --rm \
		--entrypoint "" \
		-v ./$$AGENT_NAME:/home/node/.openclaw \
		$(IMAGE) \
		node dist/index.js onboard --no-install-daemon

# ── Generate Telegram session string (interactive) ────────
generate-session:
	@TMPDIR=$$(mktemp -d) && \
	trap 'rm -rf "$$TMPDIR"' EXIT && \
	read -p "TELEGRAM_API_ID: " API_ID; \
	read -p "TELEGRAM_API_HASH: " API_HASH; \
	python3 -m venv "$$TMPDIR/venv" && \
	"$$TMPDIR/venv/bin/pip" install --quiet telethon python-dotenv && \
	TELEGRAM_API_ID="$$API_ID" TELEGRAM_API_HASH="$$API_HASH" \
	"$$TMPDIR/venv/bin/python" $(CURDIR)/infra/telegram-mcp/session_string_generator.py

# ── Add userbot MCP to an agent ────────────────────────────
add-userbot:
	@read -p "TELEGRAM_API_ID: " API_ID; \
	read -p "TELEGRAM_API_HASH: " API_HASH; \
	read -p "TELEGRAM_SESSION_STRING: " SESSION_STRING; \
	mkdir -p $(AGENT)/workspace/config && \
	printf '{\n  "mcpServers": {\n    "telegram": {\n      "command": "python3",\n      "args": ["/opt/telegram-mcp/main.py"],\n      "lifecycle": "keep-alive",\n      "env": {\n        "TELEGRAM_API_ID": "%s",\n        "TELEGRAM_API_HASH": "%s",\n        "TELEGRAM_SESSION_STRING": "%s"\n      }\n    }\n  }\n}\n' "$$API_ID" "$$API_HASH" "$$SESSION_STRING" > $(AGENT)/workspace/config/mcporter.json && \
	echo "  ✓ config/mcporter.json" && \
	mkdir -p $(AGENT)/workspace/skills/telegram-userbot && \
	cp infra/telegram-mcp/SKILL.md $(AGENT)/workspace/skills/telegram-userbot/SKILL.md && \
	echo "  ✓ skills/telegram-userbot/SKILL.md" && \
	if ! grep -q '## Telegram Userbot' $(AGENT)/workspace/TOOLS.md 2>/dev/null; then \
		cat infra/telegram-mcp/tools-snippet.md >> $(AGENT)/workspace/TOOLS.md; \
		echo "  ✓ TOOLS.md updated"; \
	else \
		echo "  · TOOLS.md already has Telegram section, skipped"; \
	fi && \
	if ! grep -q '## Telegram groups check' $(AGENT)/workspace/HEARTBEAT.md 2>/dev/null; then \
		cat infra/telegram-mcp/heartbeat-snippet.md >> $(AGENT)/workspace/HEARTBEAT.md; \
		echo "  ✓ HEARTBEAT.md updated"; \
	else \
		echo "  · HEARTBEAT.md already has Telegram section, skipped"; \
	fi && \
	echo "Done. Userbot added to $(AGENT)."

# ── Lifecycle ────────────────────────────────────────────
start:
	sudo chown -R 1000:1000 $(AGENT)/
	$(DC) up -d

stop:
	$(DC) down

restart: stop start

logs:
	$(DC) logs -f

shell:
	sudo docker exec -it openclaw-$(AGENT) bash
