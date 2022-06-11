local helper = require "penta_assets/asset_helper"

local MODELS = {
  { name = "", uri = "industry/farm/barn_open.mdl" },
  { name = "", uri = "industry/farm/cesspit.mdl" },
  { name = "", uri = "industry/farm/cow_barn_cort.mdl" },
  { name = "", uri = "industry/farm/fence.mdl" },
  { name = "", uri = "industry/farm/hay_cube.mdl" },
  { name = "", uri = "industry/farm/hay_flat.mdl" },
  { name = "", uri = "industry/farm/hay_pile.mdl" },
  { name = "", uri = "industry/farm/hay_round.mdl" },
  { name = "", uri = "industry/farm/silo.mdl" },
  { name = "", uri = "industry/farm/well.mdl" },
}
local ASSET_CONFIG = {
  category = { "penta_rural_assets" },
  sub_category = "Farm assets",
  description = "Farm assets",
  has_icon_button = false,
  has_magnet = false,
  has_track_height = false,
  has_seperated_scales = false
}

-- ================================================================== --

function data()

  return {
    type = "ASSET_DEFAULT",
    description = {
      name = ASSET_CONFIG.sub_category,
      description = ASSET_CONFIG.description,
    },
    availability = {
      yearFrom = 1850,
      yearTo = 0,
    },
    buildMode = "MULTI",
    categories = ASSET_CONFIG.category,
    order = 100,
    skipCollision = true,
    autoRemovable = false,

    params = helper.generateAssetParameters(ASSET_CONFIG, MODELS),

    updateFn = function(params)
      return helper.updateFnAsset(MODELS, params)
    end
  }
end