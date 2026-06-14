---
title: Décisions d'architecture (ADR)
type: adr
lang: fr
---

# Décisions d'architecture (ADR)


Un **ADR** (*Architecture Decision Record*) consigne une décision d'architecture marquante : son **contexte**, la **décision** prise, et ses **conséquences**. Le but est de garder une trace du *pourquoi* — pas seulement du *comment* — pour les mainteneurs et les contributeurs.

## Convention

- Numérotation incrémentale, jamais réutilisée : `0001`, `0002`, …
- Un fichier par décision : `NNNN-slug.md` (même nom de fichier dans les deux langues).
- Statuts : **Proposé** · **Accepté** · **Déprécié** · **Remplacé par ADR-XXXX**.
- Un ADR accepté n'est pas réécrit : s'il évolue, on en rédige un nouveau qui le remplace.

## Liste

| N° | Titre | Statut |
|---|---|---|
| [0001](0001-class-factory.md) | Factory de classes orientée objet maison | ✅ Accepté |
| 0002 | Pollution `_G` vs modules retournés | 📝 À rédiger |
| 0003 | Statut du fork `eventListener` | 📝 À rédiger |
| 0004 | Stratégie linguistique FR + EN | 📝 À rédiger |

## Voir aussi

- [Carte des classes](../reference/overview.md)
- [Architecture en 4 couches](../concepts/architecture-layers.md)
