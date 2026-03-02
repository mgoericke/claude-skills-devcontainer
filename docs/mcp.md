# Datenzugriff im Chat (MCP)

Claude Code kann über MCP-Server (Model Context Protocol) direkt auf die laufende
Infrastruktur zugreifen – natürlichsprachliche Abfragen direkt im Chat.

---

## PostgreSQL

Der MCP-Server `@modelcontextprotocol/server-postgres` ist in `.claude/settings.json`
vorkonfiguriert. Nach dem Scaffolding den Datenbanknamen auf `<artifactId>db` anpassen
(Standard: `appdb`):

```json
"postgresql://app:app@localhost:5432/<artifactId>db"
```

Claude erkennt das Schema automatisch und übersetzt natürliche Sprache in SQL:

```
Zeige alle Produkte
Suche Produkte mit einem Preis zwischen 10 und 50
Wie viele Bestellungen wurden heute angelegt?
Zeige die letzten 5 Events sortiert nach Erstellungsdatum
```

### Konfiguration (`.claude/settings.json`)

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

> **Voraussetzung:** Infrastruktur muss laufen (`docker compose up -d`) und
> die Datenbank muss durch Flyway-Migrationen initialisiert sein.

---

## RabbitMQ

Die Management API (Port 15672) ist ohne zusätzliche Konfiguration erreichbar.
Claude kann sie direkt über HTTP-Aufrufe abfragen:

```
Zeige alle Queues und ihre Nachrichtenanzahl
Wie viele Nachrichten warten in der Queue "orders"?
```

Basis-URL: `http://localhost:15672/api` (Credentials: `app` / `app`)
