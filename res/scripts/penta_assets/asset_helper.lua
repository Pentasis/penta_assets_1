local constructionutil = require "constructionutil"

local asset_helper = {}

local SCALE_FACTORS = { 0.1, 0.25, 0.5, 0.75, 1, 1.5, 2 }
local CIM_CAPACITY = { 1, 2, 3, 4, 5, 10, 25, 50, 100 }
local HAVE_HEIGHT_PARAM = { "Trains", "Waggons" }
local HAVE_CIM_CAPACITY = { "Houses", "Shops", "Factories" }

-- ================================================================== --

local function hasValue(table, search_term)
  for index, value in ipairs(table) do
    if value == search_term then
      return true
    end
  end

  return false
end

-- ------------------------------------------------------------------ --

local function sanitizeString(subcategory)
  subcategory = string.gsub(subcategory, " ", "_")
  subcategory = string.gsub(subcategory, "&", "and")
  return string.lower(subcategory)
end

-- ------------------------------------------------------------------ --

local function getFileName(uri)
  return string.sub(uri:match("^.+/(.+)$"), 1, -5)
end

-- ------------------------------------------------------------------ --

local function clamp(min, value, max)
  return math.max(min, math.min(max, value))
end

-- ------------------------------------------------------------------ --

local function getButtonsText(models)
  local buttons_texts = {}

  for index, model in ipairs(models) do
    if model.name ~= "" then
      buttons_texts[index] = model.name
    else
      buttons_texts[index] = getFileName(model.uri)
    end
  end

  return buttons_texts
end

-- ------------------------------------------------------------------ --

local function getButtonsIcons(models, icon_url)
  local buttons_icons = {}

  for index, model in ipairs(models) do
    buttons_icons[index] = icon_url .. getFileName(model.uri) .. ".tga"
  end

  return buttons_icons
end

-- ================================================================== --

function asset_helper.generateBaseParameters(subcategory, models)

  local icon_url = "ui/construction/icon_buttons/" .. sanitizeString(subcategory) .. "/"

  local params = {
    {
      key = "assets",
      name = subcategory,
      uiType = "ICON_BUTTON",
      values = getButtonsIcons(models, icon_url), -- getButtonsText(models)
      defaultIndex = 0,
    },
    {
      key = "asset_scales",
      name = "Scale",
      uiType = "SLIDER",
      values = { "0.10x", "0.25x", "0.5x", "0.75x", "1.0x", "1.5x", "2.0x" },
      defaultIndex = 4,
      tooltip = "Scales the asset's size.",
    },
    {
      key = "terrain_alignment",
      name = _("Terrain alignment"),
      uiType = "CHECKBOX",
      values = { "0", "1" },
      defaultIndex = 0,
    },
    {
      key = "slope_msg",
      name = _("Slope & Pivot can be changed with O,P,[ and ] keys."),
      uiType = "BUTTON",
      values = { "(Hold shift for smaller steps)" },
      defaultIndex = 0,
    } -- TODO: make this a visual guide (ICON_BUTTON) and move to lowest position
  }

  if hasValue(HAVE_HEIGHT_PARAM, subcategory) then
    params[#params + 1] = {
      key = "asset_height",
      name = _("Height"),
      uiType = "BUTTON",
      values = { _("Ground"), _("Rail") },
      defaultIndex = 0,
    }
  end

  if hasValue(HAVE_CIM_CAPACITY, subcategory) then
    params[#params + 1] = {
      key = "asset_cim_magnet",
      name = _("Magnet"),
      uiType = "BUTTON",
      values = { _("None"), _("House"), _("Shop"), _("Work") },
      defaultIndex = 0,
    }
    params[#params + 1] = {
      key = "asset_cim_capacity",
      name = _("Capacity"),
      uiType = "BUTTON",
      values = { "1", "2", "3", "4", "5", "10", "25", "50", "100" },
      defaultIndex = 0,
    }
  end

  return params
end

-- ------------------------------------------------------------------ --

function asset_helper.updateFnGeneral(models, params)
  -- because lua is one-indexed, but the parameter value is zero-indexed:
  local selected_model_index = params.assets + 1
  local selected_scale_index = params.asset_scales + 1

  local selected_scale = SCALE_FACTORS[selected_scale_index]
  local selected_height = 0

  -- 1.05 is the default height of (vanilla) tracks
  if params.asset_height and params.asset_height == 1 then
    selected_height = 1.05
  end

  local result = {}
  result.models = {}

  -- TRANSFORMATION MATRIX
  -- x-scale   | -yaw(z) | pitch(y) | x-offset
  -- yaw(z)    | y-scale | -roll(x) | y-offset
  -- -pitch(y) | roll(x) | z-scale  | z-offset
  -- x-pos     | y-pos   | z-pos    | material-lighting-intensity???wtf is this?
  --
  -- yaw, pitch and roll are rotations around the axis.
  -- afaik, the x-axis denotes front-to-back?
  -- z-offset and yaw can be controlled with n,m,<,>
  -- params.paramX and params.ParamY are controlled by o,p,[,]

  result.models = {
    {
      id = models[selected_model_index].uri,
      transf = constructionutil.rotateTransf(params, { selected_scale, 0, 0, 0,
                                                       0, selected_scale, 0, 0,
                                                       0, 0, selected_scale, 0,
                                                       0, 0, selected_height, 1 })
    }
  }

  if params.asset_cim_magnet then
    -- is there a need to check for 0 ?
    if params.asset_cim_magnet == 1 then
      result.personCapacity = {
        type = "RESIDENTIAL",
        capacity = CIM_CAPACITY[params.asset_cim_capacity + 1] -- params are 0-indexed
      }
    elseif params.asset_cim_magnet == 2 then
      result.personCapacity = {
        type = "COMMERCIAL",
        capacity = CIM_CAPACITY[params.asset_cim_capacity + 1]
      }
    elseif params.asset_cim_magnet == 3 then
      result.personCapacity = {
        type = "INDUSTRIAL",
        capacity = CIM_CAPACITY[params.asset_cim_capacity + 1]
      }
    end
  end

  if params.terrain_alignment == 0 then
    result.terrainAlignmentLists = {
      { type = "EQUAL", faces = {} }
    }
  end

  return result
end

return asset_helper
