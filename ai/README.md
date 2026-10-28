# Kit IA — conventions des mods Ritn / AI kit — Ritn mod conventions

FR : Tout ce qu'il faut pour qu'un moddeur, et l'IA avec laquelle il travaille, écrive un mod Factorio qui suit
les conventions des mods Ritn dès la première ligne (structure, commentaires FR + EN, annotations LuaLS).  
EN : Everything a modder, and the AI they work with, needs to write a Factorio mod that follows the Ritn mod
conventions from the first line (structure, FR + EN comments, LuaLS annotations).

Guide complet / Full guide : https://ritndev.github.io/RitnLib/guides/mod-conventions/

## Contenu / Content

| Fichier / File | Rôle / Role |
|---|---|
| `AGENTS.md` | FR : règles pour l'IA, à copier à la racine du mod (lu par Codex, Cursor, Copilot…).  <br>EN : rules for the AI, to copy to the mod root (read by Codex, Cursor, Copilot…). |
| `CLAUDE.md` | FR : même chose pour Claude Code (importe `AGENTS.md`).  <br>EN : same for Claude Code (imports `AGENTS.md`). |
| `skills/ritn-mod-conventions/` | FR : skill Claude Code, à copier dans `.claude/skills/` du projet (ou `~/.claude/skills/`).  <br>EN : Claude Code skill, to copy into the project `.claude/skills/` (or `~/.claude/skills/`). |
| `template/with-ritnlib/` | FR : squelette de mod qui dépend de RitnLib.  <br>EN : mod skeleton depending on RitnLib. |
| `template/standalone/` | FR : squelette de mod autonome (classes de base copiées de gvv).  <br>EN : standalone mod skeleton (base classes copied from gvv). |

## Démarrer un nouveau mod / Start a new mod

1. FR : Copier `template/with-ritnlib/` (ou `standalone/`) sous le nom du mod.  
   EN : Copy `template/with-ritnlib/` (or `standalone/`) under the mod name.
2. FR : Remplacer partout `MyMod`, `mymod` et `__MyMod__` par le nom du mod (fichiers **et** noms de fichiers :
   `classes/MyMod*.lua`, `locale/*/mymod.cfg`, `types/mymod-globals.lua`).  
   EN : Replace `MyMod`, `mymod` and `__MyMod__` everywhere with the mod name (contents **and** file names:
   `classes/MyMod*.lua`, `locale/*/mymod.cfg`, `types/mymod-globals.lua`).
3. FR : Copier `AGENTS.md` et `CLAUDE.md` à la racine du mod, et (Claude Code) `skills/ritn-mod-conventions/` dans
   `.claude/skills/`.  
   EN : Copy `AGENTS.md` and `CLAUDE.md` to the mod root, and (Claude Code) `skills/ritn-mod-conventions/` into
   `.claude/skills/`.
4. FR : Le squelette contient une fenêtre d'exemple (Ctrl+Maj+M) : la garder comme modèle ou la remplacer.  
   EN : The skeleton has an example window (Ctrl+Shift+M): keep it as a model or replace it.

## Mod existant / Existing mod

FR : Copier seulement `AGENTS.md`, `CLAUDE.md` et la skill ; l'IA alignera le nouveau code sur les conventions.
Pour mettre à niveau du code ancien, les skills d'audit et d'annotation de Ritn restent utiles.  
EN : Copy only `AGENTS.md`, `CLAUDE.md` and the skill; the AI aligns the new code with the conventions.
To upgrade old code, Ritn's audit and annotation skills are still useful.
