# Template-Updates einspielen (Upstream-Sync)

Wenn das Template verbessert wird (neue Skills, DevContainer-Updates, neue Regeln),
können diese Änderungen in den Fork übernommen werden.

> **Regel:** Upstream-Sync **niemals** direkt auf `main` – immer über einen
> separaten Branch und Pull Request.

```bash
# 1. Neue Commits holen (kein Merge)
git fetch upstream

# 2. Prüfen ob etwas Neues vorliegt
git log HEAD..upstream/main --oneline

# 3. Sync-Branch anlegen
git checkout -b chore/upstream-sync

# 4. Upstream-main mergen
git merge upstream/main

# 5. Konflikte lösen (falls vorhanden), dann committen
git add .
git commit -m "chore: sync upstream template changes"

# 6. Branch pushen und Pull Request öffnen
git push origin chore/upstream-sync
```

---

## Konflikt-Übersicht

| Datei | Konfliktrisiko | Empfehlung |
|-------|----------------|-----------|
| `.devcontainer/devcontainer.json` | Mittel | Eigene `containerEnv`-Einträge behalten, neue Features übernehmen |
| `CLAUDE.md` | Niedrig | Upstream-Regeln übernehmen, eigene Erweiterungen darunter behalten |
| `.claude/skills/` | Niedrig | Neue Skills sind reine Ergänzungen |
| `docker-compose.yml` | Hoch | Eigene Services sorgfältig prüfen |

**Empfehlung:** Bei jedem neuen Feature-Branch kurz `git fetch upstream` und
`git log HEAD..upstream/main --oneline` ausführen, um frühzeitig Updates zu erkennen.
