# OpenClaw Telegram Agents

Docker-инфраструктура для запуска [OpenClaw](https://openclaw.ai) AI-агентов.  
Поддерживается запуск нескольких агентов на одной машине — каждый на своём порту.  
Каждый агент — отдельный контейнер со своей личностью, памятью и (опционально) Telegram-юзерботом (работа от имени настоящего Telegram-аккаунта).

Агент работает и без юзербота — общайтесь с ним через Telegram-бот или веб-интерфейс.

## Требования

- Docker
- API-ключ провайдера LLM
- Токен Telegram-бота ([BotFather](https://t.me/BotFather))

Для юзербота (опционально):
- Python 3
- Telegram API credentials ([my.telegram.org](https://my.telegram.org))


## Быстрый старт

### 1. Создать агента

```bash
git clone https://github.com/dcomrad/openclaw-infra openclaw-telegram
cd openclaw-telegram
make create
```

Интерактивный мастер — настраивает конфиг OpenClaw (модель, токен бота, авторизация и т.д.). Образ собирается автоматически. Рядом с `infra/` появится папка с именем агента — это всё его состояние. Её можно переносить между машинами.

### 2. Запустить

```bash
make start AGENT=alice [PORT=18789]  # если не указать порт, будет использован 18789
```

Агент запущен. Пишите ему в Telegram-бот или откройте `http://localhost:18789`.

Второй агент — сначала `make create`, потом запуск на другом порту:

```bash
make start AGENT=bob PORT=18790
```

### 3. Подключить юзербот (опционально)

Если хотите, чтобы агент  действовал, как Telegram-пользователь:

```bash
make generate-session                   # Сгенерировать session string для Telegram-аккаунта
make add-userbot AGENT=alice            # Подключить юзербот к агенту
make restart AGENT=alice [PORT=18789]     # Перезапустить с юзерботом
```

`add-userbot` копирует в workspace агента сниппеты из `infra/telegram-mcp/` — инструкции для работы с Telegram. По умолчанию юзербот работает только с группами. Перед подключением отредактируйте сниппеты под себя:

- `infra/telegram-mcp/tools-snippet.md` — дописывается в TOOLS.md агента
- `infra/telegram-mcp/heartbeat-snippet.md` — дописывается в HEARTBEAT.md агента (поведение при периодическом сканировании чатов)

## Команды

```bash
make create                             # Создать нового агента (интерактивно)
make start AGENT=<имя> PORT=<порт>      # Запустить
make stop AGENT=<имя>                   # Остановить
make restart AGENT=<имя> PORT=<порт>    # Перезапустить
make logs AGENT=<имя>                   # Логи
make shell AGENT=<имя>                  # Shell в контейнер
make build                              # Пересобрать Docker-образ
make generate-session                   # Сгенерировать Telegram session string
make add-userbot AGENT=<имя>            # Подключить юзербот к агенту
```
