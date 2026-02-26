---
name: telegram-userbot
description: Telegram userbot via mcporter — read/send messages, reactions, manage chats
---

# Telegram Userbot

All commands follow the pattern:
```
mcporter call <command> [params] --config /home/node/.openclaw/workspace/config/mcporter.json
```
All examples below omit `--config /home/node/.openclaw/workspace/config/mcporter.json` — **always append it**.

`chat_id`/`user_id` accept: integer, string, or `@username`.

## Rules
- **ALWAYS negate group chat IDs.** `list_chats`/`get_chats` return positive IDs. Before passing to ANY other command: basic groups → prepend `-` (e.g. `5242089141` → `-5242089141`), supergroups/channels → prepend `-100` (e.g. `1234567890` → `-1001234567890`). Positive group IDs WILL fail.
- **Groups only** — never read or respond to DMs
- Check result before next action; on error check `/opt/telegram-mcp/mcp_errors.log`
- `telegram.edit_message` only works on own messages
- Don't send messages without a clear reason

---

## Chats

| Action | Command |
|---|---|
| List chats (paginated) | `telegram.get_chats page=1 page_size=50` |
| List with filter | `telegram.list_chats chat_type=group limit=20` (types: user/group/channel/supergroup) |
| Chat info | `telegram.get_chat chat_id=<ID>` |
| Participants | `telegram.get_participants chat_id=<ID>` |
| Resolve username | `telegram.resolve_username username="@name"` |

## Messages

| Action | Command |
|---|---|
| Get messages | `telegram.get_messages chat_id=<ID> page=1 page_size=100` |
| Search | `telegram.search_messages chat_id=<ID> query="text" limit=20` |
| Filtered | `telegram.list_messages chat_id=<ID> limit=50 search_query="text" from_date="2024-01-01"` |
| Topics (supergroups) | `telegram.list_topics chat_id=<ID> limit=20` |
| Send | `telegram.send_message chat_id=<ID> message="Text"` |
| Reply | `telegram.reply_to_message chat_id=<ID> message_id=<ID> text="Text"` |
| Edit (own only) | `telegram.edit_message chat_id=<ID> message_id=<ID> new_text="Text"` |
| Delete | `telegram.delete_message chat_id=<ID> message_id=<ID>` |
| Pin / unpin | `telegram.pin_message chat_id=<ID> message_id=<ID>` / `telegram.unpin_message ...` |
| Mark read | `telegram.mark_as_read chat_id=<ID>` |
| Context | `telegram.get_message_context chat_id=<ID> message_id=<ID> context_size=10` |
| History | `telegram.get_history chat_id=<ID> limit=100` |
| Pinned list | `telegram.get_pinned_messages chat_id=<ID>` |

## Reactions

| Action | Command |
|---|---|
| Add | `telegram.send_reaction chat_id=<ID> message_id=<ID> emoji="👍"` (`big=true` for animated) |
| Remove | `telegram.remove_reaction chat_id=<ID> message_id=<ID> emoji="👍"` |
| List | `telegram.get_message_reactions chat_id=<ID> message_id=<ID>` |

## Contacts

| Action | Command |
|---|---|
| List | `telegram.list_contacts` |
| Search | `telegram.search_contacts query="name"` |
| IDs only | `telegram.get_contact_ids` |
| Find DM chat | `telegram.get_direct_chat_by_contact contact_query="name"` |
| Chats with contact | `telegram.get_contact_chats contact_id=<ID>` |
| Block | `telegram.block_user user_id=<ID>` |
| My info | `telegram.get_me` |
| User photos | `telegram.get_user_photos user_id=<ID>` |

---

More tools: `mcporter tools telegram --config /home/node/.openclaw/workspace/config/mcporter.json`
