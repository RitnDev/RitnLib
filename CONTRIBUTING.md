# Contributing to RitnLib

Thanks for considering a contribution. This document covers the conventions a contributor needs to know before opening a PR.

For internal architecture context, read [`docs/architecture.md`](docs/architecture.md) first (FR).

---

## Scope of acceptable contributions

| Type | Status |
|---|---|
| Bug fixes (P0/P1 from [known-bugs.md](docs/en/debt/known-bugs.md)) | ✅ welcome |
| Factorio 2.0 / Space Age compatibility fixes | ✅ welcome |
| LuaLS annotations on existing classes | ✅ welcome |
| Documentation pages (FR or EN) | ✅ welcome |
| New utility helpers in `lualib/` | ⚠ discuss in an issue first |
| New classes (`RitnLib*` or `RitnProto*`) | ⚠ discuss in an issue first — affects API surface |
| Breaking changes to public API | ⚠ require an [ADR](docs/en/adr/) |

## Setup

1. Clone this repo into `Factorio/mods/RitnLib/` (or symlink).
2. Install the [Sumneko Lua Language Server](https://github.com/LuaLS/lua-language-server) extension in VS Code (or any LSP-compatible editor).
3. Install Factorio API definitions for LuaLS. Recommended: [JanSharp/FactorioSumnekoLuaPlugin](https://github.com/JanSharp/FactorioSumnekoLuaPlugin) or [FMTK](https://github.com/justarandomgeek/vscode-factoriomod-debug).
4. Open `.luarc.json` at repo root and update the `workspace.library` paths to point at your local definitions.
5. Verify with `lua-language-server --check .` if available.

## Code conventions

### General

- **Lua 5.2** (Factorio's runtime). Do not use Lua 5.3+ syntax (integer division `//`, etc.).
- **Indentation**: 4 spaces. No tabs.
- **End-of-file**: newline.
- **String quotes**: prefer `"double quotes"` for user-facing strings, `'single'` for keys when it improves readability.
- **No `print()` in shipped code** — use `log()` (Factorio's log function) for debug output.
- **No `game.players.Ritn` or any hardcoded player name** in shipped code.

### Naming

- **Runtime classes** registered in `_G`: `RitnLib<Type>` (e.g. `RitnLibPlayer`). Use globals only for these — everything else must be local + returned.
- **Data classes** returned by `require`: `RitnProto<Type>` (e.g. `RitnProtoRecipe`).
- **Methods**: `camelCase` (matching existing style). Don't introduce `snake_case` newly.
- **Private helpers** inside a module: local functions, no prefix.
- **Constants**: `UPPER_SNAKE_CASE` (e.g. `INVENTORY_SIZE_MAX`).

### LuaLS annotations

All new public methods must have LuaLS annotations. Format:

```lua
---Short description (English).
---@param paramName Type           Description.
---@param otherParam Type?         Optional parameter.
---@return Type                    What it returns.
---@return Type? secondReturn      Optional second return.
function ClassName:methodName(paramName, otherParam) ... end
```

For classes:

```lua
---@class RitnLibXxx : ParentClass
---@field fieldName Type           Description.
---@field isPresent boolean
RitnLibXxx = ritnlib.classFactory.newclass(function(self, ...) ... end)
```

See [`docs/en/contributing/luals-conventions.md`](docs/en/contributing/luals-conventions.md) for full details.

### Comments

- Annotations in **English** (interoperability with tooling).
- Free-form comments in **French** are accepted on lines adjacent to annotations, matching existing style.
- No multi-paragraph comment blocks — keep them tight.
- Don't add comments explaining what well-named code already says.

### Validation gates

Before submitting:

- Code must `require` cleanly with no nil-access errors.
- LuaLS reports 0 errors on touched files.
- A Factorio session loads the mod with no `log.txt` errors.
- If you fix a bug from `known-bugs.md`, mark it `fixed-in-X.Y.Z` in that file.

## Commit messages

Follow the existing style observed in `git log`:

```
0.x.y - <short summary>
```

Or for non-version-bump commits:

```
<short summary>
```

If your change closes an issue, add `closes #N` on its own line.

## Pull requests

PR description should include:

1. **What** is the change (1-3 sentences).
2. **Why** (link to issue, bug ID from `known-bugs.md`, or ADR).
3. **Affected files / classes**.
4. **Compatibility impact**: does this break existing consumers? Which ones?
5. **Testing**: how did you verify? (manual load? specific scenario?)

A PR is mergeable when:

- ✅ All review comments resolved.
- ✅ `info.json.version` is bumped if the change is shippable.
- ✅ `CHANGELOG.md` has an entry under the new version.
- ✅ Documentation pages affected by the change are updated.

## Versioning

RitnLib uses `MAJOR.MINOR.PATCH` (Factorio convention, not strict semver). The current policy:

- **PATCH** (`0.9.x → 0.9.y`): bug fixes, no API change.
- **MINOR** (`0.9.x → 0.10.0`): API additions, deprecations, internal refactors.
- **MAJOR** (`0.x.y → 1.0.0`): breaking API changes (requires an ADR).

For breaking changes, deprecate first (one MINOR cycle with warnings in `log()`), then remove in the next MINOR.

## Release flow

Releases are tag-driven (cf. [.github/workflows/release.yml](.github/workflows/release.yml)):

```bash
# 1. Bump info.json.version
# 2. Add ONE entry to changelog.txt (Factorio format — see below)
# 3. (Only for breaking changes) Add a migration note to CHANGELOG.md

git commit -m "0.10.0 - <summary>"
git tag 0.10.0
git push --tags
```

The workflow verifies `info.json.version == tag`, builds the zip, creates a GitHub release, and uploads to the Factorio Mod Portal.

### Changelog

The canonical changelog is [`changelog.txt`](changelog.txt) — read by Factorio and shown on the Mod Portal. Format is strict:

```
---------------------------------------------------------------------------------------------------
Version: X.Y.Z
Date: YYYY-MM-DD                  (optional but recommended)
  Changes:                        (or: Features / Bugfixes / Optimisations / Modding / Scripting / Other)
    - Free-form sentence describing the change.
```

The separator is exactly **99 `-` characters**. Indentation is **2 spaces** for category names, **4 spaces** + `- ` for entries.

[`CHANGELOG.md`](CHANGELOG.md) only receives entries when a release **breaks API** and needs a migration guide (more text than the Factorio format comfortably holds). For routine bug-fix or feature releases, `CHANGELOG.md` is **not** updated.

## Documentation contributions

- Documentation lives in `docs/{fr,en}/`. Most pages exist in both languages.
- If you add a page to `docs/fr/`, add the EN counterpart in the **same PR**.
- Templates for each page type are described in [`docs/en/contributing/doc-templates.md`](docs/en/contributing/doc-templates.md).
- Links to source code must point at a pinned version tag, not `main` (e.g. `…/blob/0.9.8/path#L42`).

## Questions

Open an issue with the `question` label or contact [@RitnDev](https://github.com/RitnDev) directly.
