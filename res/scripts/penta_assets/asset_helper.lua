local asset_helper = {}

local SCALE_FACTORS = { 0.1, 0.25, 0.5, 0.75, 1, 1.5, 2 }
local MODEL_NAME_INDEX = 1
local MODEL_URI_INDEX = 2


function asset_helper.dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then
        k = '"' .. k .. '"'
      end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

-- ------------------------------------------------------------------ --

local function getFileName(url)
  return string.sub(url:match("^.+/(.+)$"), 1, -5)
end

-- ------------------------------------------------------------------ --

local function getButtonsText(models)
  local buttons_texts = {}

  for index, text_uri_pair in ipairs(models) do
    if text_uri_pair[MODEL_NAME_INDEX] ~= "" then
      buttons_texts[index] = text_uri_pair[MODEL_NAME_INDEX]
    else
      buttons_texts[index] = getFileName(text_uri_pair[MODEL_URI_INDEX])
    end
  end

  return buttons_texts
end

-- ------------------------------------------------------------------ --

local function getButtonsIcons(models)
  local buttons_icons = {}

  return buttons_icons
end

-- ================================================================== --

function asset_helper.generateBaseParameters(param_name, models)
  return {
    {
      key = "assets",
      name = param_name,
      uiType = "BUTTON", -- "ICON_BUTTON",
      values = getButtonsText(models, MODEL_NAME_INDEX), -- helper.getButtonIcons(MODELS, MODEL_URI_INDEX)
    },
    {
      key = "asset_scales",
      name = "Scale",
      uiType = "SLIDER",
      values = { "0.10x", "0.25x", "0.5x", "0.75x", "1.0x", "1.5x", "2.0x" },
      defaultIndex = 4,
      tooltip = "Scales the asset's size.",
    },
  }
end

-- ------------------------------------------------------------------ --

function asset_helper.updateFnGeneral(models, params)
  -- because lua is one-indexed, but the parameter value is zero-indexed:
  local selected_model_index = params.assets + 1
  local selected_scale_index = params.asset_scales + 1
  local selected_scale = SCALE_FACTORS[selected_scale_index]
  local result = {}
  result.models = {}

  result.models = {
    {
      id = models[selected_model_index][MODEL_URI_INDEX],
      transf = {
        1 * selected_scale, 0, 0, 0, 0,
        1 * selected_scale, 0, 0, 0, 0,
        1 * selected_scale, 0, 0, 0, 0, 1
      }
    }
  }

  result.terrainAlignmentLists = {
    { type = "EQUAL", faces = {} }
  }

  return result
end

return asset_helper
