function data()
    return {
        info    = {
            name           = "Consolidated Assets",
            description    = "Expose all (!) vanilla models as assets.",
            authors        = {
                {
                    name = "Pentasis",
                    role = 'CREATOR',
                },
            },
            minorVersion   = 7,
            severityAdd    = "WARNING",
            severityRemove = "CRITICAL",
            params         = {}
        },
        options = {},
        runFn   = function(settings, modParams)

        end
        -- postRunFn = function (settings, params) ...
    }
end
