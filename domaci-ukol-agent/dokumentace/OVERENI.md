# Ověření nastavení

## Automatické ověření

Ze složky `domaci-ukol-agent` spusť:

```bash
bash dokumentace/overeni.sh
```

Skript ověřuje:

- existenci základních souborů konfigurace a instrukcí;
- syntaxi `.mcp.json`, `.claude/settings.json` a TOML konfigurací Codexu;
- shodu názvů MCP serverů mezi `.mcp.json` a `.claude/settings.json`;
- nejméně čtyři Codex a čtyři Claude subagenty, jejich povinná metadata a
  shodu jejich názvů;
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
Ran 4 tests in 0.001s

OK
OK: automatické ověření dokončeno.

$ python3 -m unittest discover -s ukazka -t . -v
test_prumer_bezne_hodnoty (ukazka.test_kalkulacka.TestKalkulacka.test_prumer_bezne_hodnoty) ... ok
test_prumer_prazdneho_seznamu (ukazka.test_kalkulacka.TestKalkulacka.test_prumer_prazdneho_seznamu) ... ok
test_vydel_bezne_hodnoty (ukazka.test_kalkulacka.TestKalkulacka.test_vydel_bezne_hodnoty) ... ok
test_vydel_nulou (ukazka.test_kalkulacka.TestKalkulacka.test_vydel_nulou) ... ok

----------------------------------------------------------------------
Ran 4 tests in 0.000s

OK
```

## Nejmenší relevantní ověření Python změny

```bash
python3 -m unittest discover -s ukazka -t . -v
```

## Ruční ověření v agentech

Spusť v terminálu z této složky a doplň skutečný výstup:

```text
$ codex mcp list
[výstup doplnit]

$ codex features list
[výstup doplnit]

$ claude mcp list
[výstup doplnit]
```

V Claude Code spusť `/mcp`, `/agents` a `/skills`; výsledky doplň sem:

```text
/mcp: [výstup doplnit]
/agents: [výstup doplnit]
/skills: [výstup doplnit]
```

## Co zatím není ověřeno

- Ruční načtení MCP serverů, agentů a Skills v běžících aplikacích Codex a
  Claude Code není součástí automatického skriptu.
- GitHub MCP vyžaduje `GITHUB_PERSONAL_ACCESS_TOKEN`; bez něj nelze ověřit
  připojení ke GitHubu.
- Automatický skript nekontroluje celou historii Gitu. Kontrola historie se
  provádí samostatně příkazem `git log -p`.
