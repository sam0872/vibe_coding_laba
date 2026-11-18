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
- nejméně čtyři Codex a čtyři Claude subagenty, jejich povinná metadata a
  shodu jejich názvů;
- u Claude subagentů, které v instrukcích zmiňují `diff`, přítomnost MCP git
  nástroje nebo `Bash`;
- front matter a shodu názvů Skills v obou adresářových stromech;
- nepřítomnost `.claude-plugin`, `.codex-plugin` a `marketplace.json`;
- nepřítomnost rozpoznatelných vzorů tajemství v projektových souborech;
- to, že `.env` a `settings.local.json` nejsou sledované Gitem;
- úspěch jednotkových testů ukázky kalkulačky.

### Automatické ověření - poslední běh

Zaznamenaný skutečný výstup posledního běhu. Příkazy byly spuštěny z kořene
`domaci-ukol-agent`:

```text
$ bash dokumentace/overeni.sh
OK: JSON, TOML a názvy MCP serverů jsou platné.
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

$ claude mcp list
Neověřeno: claude není v tomto Codespace nainstalován.
```

V Claude Code spusť `/mcp`, `/agents` a `/skills`; výsledky doplň sem:

```text
/mcp: Neověřeno: vyžaduje interaktivní relaci, doplní autor ručně
/agents: Neověřeno: vyžaduje interaktivní relaci, doplní autor ručně
/skills: Neověřeno: vyžaduje interaktivní relaci, doplní autor ručně
```

## Co zatím není ověřeno

- CLI `codex` a `claude` nejsou v tomto Codespace nainstalované, takže jejich
  interaktivní příkazy ani MCP seznamy nebylo možné ověřit.
- Ruční načtení MCP serverů, agentů a Skills v Claude Code není součástí
  automatického skriptu.
- GitHub MCP vyžaduje `GITHUB_PERSONAL_ACCESS_TOKEN`; bez něj nelze ověřit
  připojení ke GitHubu.
- Automatický skript nekontroluje celou historii Gitu. Kontrola historie se
  provádí samostatně příkazem `git log -p`.
