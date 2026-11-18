# Porovnání s učebním repozitářem

Porovnání vychází ze složek `02_Codex` a `04_Claude_Code` soukromého repozitáře
`Global-Classes-CZE/vico-rdcz-3` (lektorovy soubory nejsou součástí tohoto
veřejného repozitáře).

## Společné prvky

| Oblast | Vzorová struktura | Toto vypracování |
|---|---|---|
| Instrukce pro Codex | `AGENTS.md` | `AGENTS.md` |
| Instrukce pro Claude | `.claude/CLAUDE.md` | `.claude/CLAUDE.md` |
| MCP pro Claude | `.mcp.json` | `.mcp.json` |
| MCP pro Codex | `.codex/config.toml` | `.codex/config.toml` |
| Codex Skills | `.agents/skills/<název>/SKILL.md` | `.agents/skills/<název>/SKILL.md` |
| Claude Skills | `.claude/skills/<název>/SKILL.md` | `.claude/skills/<název>/SKILL.md` |
| Claude subagent | `.claude/agents/<název>.md` | `.claude/agents/<název>.md` |
| Codex subagent | `.codex/agents/<název>.toml` | `.codex/agents/<název>.toml` |

## Rozsah a bezpečnostní odchylky

Vypracování pokrývá MCP servery, Skills, subagenty a instrukce pro oba
kódovací agenty. Není kompletní kopií kurzu; žádné lektorovy soubory nejsou
součástí tohoto veřejného repozitáře.

Úkol vědomě nekopíruje lektorovo `approval_policy = "never"` spolu se
`sandbox_mode = "danger-full-access"` ani natvrdo zapsaný API klíč z lekce
`02_mcp`. Klíč zde není uveden ani částečně. Místo toho jsou použita
omezenější oprávnění a předávání tokenu přes environment proměnnou.

Projekt nepřidává hooks, custom models, observability, plugins ani marketplace,
protože tyto oblasti nejsou součástí požadovaného rozsahu.
