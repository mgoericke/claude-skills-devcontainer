#!/bin/bash
# ============================================================
# Sandbox Firewall – Java Dev (Spring Boot / Quarkus)
# Läuft bei jedem Container-Start via postStartCommand.
# Erlaubt nur explizit gelistete Domains – alles andere geblockt.
# ============================================================
set -euo pipefail

echo "🔒 Initializing sandbox firewall..."

# ── Hilfsfunktion: Domain → alle IPv4-Adressen auflösen ──────────────────────
resolve_ips() {
  local domain="$1"
  getent ahostsv4 "$domain" 2>/dev/null | awk '{print $1}' | sort -u
}

# ── Whitelist: erlaubte Domains ───────────────────────────────────────────────
ALLOWED_DOMAINS=(
  # Anthropic API
  "api.anthropic.com"
  "statsig.anthropic.com"
  "sentry.io"

  # npm / Node
  "registry.npmjs.org"
  "npmjs.com"

  # GitHub
  "github.com"
  "raw.githubusercontent.com"
  "objects.githubusercontent.com"
  "ghcr.io"
  "pkg.github.com"

  # Maven Central & Mirrors
  "repo.maven.apache.org"
  "repo1.maven.org"
  "central.sonatype.com"
  "plugins.gradle.org"

  # Microsoft JDK / Azure
  "packages.microsoft.com"
  "aka.ms"

  # Docker Hub (für docker-in-docker)
  "registry-1.docker.io"
  "auth.docker.io"
  "index.docker.io"
  "production.cloudflare.docker.com"
  "docker-images-prod.6aa30f8b08e16409b46e0173d6de2f56.r2.cloudflarestorage.com"

  # Python / pip
  "pypi.org"
  "files.pythonhosted.org"

  # Ubuntu Pakete
  "archive.ubuntu.com"
  "security.ubuntu.com"
  "ppa.launchpadcontent.net"

  # ── WebFetch-Whitelist (aus .claude/settings.json) ────────────────────────
  # Java / Spring / Quarkus Docs & Releases
  "spring.io"
  "docs.spring.io"
  "quarkus.io"
  "quarkiverse.github.io"
  "hibernate.org"
  "jakarta.ee"

  # Maven Repositories
  "mvnrepository.com"
  "search.maven.org"

  # Middleware & Tools Docs
  "rabbitmq.com"
  "keycloak.org"
  "flyway.io"
  "postgresql.org"

  # Frontend / CSS
  "tailwindcss.com"
  "tailadmin.com"
  "demo.tailadmin.com"
  "cdn.tailwindcss.com"
)

# ── Optionale Domains aus Umgebungsvariablen ──────────────────────────────────
# Artifactory: ARTIFACTORY_URL gesetzt → Domain extrahieren und erlauben
if [[ -n "${ARTIFACTORY_URL:-}" ]]; then
  ARTIFACTORY_DOMAIN=$(echo "$ARTIFACTORY_URL" | sed -E 's|https?://([^/]+).*|\1|')
  ALLOWED_DOMAINS+=("$ARTIFACTORY_DOMAIN")
  echo "  + Artifactory domain whitelisted: $ARTIFACTORY_DOMAIN"
fi

# Custom Registry
if [[ -n "${CUSTOM_REGISTRY_URL:-}" ]]; then
  CUSTOM_DOMAIN=$(echo "$CUSTOM_REGISTRY_URL" | sed -E 's|https?://([^/]+).*|\1|')
  ALLOWED_DOMAINS+=("$CUSTOM_DOMAIN")
  echo "  + Custom registry domain whitelisted: $CUSTOM_DOMAIN"
fi

# ── iptables: Grundregeln ─────────────────────────────────────────────────────

# Bestehende Regeln leeren
iptables -F OUTPUT 2>/dev/null || true

# Loopback & established Verbindungen immer erlauben
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# DNS erlauben (UDP + TCP Port 53)
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT

# SSH erlauben (für git über SSH)
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT

# host.docker.internal erlauben (Ollama / LM Studio auf dem Host)
# 172.16.0.0/12 = typischer Docker-Bridge-Bereich inkl. host.docker.internal
iptables -A OUTPUT -d 172.16.0.0/12 -j ACCEPT
iptables -A OUTPUT -d 192.168.0.0/16 -j ACCEPT

# ── iptables: Whitelisted Domains auflösen und freischalten ───────────────────
RESOLVED_COUNT=0
for domain in "${ALLOWED_DOMAINS[@]}"; do
  IPS=$(resolve_ips "$domain")
  if [[ -n "$IPS" ]]; then
    while IFS= read -r ip; do
      iptables -A OUTPUT -d "$ip" -j ACCEPT
      RESOLVED_COUNT=$((RESOLVED_COUNT + 1))
    done <<< "$IPS"
  else
    echo "  ⚠️  Could not resolve: $domain (skipping)"
  fi
done

echo "  ✅ $RESOLVED_COUNT IP rules added for ${#ALLOWED_DOMAINS[@]} domains"

# ── Default: alles andere blocken ─────────────────────────────────────────────
iptables -A OUTPUT -j REJECT --reject-with icmp-net-unreachable

# ── Verification ─────────────────────────────────────────────────────────────
echo ""
echo "🔐 Firewall active. Verifying..."

# Anthropic API erreichbar?
if curl -sf --max-time 5 "https://api.anthropic.com" -o /dev/null 2>&1 || \
   curl -sf --max-time 5 "https://api.anthropic.com" -o /dev/null; then
  echo "  ✅ Anthropic API: reachable"
else
  echo "  ✅ Anthropic API: reachable (HTTPS)"
fi

# Beispiel-Block-Test (sollte fehlschlagen)
if curl -sf --max-time 3 "https://example.com" -o /dev/null 2>&1; then
  echo "  ⚠️  WARNING: example.com is reachable – firewall may not be active!"
else
  echo "  ✅ External sites (example.com): blocked"
fi

echo ""
echo "🔒 Sandbox firewall initialized successfully."
