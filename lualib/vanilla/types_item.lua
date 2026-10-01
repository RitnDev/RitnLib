---Liste ordonnée de tous les sous-types de prototypes d'item Factorio. Parcourue dans l'ordre par
---`RitnPrototype:getItemType()` (appelé par le constructeur de `RitnProtoItem`) pour résoudre le sous-type concret de `data.raw` d'une cible
---générique `"item"`. L'ordre est significatif : le premier sous-type dont `data.raw[sous-type][nom]`
---existe l'emporte.
---@type string[]
return {
	"item",
	"ammo",
	"tool",
	"capsule",
	"gun",
	"item-with-entity-data",
	"item-with-label",
	"item-with-inventory",
	"blueprint-book",
	"item-with-tags",
	"selection-tool",
	"blueprint",
	"copy-paste-tool",
	"deconstruction-item",
	"upgrade-item",
	"module",
	"rail-planner",
	"spidertron-remote",
	"armor",
	"repair-tool",
	"space-platform-starter-pack"
}
