local asset_helper = {}

asset_helper.NAME = 1
asset_helper.ICON = 0

-- TODO: Split into 2 (local) functions
function asset_helper.getButtonValues(asset_list, type)
    local value_list = {}

    for key, value in ipairs(asset_list) do
        value_list[key] = value[type]
    end

    return value_list
end

return asset_helper
