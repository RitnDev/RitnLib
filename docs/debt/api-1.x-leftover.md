---
title: Résidus API 1.x
type: reference
lang: fr
---

# Résidus API 1.x

> Complément de [Migration Factorio 2.0](../migration-2.0.md), qui traite les résidus **structurants** (API statistics, `created_entity`, classes `RitnProto*`). Cette page recense les **clés de prototype mortes** : des propriétés retirées par Factorio que le code écrit encore.
>
> Nature du risque : Factorio **ignore silencieusement** les clés de prototype inconnues. Aucune de ces lignes ne lève d'erreur au chargement — elles ont simplement cessé d'agir. C'est ce qui les rend invisibles sans audit statique.

Relevé établi en croisant les sources avec `prototype-api.json` 2.1.17 et le `changelog.txt` officiel du jeu.

---

## 1. `icon_mipmaps` — 27 occurrences

Retiré en 2.0 : *« Removed icon_mipmaps from various prototypes using icons. Mipmap count will be inferred from `icon_size` and actual dimensions of the source image. »*

| Fichier | Lignes |
|---|---|
| `classes/prototypes/Ore.lua` | 121 |
| `lualib/vanilla/ores.lua` | 168, 272, 426 |
| `lualib/vanilla/util.lua` | 335, 369-534 (20 occurrences dans les templates d'icônes) |

- **Impact** : nul. Le nombre de niveaux est désormais déduit de la largeur réelle de l'image comparée à `icon_size`, ce qui est plus fiable que la valeur déclarée.
- **Migration** : suppression pure. `lualib/vanilla/util.lua:335` (`icon.icon_mipmaps = icon_to_add.icon_mipmaps`) est une recopie de clé dans un helper de fusion d'icônes — à retirer aussi.

## 2. `hr_version` — portée plus large que documentée

[Migration 2.0 §1.3](../migration-2.0.md) ne cite que `lualib/other-functions`. Le layout legacy est en réalité aussi présent dans :

| Fichier | Lignes |
|---|---|
| `classes/prototypes/Ore.lua` | 155 |
| `lualib/vanilla/ores.lua` | 206, 230, 327 |
| `lualib/vanilla/util.lua` | 159-160, 579-580 (helpers qui *parcourent* `hr_version`) |

Les deux helpers de `vanilla/util.lua` traversent la clé pour appliquer un traitement récursif : ils deviennent des branches mortes une fois `hr_version` supprimé, pas des bugs.

## 3. `hide_from_player_stats` — n'a jamais existé

`classes/prototypes/Recipe.lua` lignes **144, 156, 168, 179** (méthode `setHidden`).

La propriété correcte de `RecipePrototype` est **`hide_from_stats`**. `hide_from_player_stats` n'existe dans aucune version du schéma — le paramètre `stats` de `setHidden()` n'a donc **jamais rien fait**, silencieusement.

- **Migration** : renommer en `hide_from_stats`. Attention, ça **active** un comportement jusqu'ici inerte — à tester sur les recettes concernées.
- Voisines correctes et bien utilisées : `hide_from_player_crafting`, `hidden`.

## 4. `hardness` — `lualib/vanilla/ores.lua:433`

`minable.hardness` a disparu des `ResourceEntityPrototype` depuis 0.17. Clé morte, impact nul.

## 5. `LuaStyle.visible` — `classes/RitnClass/gui/RitnStyle.lua:332`

`RitnLibStyle:visible()` écrit `self.style.visible`. `LuaStyle` n'expose pas `visible` — c'est un membre de `LuaGuiElement`, pas de son style.

[Bugs connus](known-bugs.md) liste déjà cette méthode, mais pour une **autre** cause (le `log` concatène `self.gui_name`, jamais défini, qui lève avant d'arriver à la ligne). Les deux défauts sont à corriger ensemble : la méthode doit viser l'élément, pas le style.

---

## Voir aussi

- [Migration Factorio 2.0](../migration-2.0.md) — résidus structurants
- [Migration Factorio 2.1](../migration-2.1.md) — résidus introduits par le passage en 2.1
- [Bugs connus](known-bugs.md)
- [APIs dépréciées](deprecated.md)
