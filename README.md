# vibe_coding_laba

Ukázkový Python skript pro volání LLM API s nástrojem (function calling).
Model může zavolat vestavěnou kalkulačku a následně použít její výsledek ve
své odpovědi.

## Co budeš potřebovat

- Python 3.9 nebo novější
- OpenAI API klíč a aktivní API billing
- Terminál (můžeš použít terminál ve VS Code: **Terminal → New Terminal**)

> **Pozor:** ChatGPT Plus/Pro předplatné a OpenAI API jsou samostatné služby.
> API volání může být zpoplatněné podle využití. Informace o fakturaci najdeš
> na [platform.openai.com/settings/organization/billing](https://platform.openai.com/settings/organization/billing).

## 1. Vytvoř si API klíč

1. Přihlas se nebo si vytvoř účet na [platform.openai.com](https://platform.openai.com/).
2. Otevři stránku [API keys](https://platform.openai.com/api-keys).
3. Klikni na **Create new secret key**, pojmenuj klíč a potvrď vytvoření.
4. Klíč si hned zkopíruj a bezpečně ulož — celý se zobrazí jen při vytvoření.
   Pokud ho ztratíš, vytvoř nový.

Klíč nikomu neposílej, nevkládej ho do zdrojového kódu ani do GitHubu.
Pokud se omylem zveřejní, zruš ho na stránce API keys a vytvoř nový.

## 2. Otevři složku projektu a nainstaluj závislost

V terminálu přejdi do složky, ve které je `main.py`, `README.md` a
`requirements.txt`. Pokud máš projekt otevřený ve VS Code, nový terminál
obvykle otevře přímo ve správné složce. Potom spusť:

```bash
python -m pip install -r requirements.txt
```

Na macOS/Linux případně použij `python3` místo `python`. Ve Windows můžeš
použít také `py -m pip install -r requirements.txt`.

## 3. Nastav klíč a spusť skript

Zadávej příkazy přímo do terminálu. Klíč se nastaví jen pro
aktuální terminálovou relaci; skript ho nezapisuje do README ani do souborů
projektu. Klíč nevkládej přímo do příkazu jako text — terminál může příkazy
ukládat do historie.

V GitHub Codespaces otevři **Terminal → New Terminal**. Pokud používáš Bash
(obvykle výchozí), spusť první příkaz, vlož klíč až po zobrazení kurzoru
terminálu a stiskni Enter. Při psaní se klíč nebude zobrazovat:

```bash
read -s OPENAI_API_KEY
```

Potom spusť:

```bash
export OPENAI_API_KEY
python main.py "Kolik je 123 krát 456?"
```

Na macOS/Linux se stejným Bashem můžeš postupovat stejně. Pokud používáš
PowerShell ve Windows, zadej:

**Windows (PowerShell):**

```powershell
$secureKey = Read-Host "Vlož OpenAI API klíč" -AsSecureString
$env:OPENAI_API_KEY = [System.Net.NetworkCredential]::new("", $secureKey).Password
python main.py "Kolik je 123 krát 456?"
```

Příkaz vypíše odpověď modelu. Po zavření terminálu se klíč z prostředí
odstraní; při novém spuštění ho nastav znovu.

## Výběr modelu (volitelné)

Ve výchozím nastavení skript používá `gpt-4o-mini`. Jiný model můžeš zvolit
proměnnou `OPENAI_MODEL`, pokud ho tvůj účet a API zpřístupňují:

**PowerShell:**

```powershell
$env:OPENAI_MODEL = "gpt-4o-mini"
```

**macOS/Linux:**

```bash
export OPENAI_MODEL="gpt-4o-mini"
```

## Řešení potíží

- **`Nastavte proměnnou prostředí OPENAI_API_KEY.`** — nastav klíč v tom samém
  terminálovém okně, ze kterého spouštíš skript.
- **Chyba autentizace / `Incorrect API key`** — zkontroluj, že jsi klíč
  zkopíroval celý a bez mezer, případně vytvoř nový.
- **Chyba kvóty nebo billing** — zkontroluj API billing a limity svého účtu;
  ChatGPT předplatné API kredit nenahrazuje.
- **`python` nebyl nalezen** — nainstaluj Python a zkus `python3` (macOS/Linux)
  nebo `py` (Windows).

Skript používá nástroj `calculate` pro sčítání, odčítání, násobení a dělení.
