# Domácí úkol: nastavení kódovacího agenta

## Odevzdání

https://github.com/sam0872/vibe_coding_laba/tree/main/domaci-ukol-agent

Tato složka je samostatné vypracování domácího úkolu o nastavení kódovacích
agentů **Codex** a **Claude Code**.

Vypracování využívá:

- projektové instrukce,
- tři MCP servery,
- tři Skills,
- čtyři subagenty pro každého agenta.

Používá pouze soubory přímo v tomto projektu. **Nepoužívá plugins ani
marketplace.**

## Struktura

```text
domaci-ukol-agent/
├── .gitignore
├── README.md
├── AGENTS.md
├── .agents/skills/                 # tři Skills pro Codex
├── .claude/
│   ├── CLAUDE.md
│   ├── settings.json
│   ├── agents/                     # čtyři subagenti pro Claude Code
│   └── skills/                     # tři Skills pro Claude Code
├── .codex/
│   ├── config.toml
│   └── agents/                     # čtyři subagenti pro Codex
├── .mcp.json
├── ukazka/
│   ├── __init__.py
│   ├── kalkulacka.py
│   └── test_kalkulacka.py
└── dokumentace/
    ├── BEH_CLAUDE_CODE.md
    ├── NAVOD.md
    ├── OVERENI.md
    ├── POROVNANI.md
    └── overeni.sh
```

## Co bylo nastaveno

### MCP servery

Jsou připravené tři MCP servery:

1. **filesystem** — omezené čtení a zápis souborů projektu.
2. **git** — stav, diff a historie repozitáře.
3. **github** — issue, pull requesty a GitHub Actions.

GitHub přístup je oddělený od OpenAI API klíče a token se předává pouze
prostřednictvím environment proměnné.

### Ukázka Pythonu

Složka `ukazka/` obsahuje funkce pro dělení a výpočet průměru včetně testů
standardní knihovnou `unittest`.

### Skills

Skills jsou `python-change`, `code-review` a `kontrola-pred-odevzdanim`.
Všechny jsou udržovány v odpovídajících složkách pro Codex i Claude Code.

### Subagenti

Čtyři role jsou `code-reviewer`, `test-runner`, `security-auditor` a
`docs-checker`. Codex má nativní TOML definice a Claude Code nativní
Markdown definice.

## Splnění zadání

| Požadavek | Implementace | Důkaz |
|---|---|---|
| Instrukce pro Codex | Projektový `AGENTS.md` | [AGENTS.md](AGENTS.md) |
| Instrukce pro Claude Code | Projektový `.claude/CLAUDE.md` | [.claude/CLAUDE.md](.claude/CLAUDE.md) |
| MCP pro Codex | Filesystem, Git a GitHub MCP server | [.codex/config.toml](.codex/config.toml) |
| MCP pro Claude Code | Filesystem, Git a GitHub MCP server | [.mcp.json](.mcp.json) |
| Skills pro Codex | Tři Skills | [.agents/skills/](.agents/skills/) |
| Skills pro Claude Code | Tři Skills | [.claude/skills/](.claude/skills/) |
| Codex subagenti | Čtyři subagenti s omezenými oprávněními | [.codex/agents/](.codex/agents/) |
| Claude subagenti | Čtyři subagenti s omezenými nástroji | [.claude/agents/](.claude/agents/) |
| Ukázkový Python kód a testy | `unittest` pro běžné i chybové stavy | [ukazka/](ukazka/) |
| Nastavení oprávnění Claude Code | Projektový `settings.json` | [.claude/settings.json](.claude/settings.json) |
| Ignorování lokálních souborů | `.gitignore` v této složce a v kořeni repozitáře | [.gitignore](.gitignore) |
| Bezpečnost | Environment proměnné, kontroly tajemství | [dokumentace/OVERENI.md](dokumentace/OVERENI.md) |
| Bez plugins a marketplace | Žádné pluginy ani marketplace | [dokumentace/POROVNANI.md](dokumentace/POROVNANI.md) |
| Skutečný běh Claude Code | Záznam relace | [dokumentace/BEH_CLAUDE_CODE.md](dokumentace/BEH_CLAUDE_CODE.md) |

## Navržený pracovní postup

1. Vedoucí agent přečte projektové instrukce.
2. MCP filesystem pracuje pouze uvnitř této složky.
3. MCP git pracuje pouze s repozitářem `vibe_coding_laba`.
4. GitHub MCP se použije jen při explicitním GitHub úkolu.
5. Skill `python-change` vede malou změnu Python kódu a její ověření.
6. Subagent `code-reviewer` kontroluje diff a `test-runner` spouští testy;
   vedoucí agent jejich výsledky ověří a shrne.
7. Před odevzdáním Skill `kontrola-pred-odevzdanim` koordinuje všechny čtyři
   subagenty.

## Rychlý návod

Podrobný postup najdeš v [dokumentace/NAVOD.md](dokumentace/NAVOD.md).

Nejmenší relevantní ověření Python změny:

```bash
python3 -m unittest discover -s ukazka -t . -v
```

Úplné automatické ověření:

```bash
bash dokumentace/overeni.sh
```

## Bezpečnost

- Necommituj `.env`, API klíče ani osobní přístupové tokeny.
- `OPENAI_API_KEY` se nastaví jen jako environment proměnná.
- `GITHUB_PERSONAL_ACCESS_TOKEN` se nastaví jen jako environment proměnná.
- MCP server `filesystem` musí mít zadaný kořen této složky.
