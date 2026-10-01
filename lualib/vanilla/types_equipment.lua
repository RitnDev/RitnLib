---Liste ordonnée de tous les sous-types de prototypes d'équipement Factorio. Parcourue dans l'ordre
---par `RitnPrototype:getEquipmentType()` pour résoudre le sous-type concret de `data.raw` d'une
---cible générique `"equipment"`. L'ordre est significatif : le premier sous-type dont
---`data.raw[sous-type][nom]` existe l'emporte.
---@type string[]
return {
    "active-defense-equipment",
    "battery-equipment",
    "belt-immunity-equipment",
    "energy-shield-equipment",
    "equipment-ghost",
    "generator-equipment",
    "inventory-bonus-equipment",
    "movement-bonus-equipment",
    "night-vision-equipment",
    "roboport-equipment",
    "solar-panel-equipment",
}
