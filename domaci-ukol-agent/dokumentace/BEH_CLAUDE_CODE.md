# Záznam skutečného běhu Claude Code

Záznam jedné interaktivní relace z 18. 11. 2026. Obsahuje jen to, co se v
relaci opravdu stalo.

## Prostředí

- Claude Code 2.1.327 (`claude --version`).
- GitHub Codespaces.
- Spuštěno ze složky `domaci-ukol-agent`.

## Načtení konfigurace

- Dialog důvěry při spuštění ukázal, že se z `.claude/settings.json` načetlo
  14 předschválených oprávnění. Počet platil pro verzi před opravami popsanými
  níže; po opravě nálezů 1 a 4 je položek v `allow` více, protože se místo
  celých serverů vyjmenovávají jednotlivé nástroje.
- `/mcp`, projektové servery z `.mcp.json`:

  | Server | Stav |
  |---|---|
  | `filesystem` | připojen, 16 nástrojů |
  | `git` | připojen, 14 nástrojů |
  | `github` | selhal: chybí `GITHUB_PERSONAL_ACCESS_TOKEN` (HTTP 400, „Authorization header is badly formatted“) |

  Servery ze sekce claude.ai pocházejí z uživatelského účtu a nejsou součástí
  úkolu.
- Příkaz `/agents` v této verzi neexistuje: vypsal „The /agents wizard has been
  removed“. Seznam proto vznikl dotazem na Clauda („Vypiš mi, jaké projektové
  subagenty a jaké projektové Skills máš teď k dispozici…“).

### Projektoví subagenti

| Název | Soubor |
|---|---|
| `code-reviewer` | `.claude/agents/code-reviewer.md` |
| `test-runner` | `.claude/agents/test-runner.md` |
| `security-auditor` | `.claude/agents/security-auditor.md` |
| `docs-checker` | `.claude/agents/docs-checker.md` |

### Projektové Skills

| Název | Soubor |
|---|---|
| `python-change` | `.claude/skills/python-change/SKILL.md` |
| `code-review` | `.claude/skills/code-review/SKILL.md` |
| `kontrola-pred-odevzdanim` | `.claude/skills/kontrola-pred-odevzdanim/SKILL.md` |

## Test: „Zkontroluj úkol před odevzdáním.“

1. Na tento prompt se automaticky načetl Skill `kontrola-pred-odevzdanim`.
2. Skill spustil čtyři subagenty (`code-reviewer`, `test-runner`,
   `security-auditor`, `docs-checker`) paralelně na pozadí.
3. Vedoucí agent tvrzení subagentů ověřil vlastním čtením souborů a
   spuštěním `bash dokumentace/overeni.sh` a unittestů. Výsledky shrnul do
   jedné tabulky.
4. `security-auditor` nenašel vysoké riziko. Testy prošly (4 ze 4) a
   ověřovací skript skončil s exit kódem 0.

### Nálezy a jejich řešení

| # | Nález | Závažnost | Stav |
|---|---|---|---|
| 1 | `allow` povoloval celý `mcp__git` včetně `git_commit` a dalších zapisovacích nástrojů, takže obcházel `ask` pro `git commit` | střední | opraveno: v `allow` jen čtecí nástroje, zapisovací v `ask`; kontrola v `overeni.sh` |
| 2 | Subagenti nevěděli, jaký `repo_path` předat MCP git (kořen repozitáře je nadřazená složka) | nízká | opraveno v `code-reviewer.md` a `security-auditor.md` |
| 3 | Totéž co 1 (nahlásil i `security-auditor`) | střední | opraveno spolu s 1 |
| 4 | `deny` pro `.env`, `*.pem` a `*.key` platí jen pro `Read`; `mcp__filesystem` byl celý v `allow` včetně čtení obsahu a zápisu | střední | opraveno: v `allow` jen nástroje bez čtení obsahu, ostatní v `ask` |
| 5 | V kořeni repozitáře chyběl `.gitignore` | střední | opraveno: přidán kořenový `.gitignore`; kontrola v `overeni.sh` |
| 6 | `Edit` a `Write` bez omezení cesty dovolovaly upravit konfiguraci oprávnění bez dotazu | nízká | opraveno: úpravy `.claude/`, `.codex/`, `.mcp.json` a `.gitignore` jsou v `ask` |
| 7 | `POROVNANI.md` jmenuje soukromý repozitář kurzu | nízká | neopraveno záměrně |
| 8 | Osobní e-mail v metadatech commitů | nízká | neopraveno záměrně |
| 9 | `security-auditor.md` žádal `git log -p`, ale subagent nemá Bash | nízká | opraveno: MCP `git_log` a `git_show`; kontrola v `overeni.sh` |
| 10 | `NAVOD.md` neuváděl, že v `ask` je i `git commit` | nízká | opraveno |
| 11 | `OVERENI.md` nepopisoval dvě kontroly skriptu | nízká | opraveno, doplněny i nové kontroly |
| 12 | Codex `code-reviewer.toml` nezmiňoval MCP git, ač to tvrdil `AGENTS.md` | nízká | opraveno v TOML; `AGENTS.md` uvádí, že v Codexu jde o neověřenou instrukci |

## Co zůstává neověřeno

- GitHub MCP: bez `GITHUB_PERSONAL_ACCESS_TOKEN` se nepřipojí.
- Codex: CLI `codex` není v tomto Codespace nainstalované.
