local asset_helper = {}

function asset_helper.dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

-- ---------------------------------------------------------------

function asset_helper.getButtonValues(asset_list)
    local value_list = {}

    for key, value in ipairs(asset_list) do
        value_list[key] = value[1]
    end

    return value_list
end

function asset_helper.getIconValues(asset_list)
    local value_list = {}


    return value_list
end

return asset_helper
