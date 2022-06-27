-- namespace: ava

function data()
    return {
        info    = {
            name           = "All Vanilla Assets (AVA)",
            description    = "Expose all (usable) vanilla models as assets.",
            authors        = {
                {
                    name = "Pentasis",
                    role = 'CREATOR',
                },
            },
            minorVersion   = 1,
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
