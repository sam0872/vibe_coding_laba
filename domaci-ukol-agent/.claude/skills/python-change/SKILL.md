---
name: python-change
description: Použij, když měníš nebo opravuješ Python soubor v tomto projektu (např. ukazka/). Zajistí malou, ověřenou změnu s testem.
---

## Kdy použít

Použij tento Skill při jakékoli změně nebo opravě Python souboru.

## Průběh

1. Přečti `CLAUDE.md`, příslušnou dokumentaci a změněné soubory.
2. Urči předpokládané vstupy, výstupy, chybové stavy a okrajové případy.
3. Ověř, že měníš jen soubory uvnitř domaci-ukol-agent.
4. Uprav co nejmenší souborový rozsah tak, aby odpovídal skutečné příčině.
5. Neukládej tajemství, OpenAI klíče ani GitHub tokeny do zdrojů nebo testů.
6. Spusť `python3 -m unittest discover -s ukazka -t . -v`; při selhání chybu
   nevykazuj jako opravenou.
7. Ve shrnutí uveď změněné soubory, použitý příkaz a skutečný výsledek.
8. Po změně předej diff subagentovi code-reviewer a ověření subagentovi
   test-runner.
