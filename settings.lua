-- FR : Réglages de RitnLib
-- EN : RitnLib settings
data:extend({
    -- FR : Journal de débogage : traces des classes GUI dans le log (désactivé par défaut)
    -- EN : Debug log: GUI classes traces inside the log (off by default)
    {
        type = "bool-setting",
        name = "ritnlib-debug-log",
        setting_type = "runtime-global",
        default_value = false,
        order = "ritnlib-a",
    },
})
