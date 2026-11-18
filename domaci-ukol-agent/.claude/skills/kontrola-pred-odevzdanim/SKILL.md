---
name: kontrola-pred-odevzdanim
description: >-
  Použij, když uživatel chce zkontrolovat úkol před odevzdáním nebo před
  pushem do veřejného repozitáře, ověřit celé nastavení agenta nebo říká
  "zkontroluj vše". Spustí čtyři subagenty paralelně a sloučí výsledky.
---

# Kontrola před odevzdáním

1. Spusť paralelně subagenty `code-reviewer`, `test-runner`,
   `security-auditor` a `docs-checker`.
2. Počkej na všechny výsledky.
3. Ověř každé tvrzení subagentů sám (soubor, řádek nebo výstup); nepřebírej je
   slepě.
4. Vrať jednu tabulku: Oblast | Subagent | Výsledek | Nalezené problémy |
   Doporučení.
5. Pokud `security-auditor` najde vysoké riziko, výslovně doporuč
   NEPUSHOVAT.
6. Nic neopravuj automaticky; opravy pouze navrhni.

Postupuj podle instrukcí v `CLAUDE.md`. V Claude Code spusť subagenty paralelně
nástrojem `Agent`.
