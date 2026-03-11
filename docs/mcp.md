# Data Access in Chat (MCP)

Claude Code can access the running infrastructure directly via MCP servers (Model Context Protocol) –
natural language queries right in the chat.

---

## PostgreSQL

The MCP server `@modelcontextprotocol/server-postgres` is preconfigured in `.claude/settings.json`.
After scaffolding, adjust the database name to `<artifactId>db`
(default: `appdb`):

```json
"postgresql://app:app@localhost:5432/<artifactId>db"
```

Claude automatically recognizes the schema and translates natural language into SQL:

```
Show all products
Search for products with a price between 10 and 50
How many orders were created today?
Show the last 5 events sorted by creation date
```

### Configuration (`.claude/settings.json`)

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "postgresql://app:app@localhost:5432/appdb"
      ]
    }
  }
}
```

> **Prerequisite:** Infrastructure must be running (`docker compose up -d`) and
> the database must be initialized through Flyway migrations.

---

## RabbitMQ

The Management API (port 15672) is accessible without additional configuration.
Claude can query it directly via HTTP calls:

```
Show all queues and their message counts
How many messages are waiting in the "orders" queue?
```

Base URL: `http://localhost:15672/api` (Credentials: `app` / `app`)
