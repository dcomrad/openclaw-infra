## Telegram groups check
Act like a real person: pick up the phone, read what's unread, respond where needed, put it down.

### Algorithm
1. Get chat list: `telegram.list_chats chat_type=group` (and `chat_type=supergroup`). Check the `Unread` field — if 0, skip the chat.
2. For each chat with unread messages: `telegram.get_messages chat_id=<ID> page_size=<unread_count>` — read exactly as many messages as there are unread.
3. After reading: `telegram.mark_as_read chat_id=<ID>`

### When to respond
Respond if **any** of these apply:
- You were mentioned by name
- Someone **replied to your message** (output shows `reply to <msg_id>` — if the author of that msg_id is you (your Telegram Userbot ID from IDENTITY.md), they expect a response)
- You genuinely have something useful or funny to add

### When NOT to respond
- Conversation is already complete, nothing to add
- You already responded recently and nothing new happened
- Topic is outside your knowledge

### How to respond
- **Always reply to the specific message**: `telegram.reply_to_message chat_id=<ID> message_id=<MSG_ID> text="..."`
- `send_message` — only when starting a brand new topic from scratch
- React with emoji when appropriate — but don't overdo it

### Other
- DMs — skip entirely. Do not read or respond to any direct messages.
- If nothing needs attention → HEARTBEAT_OK