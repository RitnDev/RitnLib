---
title: Getting started with an AI, without knowing Lua
type: guide
lang: en
---

# Getting started with an AI, without knowing Lua

This page is for someone who wants to create a Factorio mod **without knowing how to program in Lua**, with
**Claude Code** as an assistant. The AI writes the code following the [Ritn mod conventions](mod-conventions.md),
tests it itself in the game thanks to **RitnTest**, reads the errors and fixes them. Your role: describe what you
want, start the test game, and look at the result.

## What you need

- **Factorio 2.x**. Recommended: a separate "portable" copy for the tests (zip version from the Factorio website),
  so your own games are not touched.
- **Claude Code** (https://claude.com/claude-code) and **Python 3** (used by the test tool).
- **Git**, to get the repositories.

## 1. Get the tools

```bash
git clone https://github.com/RitnDev/RitnLib
```

```bash
git clone https://github.com/RitnDev/RitnTest
```

RitnLib holds the kit (`ai/`): a mod skeleton and the rules for the AI. RitnTest lets the AI drive the game.

## 2. Create your mod from the skeleton

Open Claude Code in an empty folder, then ask it, for example:

> Create a new Factorio mod named "MyMod" from the kit `RitnLib/ai/` (skeleton `with-ritnlib`),
> following `RitnLib/ai/README.md`. Also install the skill `RitnTest/skills/factorio-mod-ritntest/`
> into `.claude/skills/`.

The AI copies the skeleton, renames it, adds `AGENTS.md` / `CLAUDE.md` and the skills. From then on, it knows the
conventions and how to test.

## 3. Prepare the test game (once)

Ask the AI to **set RitnTest up**: it will guide you. What it can't do for you:

1. **Close Factorio** while it sets RCON in `config.ini` (the game rewrites this file when it quits).
2. **Start Factorio**, then **Multiplayer → Host game** (testing only works in a hosted game). A new map is enough.
3. Tell it "the game is hosted".

## 4. Ask for a feature

Describe what you want, simply:

> Add a button to the mod window that shows the number of connected players.

The AI writes the code, then will probably ask you to **restart Factorio**: the game only reads the mod files at
start. Restart, host the game again, tell it: it tests, reads the errors and fixes them.

## 5. When it doesn't work

- **An error shows in the game**: copy it to the AI, or just tell it to look at `factorio-current.log`: it knows
  how to read it.
- **The mod doesn't load**: check in *Mods* that it is enabled, as well as RitnLib and RitnTest.
- **The AI says everything is fine but you see a problem**: describe what you see, or send a screenshot.

## Going further

- [Ritn mod conventions](mod-conventions.md): the rules the AI follows.
- The Factorio modding wiki (https://wiki.factorio.com/Modding) and the API documentation
  (https://lua-api.factorio.com/latest/): the basics (data stage, control stage, events, `storage`).

!!! warning "Security"
    RitnTest runs any code inside the tested mod: use it only in a local test game, **never on a public server**.
