# Java DevContainer Template

DevContainer-Template für Java-Projekte mit Spring Boot oder Quarkus.  
Enthält Claude Code, Java 25, PostgreSQL, RabbitMQ und Architektur-Tests out of the box.

## Voraussetzungen

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [VS Code](https://code.visualstudio.com/) + [Dev Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- `ANTHROPIC_API_KEY` als Umgebungsvariable auf dem Host

## Schnellstart

```bash
# 1. Template verwenden (GitHub → "Use this template")
git clone git@github.com:your-org/your-repo.git && cd your-repo

# 2. VS Code öffnen → "Reopen in Container"
code .
```

Der Container installiert alle Tools automatisch. Beim ersten Start ~3–5 Min.

---

## Umgebungsvariablen

Der Container liest Variablen vom Host. Setzen in `~/.zshrc` / `~/.bashrc`  
(Windows: `$env:VARIABLE = "..."` in PowerShell oder System-Umgebungsvariablen):

```bash
# Pflicht
export ANTHROPIC_API_KEY="sk-ant-..."

# Optional – nur setzen wenn benötigt
export ARTIFACTORY_URL="https://your-company.jfrog.io/artifactory"
export ARTIFACTORY_USER="your.name@example.com"
export ARTIFACTORY_TOKEN="your-token"

export GITHUB_TOKEN="ghp_..."    # GitHub Packages
export NPM_TOKEN="npm_..."       # Private NPM Registry
```

Nicht gesetzte Variablen werden ignoriert – kein Fehler.

### Maven – Artifactory konfigurieren

Wenn `ARTIFACTORY_URL` gesetzt ist, `~/.m2/settings.xml` im Container anlegen:

```xml
<settings>
  <servers>
    <server>
      <id>artifactory</id>
      <username>${env.ARTIFACTORY_USER}</username>
      <password>${env.ARTIFACTORY_TOKEN}</password>
    </server>
  </servers>
  <mirrors>
    <mirror>
      <id>artifactory</id>
      <url>${env.ARTIFACTORY_URL}/maven-public</url>
      <mirrorOf>*</mirrorOf>
    </mirror>
  </mirrors>
</settings>
```

---

## Stack

| | |
|--|--|
| Java | 25 (Microsoft OpenJDK) |
| Frameworks | Spring Boot 3.x oder Quarkus 3.x |
| Datenbank | PostgreSQL 17 |
| Messaging | RabbitMQ 4 (SmallRye Reactive Messaging) |
| Build | Maven 3.9 |
| Architektur-Tests | Taikai (basiert auf ArchUnit) |
| KI | Claude Code |

---

## Lokale Infrastruktur starten

```bash
docker compose up -d
```

PostgreSQL: `localhost:5432` · RabbitMQ Management: http://localhost:15672 (app/app)

---

## Neues Projekt scaffolden

Claude Code starten und einfach sagen:

```
Erstelle ein neues Quarkus-Projekt
```

Claude fragt nach `groupId`, `artifactId` und Framework, dann wird alles generiert.

---

## Projektstruktur (BCE-Pattern)

```
src/main/java/com/example/orders/
├── boundary/
│   ├── rest/          # REST-Endpunkte (OrderResource.java)
│   └── messaging/     # Consumer (OrderConsumer.java)
├── control/           # Business-Logik (OrderService.java)
└── entity/            # JPA Entities, Repositories, DTOs
```

Architektur-Regeln werden durch Taikai-Tests zur Build-Zeit geprüft:

```bash
./mvnw test -Dtest=ArchitectureTest
```
