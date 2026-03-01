# Lessons Learned

Erkenntnisse, Korrekturen und Entscheidungen aus der Arbeit mit diesem Template.  
Claude Code liest diese Datei bei Bedarf als Kontext.

---

## Quarkus – RabbitMQ Messaging Config

**Problem:** Falsche Property-Keys für RabbitMQ-Konfiguration.

**Richtig (SmallRye Reactive Messaging, `quarkus-messaging-rabbitmq`):**
```properties
# Globale Broker-Verbindung
rabbitmq-host=localhost
rabbitmq-port=5672
rabbitmq-username=app
rabbitmq-password=app

# Channel-Mapping – incoming → Queue, outgoing → Exchange
mp.messaging.incoming.[channel-name].connector=smallrye-rabbitmq
mp.messaging.incoming.[channel-name].queue.name=[queue-name]
mp.messaging.outgoing.[channel-name].connector=smallrye-rabbitmq
mp.messaging.outgoing.[channel-name].exchange.name=[exchange-name]
```

**Falsch (nicht verwenden):**
```properties
# Diese Keys existieren NICHT für SmallRye RabbitMQ:
RABBITMQ_HOST=...         # Nur für Docker Compose Umgebungsvariablen
quarkus.rabbitmq.*=...    # Ist der Quarkiverse RabbitMQ Client, nicht SmallRye
```

**Dev Services deaktivieren** – **pro Extension**, nicht global:
```properties
quarkus.rabbitmq.devservices.enabled=false   # SmallRye RabbitMQ
quarkus.datasource.devservices.enabled=false  # PostgreSQL
```
`quarkus.devservices.enabled=false` greift **nicht** für RabbitMQ.

**Dependency:**
```xml
<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-messaging-rabbitmq</artifactId>
</dependency>
```
Quelle: https://quarkus.io/guides/rabbitmq-reference

---

## Quarkus – Blocking Consumer

`@Incoming`-Methoden laufen auf I/O-Threads. Bei DB-Zugriffen **immer** `@Blocking`:
```java
@Incoming("orders-in")
@Blocking
@Transactional
public void handle(String payload) { ... }
```
Ohne `@Blocking` → Deadlock oder IllegalStateException bei JPA-Operationen.

---

## DevContainer – Dev Services vs. Docker Compose

Quarkus Dev Services starten per Testcontainers automatisch PostgreSQL und RabbitMQ.  
Im DevContainer (Docker-in-Docker) kann das mit Docker Desktop kollidieren.  
→ Dev Services deaktivieren, echte Services via `docker compose up` starten.

---

## Taikai vs. ArchUnit

Beide testen Architekturregeln zur Build-Zeit:
- **ArchUnit** – mächtiger, mehr Flexibilität, mehr Boilerplate
- **Taikai** – basiert auf ArchUnit, weniger Code, Quarkus-spezifische Regeln eingebaut

Für neue Projekte: Taikai bevorzugen. Bei komplexen Custom-Rules: ArchUnit direkt.

Dependency (nur `test` scope!):
```xml
<dependency>
    <groupId>com.enofex</groupId>
    <artifactId>taikai</artifactId>
    <version>1.49.0</version>
    <scope>test</scope>
</dependency>
```

---

## Template-Benennung

Beispiele in Templates fachlich neutral halten: `order`, `product`, `event`, `item`.  
Keine domänenspezifischen Namen wie `Antrag`, `Buergerservice`, `Akte` im Template.
