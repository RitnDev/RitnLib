---
title: Débuter avec une IA, sans connaître le Lua
type: guide
lang: fr
---

# Débuter avec une IA, sans connaître le Lua

Cette page s'adresse à quelqu'un qui veut créer un mod Factorio **sans savoir programmer en Lua**, avec
**Claude Code** comme assistant. L'IA écrit le code selon les [conventions des mods Ritn](mod-conventions.md),
le teste elle-même dans le jeu grâce à **RitnTest**, lit les erreurs et corrige. Ton rôle : décrire ce que tu
veux, lancer la partie de test, et regarder le résultat.

## Ce qu'il te faut

- **Factorio 2.x**. Conseillé : une copie « portable » à part pour les tests (version zip du site Factorio),
  pour ne pas toucher à tes parties.
- **Claude Code** (https://claude.com/claude-code) et **Python 3** (utilisé par l'outil de test).
- **Git**, pour récupérer les dépôts.

## 1. Récupérer les outils

```bash
git clone https://github.com/RitnDev/RitnLib
```

```bash
git clone https://github.com/RitnDev/RitnTest
```

RitnLib contient le kit (`ai/`) : un squelette de mod et les règles pour l'IA. RitnTest permet à l'IA de
piloter le jeu.

## 2. Créer ton mod à partir du squelette

Ouvre Claude Code dans un dossier vide, puis demande-lui, par exemple :

> Crée un nouveau mod Factorio appelé « MonMod » à partir du kit `RitnLib/ai/` (squelette `with-ritnlib`),
> en suivant `RitnLib/ai/README.md`. Installe aussi la skill `RitnTest/skills/factorio-mod-ritntest/`
> dans `.claude/skills/`.

L'IA copie le squelette, le renomme, ajoute `AGENTS.md` / `CLAUDE.md` et les skills. À partir de là, elle
connaît les conventions et sait tester.

## 3. Préparer la partie de test (une seule fois)

Demande à l'IA de **mettre en place RitnTest** : elle te guidera. Ce qu'elle ne peut pas faire à ta place :

1. **Fermer Factorio** pendant qu'elle règle RCON dans `config.ini` (le jeu réécrit ce fichier en quittant).
2. **Lancer Factorio**, puis **Multijoueur → Héberger une partie** (le test ne marche que dans une partie
   hébergée). Une nouvelle carte suffit.
3. Lui dire « la partie est hébergée ».

## 4. Demander une fonctionnalité

Décris ce que tu veux en français, simplement :

> Ajoute un bouton dans la fenêtre du mod qui affiche le nombre de joueurs connectés.

L'IA écrit le code, puis te demandera sans doute de **relancer Factorio** : le jeu ne relit les fichiers du mod
qu'au démarrage. Relance, héberge à nouveau la partie, préviens-la : elle teste, lit les erreurs et corrige.

## 5. Quand ça ne marche pas

- **Une erreur s'affiche dans le jeu** : copie-la à l'IA, ou dis-lui simplement de regarder
  `factorio-current.log` : elle sait le lire.
- **Le mod ne se charge pas** : vérifie dans *Mods* qu'il est activé, ainsi que RitnLib et RitnTest.
- **L'IA dit que tout est bon mais tu vois un problème** : décris ce que tu vois, ou envoie une capture.

## Pour aller plus loin

- [Conventions d'un mod Ritn](mod-conventions.md) : les règles que suit l'IA.
- Le wiki de modding de Factorio (https://wiki.factorio.com/Modding) et la documentation de l'API
  (https://lua-api.factorio.com/latest/) : les notions de base (data stage, control stage, évènements, `storage`).

!!! warning "Sécurité"
    RitnTest exécute n'importe quel code dans le mod testé : à n'utiliser que dans une partie de test locale,
    **jamais sur un serveur public**.
