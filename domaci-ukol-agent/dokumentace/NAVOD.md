# Návod na spuštění a použití nastavení

## Příprava prostředí

Potřebuješ Node.js s příkazem `npx`, Python 3.11 nebo novější
(ověřovací skript používá `tomllib`) a uv s příkazem `uvx`.
Pokud příkaz `uvx` chybí, uv nainstaluj:

```bash
python3 -m pip install --user uv
```
Nejmenší relevantní ověření Python změny je:

```bash
python3 -m unittest discover -s ukazka -t . -v
```

## Spuštění v GitHub Codespaces

Codex i Claude Code spusť z kořene této úlohy:

```bash
cd /workspaces/vibe_coding_laba/domaci-ukol-agent
codex
```

Pro Claude Code použij stejnou složku a příkaz:

```bash
cd /workspaces/vibe_coding_laba/domaci-ukol-agent
claude
```

Codex načte projektový `.codex/config.toml` jen u důvěryhodného (trusted)
projektu. Při prvním spuštění projekt označ jako trusted. Codex načítá
`.codex/config.toml` a `AGENTS.md` ze složky, ve které se spustí. Claude Code
načítá `.claude/` a `.mcp.json` ze složky, ve které se spustí.

Pokud Codex hlásí neznámý feature flag, ověř dostupné funkce příkazem:

```bash
codex features list
```

## Spuštění mimo GitHub Codespaces

```bash
git clone https://github.com/sam0872/vibe_coding_laba.git
cd vibe_coding_laba/domaci-ukol-agent
```

V `.codex/config.toml` a `.mcp.json` nahraď absolutní cesty
`/workspaces/vibe_coding_laba` skutečnou cestou ke klonu. U MCP filesystem
nastav kořen této složky a u MCP git kořen repozitáře.

## Codex

Skills:

- `.agents/skills/python-change/SKILL.md`
- `.agents/skills/code-review/SKILL.md`
- `.agents/skills/kontrola-pred-odevzdanim/SKILL.md`

Subagenti jsou v `.codex/agents/`: `code-reviewer`, `test-runner`,
`security-auditor` a `docs-checker`.

Ukázkový prompt:

```text
Použij $kontrola-pred-odevzdanim.
```

## Claude Code

Claude Code načítá konfiguraci MCP z `.mcp.json` a nastavení oprávnění z
`.claude/settings.json`. Subagenti jsou v `.claude/agents/`, Skills v
`.claude/skills/`.

GitHub MCP a `git push` jsou záměrně v `ask`, protože jde o zápis do veřejné
vzdálené služby. Lokální osobní nastavení patří do
`.claude/settings.local.json`, který se necommituje.

Ukázkové prompty:

```text
Zkontroluj úkol před odevzdáním.
```

Tento požadavek má spustit Skill `kontrola-pred-odevzdanim`.

```text
Uprav funkci prumer v ukazka/kalkulacka.py tak, aby ignorovala hodnoty None.
```

Tento požadavek má spustit Skill `python-change`.

## MCP servery a tajemství

| Server | Účel | Omezení |
|---|---|---|
| filesystem | Čtení a zápis souborů | Pouze tato složka |
| git | Stav, diff a historie | Pouze cílový repozitář |
| github | Issue, PR a Actions | Token pouze v environment proměnné |

GitHub token ani OpenAI klíč nikdy nezapisuj do souborů projektu ani do
ukázkových příkazů. Pokud token není dostupný, GitHub MCP nelze ověřit;
nepředstírej jeho funkčnost. Nepublikuj tajné hodnoty do souboru, promptu ani
commitu.
