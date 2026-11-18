# Ověření nastavení

## Automatické ověření

Ze složky `domaci-ukol-agent` spusť:

```bash
bash dokumentace/overeni.sh
```

Skript ověřuje:

- verzi Pythonu >= 3.11 a dostupnost `tomllib`;
- existenci základních souborů konfigurace a instrukcí;
- syntaxi `.mcp.json`, `.claude/settings.json` a TOML konfigurací Codexu;
- shodu názvů MCP serverů mezi `.mcp.json` a `.claude/settings.json`;
- shodu názvů MCP serverů mezi `.codex/config.toml` a `.mcp.json`;
- přesnou sadu MCP serverů `filesystem`, `git` a `github` v `.mcp.json`;
- předávání GitHub tokenu přes environment proměnnou v `.mcp.json` i
  `.codex/config.toml`;
- že `allow` v `.claude/settings.json` nepovoluje celý server `mcp__git` ani
  `mcp__filesystem` a že zapisovací nástroje MCP git (`git_add`, `git_commit`,
  `git_reset`, `git_checkout`, `git_create_branch`) nejsou v `allow` a jsou v
  `ask`;
- nejméně čtyři Codex a čtyři Claude subagenty, jejich povinná metadata a
  shodu jejich názvů;
- u Claude subagentů, které v instrukcích zmiňují `diff`, přítomnost MCP git
  nástroje nebo `Bash`;
- u Claude subagentů, které v instrukcích žádají `git log -p`, přítomnost
  `Bash`;
- front matter a shodu názvů Skills v obou adresářových stromech;
- nepřítomnost `.claude-plugin`, `.codex-plugin` a `marketplace.json`;
- nepřítomnost rozpoznatelných vzorů tajemství v projektových souborech;
- to, že `.env` a `settings.local.json` nejsou sledované Gitem;
- to, že `.env` v kořeni repozitáře ignoruje kořenový `.gitignore`;
- úspěch jednotkových testů ukázky kalkulačky.

### Automatické ověření - poslední běh

Zaznamenaný skutečný výstup posledního běhu. Příkazy byly spuštěny z kořene
`domaci-ukol-agent`:

```text
$ bash dokumentace/overeni.sh
OK: JSON, TOML a názvy MCP serverů jsou platné.
OK: zapisovací nástroje MCP git nejsou předschválené a jsou v ask.
OK: čtyři nebo více subagentů mají povinná metadata a odpovídající protějšky.
OK: front matter Skills je platný a obě sady názvů jsou stejné.
OK: nejsou nalezeny zakázané pluginy, rozpoznatelná tajemství ani sledované lokální soubory.
....
----------------------------------------------------------------------
Ran 4 tests in 0.000s

OK
OK: automatické ověření dokončeno.

$ python3 -m unittest discover -s ukazka -t . -v
test_prumer_bezne_hodnoty (ukazka.test_kalkulacka.TestKalkulacka.test_prumer_bezne_hodnoty) ... ok
test_prumer_prazdneho_seznamu (ukazka.test_kalkulacka.TestKalkulacka.test_prumer_prazdneho_seznamu) ... ok
test_vydel_bezne_hodnoty (ukazka.test_kalkulacka.TestKalkulacka.test_vydel_bezne_hodnoty) ... ok
test_vydel_nulou (ukazka.test_kalkulacka.TestKalkulacka.test_vydel_nulou) ... ok

----------------------------------------------------------------------
Ran 4 tests in 0.001s

OK
```

## Nejmenší relevantní ověření Python změny

```bash
python3 -m unittest discover -s ukazka -t . -v
```

## Ruční ověření v agentech

```text
$ codex mcp list
Neověřeno: codex není v tomto Codespace nainstalován.

$ codex features list
Neověřeno: codex není v tomto Codespace nainstalován.

$ claude mcp list   # Claude Code 2.1.327, projektové servery
filesystem: npx -y @modelcontextprotocol/server-filesystem /workspaces/vibe_coding_laba/domaci-ukol-agent - ✔ Connected
git: uvx mcp-server-git --repository /workspaces/vibe_coding_laba - ✔ Connected
github: https://api.githubcopilot.com/mcp/ (HTTP) - ✘ Failed to connect — HTTP 400: Error POSTing to endpoint: bad request: Authorization header is badly formatted
 └ [Warning] [github] mcpServers.github: Missing environment variables: GITHUB_PERSONAL_ACCESS_TOKEN
```

Výstup obsahoval i server ze sekce claude.ai, který pochází z uživatelského
účtu a není součástí úkolu.

Ověření v interaktivní relaci Claude Code 2.1.327 (podrobný záznam je v
[BEH_CLAUDE_CODE.md](BEH_CLAUDE_CODE.md)):

```text
/mcp: filesystem (16 nástrojů) a git (14 nástrojů) připojeny; github selhal
      kvůli chybějícímu GITHUB_PERSONAL_ACCESS_TOKEN
/agents: příkaz v této verzi neexistuje (průvodce byl odstraněn); dotazem na
         Clauda ověřeni 4 projektoví subagenti z .claude/agents/
Skills: dotazem na Clauda ověřeny 3 projektové Skills z .claude/skills/;
        Skill kontrola-pred-odevzdanim se načetl automaticky na prompt
        „Zkontroluj úkol před odevzdáním.“
```

## Co zatím není ověřeno

- CLI `codex` není v tomto Codespace nainstalované, takže jeho interaktivní
  příkazy, MCP seznam ani Codex subagenty nebylo možné ověřit.
- GitHub MCP vyžaduje `GITHUB_PERSONAL_ACCESS_TOKEN`; bez něj nelze ověřit
  připojení ke GitHubu.
- Automatický skript nekontroluje celou historii Gitu. Historii kontroluje
  subagent `security-auditor` přes MCP `git_log` a `git_show`; vedoucí agent
  může použít i `git log -p`.
