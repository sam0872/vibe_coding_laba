# Instrukce pro Codex

## Účel projektu

Pracuješ na samostatném vypracování nastavení kódovacího agenta. Primárním
výstupem nejsou běhové funkce, ale ověřitelná konfigurace, instrukce, Skills
a subagenti pro Codex a Claude Code.

## Pravidla

- Odpovídej česky.
- Před změnou přečti soubory této složky.
- Změny prováděj pouze v aktuální složce a souvisejících souborech.
- Nezapisuj tajemství do souborů ani do ukázkových příkazů.
- Zachovej oddělení OpenAI klíče a GitHub tokenu.
- Nepoužívej plugins ani marketplace.
- Preferuj malé a přesné změny.
- Po změně ověř výsledky příslušným ověřovacím příkazem.
- Nejmenší relevantní ověření Python změny:
  `python3 -m unittest discover -s ukazka -t . -v`
- Repozitář je veřejný. Před každým commitem a pushem použij Skill
  `kontrola-pred-odevzdanim` a necommituj, pokud security-auditor hlásí vysoké
  riziko.

## MCP servery

Používej MCP servery jen podle účelu:

- `filesystem` — čtení a zápis souborů v této složce.
- `git` — stav, diff a historie repozitáře.
- `github` — GitHub issue, pull requesty a Actions.

Nezískávej tajemství přes MCP. Pokud server nebo token není dostupný, uveď
omezení výslovně a nepředstírej jeho funkčnost.

## Skills

Při změně Python kódu použij:

- `.agents/skills/python-change/SKILL.md`

Před odevzdáním proveď kontrolu s pomocí:

- `.agents/skills/code-review/SKILL.md`
- `.agents/skills/kontrola-pred-odevzdanim/SKILL.md`

## Subagenti

Subagenti jsou definováni ve složce `.codex/agents/`:

- `code-reviewer` (`read-only`) prověřuje diff na potvrditelné problémy.
- `test-runner` (`workspace-write`) smí spouštět ověření, ale nesmí upravovat
  zdrojové soubory, testy ani konfiguraci.
- `security-auditor` (`read-only`) kontroluje tajemství, historii, rozsah MCP,
  cizí soubory a oprávnění.
- `docs-checker` (`read-only`) porovnává dokumentaci se skutečným stavem projektu.

Vedoucí agent integruje jejich výsledky a finální rozhodnutí přijme sám.

## Příklad toku práce

Instrukce → Skill `python-change` → MCP git (diff) → subagenti `code-reviewer`
a `test-runner` → vedoucí agent ověří tvrzení a shrne výsledek.
Subagent `code-reviewer` má v `.codex/agents/code-reviewer.toml` výslovnou
instrukci číst diff přes MCP git, tedy využívá MCP. V Codexu to zatím nebylo
ověřeno spuštěním (codex není v tomto Codespace nainstalován).
