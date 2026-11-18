#!/usr/bin/env bash
set -euo pipefail

SLOZKA="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$SLOZKA"

python3 - <<'PY'
import json
import re
import subprocess
import sys
from pathlib import Path


def chyba(zprava: str) -> None:
    raise SystemExit(f"CHYBA: {zprava}")


if sys.version_info < (3, 11):
    chyba(
        "Je vyžadován Python 3.11 nebo novější "
        "(ověřovací skript používá tomllib)."
    )

import tomllib


def pozaduj(podminka: bool, zprava: str) -> None:
    if not podminka:
        chyba(zprava)


def nacti_json(cesta: Path) -> dict:
    try:
        return json.loads(cesta.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as chyba_json:
        chyba(f"Soubor {cesta} není platný JSON: {chyba_json}")


def nacti_toml(cesta: Path) -> dict:
    try:
        with cesta.open("rb") as soubor:
            return tomllib.load(soubor)
    except (OSError, tomllib.TOMLDecodeError) as chyba_toml:
        chyba(f"Soubor {cesta} není platný TOML: {chyba_toml}")


def front_matter(cesta: Path) -> tuple[dict[str, str], str]:
    try:
        text = cesta.read_text(encoding="utf-8")
    except OSError as chyba_souboru:
        chyba(f"Nelze přečíst {cesta}: {chyba_souboru}")
    if not text.startswith("---\n"):
        chyba(f"{cesta}: chybí YAML front matter.")
    casti = text.split("---\n", 2)
    if len(casti) < 3:
        chyba(f"{cesta}: YAML front matter není ukončen.")
    pole: dict[str, str] = {}
    for radek in casti[1].splitlines():
        shoda = re.match(r"^([A-Za-z_][A-Za-z0-9_]*):(?:\s*(.*))?$", radek)
        if shoda:
            pole[shoda.group(1)] = shoda.group(2) or ""
    return pole, text


for cesta in (
    Path("README.md"),
    Path("AGENTS.md"),
    Path(".claude/CLAUDE.md"),
    Path(".claude/settings.json"),
    Path(".codex/config.toml"),
    Path(".mcp.json"),
    Path("dokumentace/BEH_CLAUDE_CODE.md"),
    Path("dokumentace/NAVOD.md"),
    Path("dokumentace/OVERENI.md"),
    Path("dokumentace/POROVNANI.md"),
    Path("ukazka/__init__.py"),
    Path("ukazka/kalkulacka.py"),
    Path("ukazka/test_kalkulacka.py"),
):
    pozaduj(cesta.is_file(), f"Chybí povinný soubor {cesta}.")

claude_nastaveni = nacti_json(Path(".claude/settings.json"))
mcp_json = nacti_json(Path(".mcp.json"))
mcp_codex = nacti_toml(Path(".codex/config.toml"))

pozaduj(
    set(mcp_codex.get("mcp_servers", {})) == set(mcp_json.get("mcpServers", {})),
    "Názvy MCP serverů v Codexu a Claude Code se neshodují.",
)
pozaduj(
    set(claude_nastaveni.get("enabledMcpjsonServers", []))
    == set(mcp_json.get("mcpServers", {})),
    "Servery v .claude/settings.json neodpovídají serverům v .mcp.json.",
)
pozaduj(
    set(mcp_json.get("mcpServers", {})) == {"filesystem", "git", "github"},
    ".mcp.json musí obsahovat servery filesystem, git a github.",
)
pozaduj(
    mcp_json["mcpServers"]["github"].get("headers", {}).get("Authorization")
    == "Bearer ${GITHUB_PERSONAL_ACCESS_TOKEN}",
    "GitHub token v .mcp.json musí být předáván přes environment proměnnou.",
)
pozaduj(
    mcp_codex.get("mcp_servers", {}).get("github", {}).get("bearer_token_env_var")
    == "GITHUB_PERSONAL_ACCESS_TOKEN",
    "GitHub token v Codexu musí být předáván přes environment proměnnou.",
)
print("OK: JSON, TOML a názvy MCP serverů jsou platné.")

opravneni = claude_nastaveni.get("permissions", {})
povoleno = set(opravneni.get("allow", []))
dotaz = set(opravneni.get("ask", []))
pozaduj(
    "mcp__git" not in povoleno,
    ".claude/settings.json: allow nesmí povolovat celý server \"mcp__git\"; "
    "vyjmenuj jen čtecí nástroje.",
)
pozaduj(
    "mcp__filesystem" not in povoleno,
    ".claude/settings.json: allow nesmí povolovat celý server \"mcp__filesystem\"; "
    "vyjmenuj jen nástroje bez čtení obsahu a zápisu.",
)
for nastroj in (
    "git_add",
    "git_commit",
    "git_reset",
    "git_checkout",
    "git_create_branch",
):
    nazev = f"mcp__git__{nastroj}"
    pozaduj(nazev not in povoleno, f".claude/settings.json: {nazev} nesmí být v allow.")
    pozaduj(nazev in dotaz, f".claude/settings.json: {nazev} musí být v ask.")
print("OK: zapisovací nástroje MCP git nejsou předschválené a jsou v ask.")

codex_soubory = sorted(Path(".codex/agents").glob("*.toml"))
claude_soubory = sorted(Path(".claude/agents").glob("*.md"))
pozaduj(len(codex_soubory) >= 4, "V .codex/agents/ musí být alespoň čtyři agenti.")
pozaduj(len(claude_soubory) >= 4, "V .claude/agents/ musí být alespoň čtyři agenti.")

codex_jmena: set[str] = set()
for cesta in codex_soubory:
    agent = nacti_toml(cesta)
    for pole in (
        "name",
        "description",
        "developer_instructions",
        "sandbox_mode",
        "model",
        "model_reasoning_effort",
    ):
        pozaduj(pole in agent, f"{cesta}: chybí povinné pole {pole}.")
    pozaduj(
        agent["sandbox_mode"] in {"read-only", "workspace-write"},
        f"{cesta}: nepovolený sandbox_mode.",
    )
    pozaduj(agent["name"] not in codex_jmena, f"Duplicitní jméno agenta {agent['name']}.")
    codex_jmena.add(agent["name"])

claude_jmena: set[str] = set()
for cesta in claude_soubory:
    pole, text = front_matter(cesta)
    for povinne in ("name", "description", "tools", "model"):
        pozaduj(pole.get(povinne), f"{cesta}: front matter nemá {povinne}.")
    pozaduj(pole["name"] not in claude_jmena, f"Duplicitní jméno agenta {pole['name']}.")
    claude_jmena.add(pole["name"])
    if "diff" in text.lower():
        tools = {nazev.strip() for nazev in pole["tools"].split(",")}
        ma_git_mcp = any(nazev.startswith("mcp__git__") for nazev in tools)
        pozaduj(
            ma_git_mcp or "Bash" in tools,
            f"{cesta}: instrukce zmiňující diff musí povolit MCP git nebo Bash.",
        )
    if "git log -p" in text:
        tools = {nazev.strip() for nazev in pole["tools"].split(",")}
        pozaduj(
            "Bash" in tools,
            f"{cesta}: instrukce vyžaduje `git log -p`, ale subagent nemá Bash.",
        )

pozaduj(
    codex_jmena == claude_jmena,
    "Názvy Codex a Claude subagentů se neshodují.",
)
print("OK: čtyři nebo více subagentů mají povinná metadata a odpovídající protějšky.")

skill_jmena: dict[str, set[str]] = {}
for slozka in (".agents/skills", ".claude/skills"):
    cesty = sorted(Path(slozka).rglob("SKILL.md"))
    pozaduj(cesty, f"Ve složce {slozka} nebyl nalezen žádný SKILL.md.")
    jmena: set[str] = set()
    for cesta in cesty:
        pole, _ = front_matter(cesta)
        for povinne in ("name", "description"):
            pozaduj(pole.get(povinne), f"{cesta}: front matter nemá {povinne}.")
        pozaduj(pole["name"] not in jmena, f"Duplicitní Skill {pole['name']} v {slozka}.")
        jmena.add(pole["name"])
    skill_jmena[slozka] = jmena

pozaduj(
    skill_jmena[".agents/skills"] == skill_jmena[".claude/skills"],
    "Názvy Skills v .agents/skills a .claude/skills se neshodují.",
)
print("OK: front matter Skills je platný a obě sady názvů jsou stejné.")

zakazane_nazvy = {".claude-plugin", ".codex-plugin", "marketplace.json"}
zakazane_cesty = [
    cesta
    for cesta in Path(".").rglob("*")
    if ".git" not in cesta.parts and cesta.name in zakazane_nazvy
]
pozaduj(
    not zakazane_cesty,
    "Byly nalezeny zakázané soubory nebo složky: "
    + ", ".join(str(cesta) for cesta in zakazane_cesty),
)

vzory_tajemstvi = (
    re.compile(r"\bsk-[A-Za-z0-9_-]{20,}\b"),
    re.compile(r"\bsk-" + r"ant-[A-Za-z0-9_-]{20,}\b"),
    re.compile(r"\bghp_[A-Za-z0-9]{20,}\b"),
    re.compile(r"\bgithub" + r"_pat_[A-Za-z0-9_]{20,}\b"),
    re.compile(r"\btvly-[A-Za-z0-9]{10,}\b"),
)
nalezena_tajemstvi: list[str] = []
for cesta in Path(".").rglob("*"):
    if not cesta.is_file() or ".git" in cesta.parts or cesta == Path("dokumentace/overeni.sh"):
        continue
    obsah = cesta.read_bytes()
    if b"\0" in obsah:
        continue
    text = obsah.decode("utf-8", errors="replace")
    for cislo, radek in enumerate(text.splitlines(), start=1):
        if any(vzor.search(radek) for vzor in vzory_tajemstvi):
            nalezena_tajemstvi.append(f"{cesta}:{cislo}")
pozaduj(
    not nalezena_tajemstvi,
    "Možné tajemství nalezeno na místech: " + ", ".join(nalezena_tajemstvi),
)

try:
    sledovane = subprocess.run(
        ["git", "ls-files"],
        check=True,
        capture_output=True,
        text=True,
    ).stdout.splitlines()
except (OSError, subprocess.CalledProcessError) as chyba_gitu:
    chyba(f"Nelze ověřit sledované soubory Gitem: {chyba_gitu}")
vzory_sledovanych_tajemstvi = re.compile(r"(^|/)\.env$|settings\.local\.json")
zakazane_sledovane = [
    cesta for cesta in sledovane if vzory_sledovanych_tajemstvi.search(cesta)
]
pozaduj(
    not zakazane_sledovane,
    "Git sleduje zakázané lokální soubory: " + ", ".join(zakazane_sledovane),
)
try:
    koren_repozitare = subprocess.run(
        ["git", "rev-parse", "--show-toplevel"],
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()
except (OSError, subprocess.CalledProcessError) as chyba_gitu:
    chyba(f"Nelze zjistit kořen repozitáře: {chyba_gitu}")
ignorovano = subprocess.run(
    ["git", "check-ignore", "-q", ".env"],
    cwd=koren_repozitare,
)
pozaduj(
    ignorovano.returncode == 0,
    "Soubor .env v kořeni repozitáře není ignorovaný (chybí kořenový .gitignore).",
)
print("OK: nejsou nalezeny zakázané pluginy, rozpoznatelná tajemství ani sledované lokální soubory.")
PY

python3 -m unittest discover -s ukazka -t .
echo "OK: automatické ověření dokončeno."
