# Instrukce pro Claude Code

## Účel projektu

Tato složka je samostatným vypracováním nastavení kódovacího agenta. Projekt
ukazuje MCP servery, Skills a subagenty bez pluginů a marketplace.

## Pravidla

- Odpovídej česky.
- Pracuj uvnitř této složky.
- Nezapisuj tajné klíče do souborů.
- Nepoužívej plugins ani marketplace.
- Zachovej oddělená oprávnění MCP serverů.
- Před dokončením spusť ověření ze souboru
  `dokumentace/OVERENI.md`.
- Nejmenší relevantní ověření Python změny:
  `python3 -m unittest discover -s ukazka -t . -v`
- Repozitář je veřejný. Před každým commitem a pushem použij Skill
  `kontrola-pred-odevzdanim` a necommituj, pokud security-auditor hlásí vysoké
  riziko.
- Projektová oprávnění jsou v `.claude/settings.json`; osobní nastavení
  `.claude/settings.local.json` se necommituje.

## MCP

Konfigurace je uložená v `.mcp.json`.

- `filesystem` je omezený na tuto složku.
- `git` pracuje pouze s cílovým repozitářem.
- `github` se použije jen pro explicitní GitHub úkoly.

GitHub token musí být dostupný pouze v environment proměnné
`GITHUB_PERSONAL_ACCESS_TOKEN`.

## Skills

- `.claude/skills/python-change/SKILL.md`
- `.claude/skills/code-review/SKILL.md`
- `.claude/skills/kontrola-pred-odevzdanim/SKILL.md`

## Subagenti

- `code-reviewer` (`Read`, `Grep`, `Glob` a nástroje MCP git pro status, diff a
  historii) čte diff přes MCP git; neprovádí editace ani změny repozitáře.
- `test-runner` (`Read`, `Bash`) spouští ověření; nesmí upravovat zdroje, testy
  ani konfiguraci.
- `security-auditor` (`Read`, `Grep`, `Glob`, `mcp__git__git_log`,
  `mcp__git__git_show`) čte historii přes MCP git a kontroluje bezpečnost; bez úprav.
- `docs-checker` (`Read`, `Grep`, `Glob`) ověřuje tvrzení dokumentace.

Subagenti pracují na vymezeném úkolu bez vlastní editace. Vedoucí agent integruje
jejich výstupy, ověří tvrzení a provede potřebné změny.

## Příklad toku práce

Instrukce → Skill `python-change` → MCP git (diff) → subagenti `code-reviewer`
a `test-runner` → vedoucí agent ověří tvrzení a shrne výsledek.
Subagent `code-reviewer` čte diff přes MCP git, tedy využívá MCP.
