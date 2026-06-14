---
title: Architecture Decision Records (ADR)
type: adr
lang: en
---

# Architecture Decision Records (ADR)

🇫🇷 [Version française](../../fr/adr/README.md)

An **ADR** (*Architecture Decision Record*) captures a significant architecture decision: its **context**, the **decision** made, and its **consequences**. The goal is to keep a trace of the *why* — not just the *how* — for maintainers and contributors.

## Convention

- Incremental numbering, never reused: `0001`, `0002`, …
- One file per decision: `NNNN-slug.md` (same file name in both languages).
- Statuses: **Proposed** · **Accepted** · **Deprecated** · **Superseded by ADR-XXXX**.
- An accepted ADR is not rewritten: if it evolves, a new one is written that supersedes it.

## List

| # | Title | Status |
|---|---|---|
| [0001](0001-class-factory.md) | In-house object-oriented class factory | ✅ Accepted |
| 0002 | `_G` pollution vs returned modules | 📝 To write |
| 0003 | `eventListener` fork status | 📝 To write |
| 0004 | FR + EN language strategy | 📝 To write |

## See also

- [Class map](../reference/overview.md)
- [The 4-layer architecture](../concepts/architecture-layers.md)
