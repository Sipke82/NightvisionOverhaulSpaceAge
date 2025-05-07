-- Determine LUT based on startup setting
local lut_path = settings.startup["nightvision-lut-choice"].value == "vanilla" and "__core__/graphics/color_luts/lut-night.png" or "__NightvisionOverhaulSpaceAge__/graphics/color_luts/green-nightvision-lut.png"

-- Check if Space Age is active
local space_age_active = mods and mods["space-age"]

-- Define science packs and prerequisites based on Space Age and settings
local mk2_science = settings.startup["nightvision-mk2-science-choice"].value == "fulgora" and "electromagnetic-science-pack" or "agricultural-science-pack"
local mk2_prereq = settings.startup["nightvision-mk2-science-choice"].value == "fulgora" and "electromagnetic-plant" or "carbon-fiber"

data:extend({
  -- Equipment: Nightvision MK1
  {
    type = "night-vision-equipment",
    name = "nightvision-mk1",
    sprite = {
      filename = "__base__/graphics/equipment/night-vision-equipment.png",
      width = 128,
      height = 128,
      priority = "medium"
    },
    shape = {
      width = 2,
      height = 2,
      type = "full"
    },
    energy_source = {
      type = "electric",
      buffer_capacity = "120kJ",
      input_flow_limit = "240kW",
      usage_priority = "primary-input"
    },
    energy_input = "10kW",
    tint = { r = 0, g = 0.6, b = 0.1, a = 0.3 },
    desaturation_params = { deviation = 0, influencea = 0 },
    light_params = { deviation = 0, influence = 0 },
    darkness_to_turn_on = 0.3,
    color_lookup = {{0.5, lut_path}},
    categories = {"armor"},
    activate_sound = {
      filename = "__base__/sound/nightvision-on.ogg",
      volume = 0.6
    },
    deactivate_sound = {
      filename = "__base__/sound/nightvision-off.ogg",
      volume = 0.6
    }
  },
  -- Equipment: Nightvision MK2
  {
    type = "night-vision-equipment",
    name = "nightvision-mk2",
    sprite = {
      filename = "__NightvisionOverhaulSpaceAge__/graphics/icons/night-vision-mk2-equipment.png",
      width = 64,
      height = 64,
      priority = "medium"
    },
    shape = {
      width = 2,
      height = 1,
      type = "full"
    },
    energy_source = {
      type = "electric",
      buffer_capacity = "180kJ",
      input_flow_limit = "360kW",
      usage_priority = "primary-input"
    },
    energy_input = "15kW",
    tint = { r = 0, g = 0.6, b = 0.1, a = 0.3 },
    desaturation_params = { deviation = 0, agreement = 0 },
    light_params = { deviation = 0, influence = 0 },
    darkness_to_turn_on = 0.3,
    color_lookup = {{0.5, lut_path}},
    categories = {"armor"},
    activate_sound = {
      filename = "__base__/sound/nightvision-on.ogg",
      volume = 0.4
    },
    deactivate_sound = {
      filename = "__base__/sound/nightvision-off.ogg",
      volume = 0.4
    }
  },
  -- Equipment: Nightvision MK3
  {
    type = "night-vision-equipment",
    name = "nightvision-mk3",
    sprite = {
      filename = "__NightvisionOverhaulSpaceAge__/graphics/icons/night-vision-mk3-equipment.png",
      width = 64,
      height = 64,
      priority = "medium"
    },
    shape = {
      width = 1,
      height = 1,
      type = "full"
    },
    energy_source = {
      type = "electric",
      buffer_capacity = "240kJ",
      input_flow_limit = "480kW",
      usage_priority = "primary-input"
    },
    energy_input = "20kW",
    tint = { r = 0, g = 0.6, b = 0.1, a = 0.3 },
    desaturation_params = { deviation = 0, influence = 0 },
    light_params = { deviation = 0, influence = 0 },
    darkness_to_turn_on = 0.3,
    color_lookup = {{0.5, lut_path}},
    categories = {"armor"},
    activate_sound = {
      filename = "__base__/sound/nightvision-on.ogg",
      volume = 0.2
    },
    deactivate_sound = {
      filename = "__base__/sound/nightvision-off.ogg",
      volume = 0.2
    }
  },
  -- Item: Nightvision MK1
  {
    type = "item",
    name = "nightvision-mk1",
    icon = "__base__/graphics/icons/night-vision-equipment.png",
    icon_size = 64,
    icon_mipmaps = 4,
    subgroup = "utility-equipment",
    order = "c[night-vision]-a[nightvision-mk1]",
    stack_size = 20,
    place_as_equipment_result = "nightvision-mk1"
  },
  -- Item: Nightvision MK2
  {
    type = "item",
    name = "nightvision-mk2",
    icon = "__NightvisionOverhaulSpaceAge__/graphics/icons/night-vision-mk2-equipment.png",
    icon_size = 64,
    icon_mipmaps = 4,
    subgroup = "utility-equipment",
    order = "c[night-vision]-b[nightvision-mk2]",
    stack_size = 20,
    place_as_equipment_result = "nightvision-mk2"
  },
  -- Item: Nightvision MK3
  {
    type = "item",
    name = "nightvision-mk3",
    icon = "__NightvisionOverhaulSpaceAge__/graphics/icons/night-vision-mk3-equipment.png",
    icon_size = 64,
    icon_mipmaps = 4,
    subgroup = "utility-equipment",
    order = "c[night-vision]-c[nightvision-mk3]",
    stack_size = 20,
    place_as_equipment_result = "nightvision-mk3"
  },
  -- Recipe: Nightvision MK1
  {
    type = "recipe",
    name = "nightvision-mk1",
    enabled = false,
    energy_required = 10,
    ingredients = {
      {type = "item", name = "advanced-circuit", amount = 5},
      {type = "item", name = "low-density-structure", amount = 10}
    },
    results = {{type = "item", name = "nightvision-mk1", amount = 1}}
  },
  -- Recipe: Nightvision MK2
  {
    type = "recipe",
    name = "nightvision-mk2",
    enabled = false,
    energy_required = 15,
    ingredients = space_age_active and {
      {type = "item", name = "low-density-structure", amount = 10},
      {type = "item", name = "processing-unit", amount = 15},
      {type = "item", name = settings.startup["nightvision-mk2-science-choice"].value == "fulgora" and "supercapacitor" or "carbon-fiber", amount = 5}
    } or {
      {type = "item", name = "low-density-structure", amount = 10},
      {type = "item", name = "processing-unit", amount = 10},
      {type = "item", name = "efficiency-module-2", amount = 1}
    },
    results = {{type = "item", name = "nightvision-mk2", amount = 1}}
  },
  -- Recipe: Nightvision MK3
  {
    type = "recipe",
    name = "nightvision-mk3",
    enabled = false,
    energy_required = 20,
    ingredients = space_age_active and {
      {type = "item", name = "low-density-structure", amount = 10},
      {type = "item", name = "carbon-fiber", amount = 10},
      {type = "item", name = "processing-unit", amount = 30},
      {type = "item", name = "supercapacitor", amount = 5}
    } or {
      {type = "item", name = "low-density-structure", amount = 20},
      {type = "item", name = "processing-unit", amount = 20},
      {type = "item", name = "efficiency-module-3", amount = 1}
    },
    results = {{type = "item", name = "nightvision-mk3", amount = 1}}
  },
  -- Recycling Recipe: Nightvision MK2
  {
    type = "recipe",
    name = "nightvision-mk2-recycling",
    enabled = false,
    energy_required = 7.5,
    ingredients = {
      {type = "item", name = "nightvision-mk2", amount = 1}
    },
    results = space_age_active and {
      {type = "item", name = "processing-unit", amount = 5},
      {type = "item", name = settings.startup["nightvision-mk2-science-choice"].value == "fulgora" and "supercapacitor" or "carbon-fiber", amount = 5}
    } or {
      {type = "item", name = "processing-unit", amount = 5},
      {type = "item", name = "efficiency-module-2", amount = 1}
    },
    icon = "__NightvisionOverhaulSpaceAge__/graphics/icons/night-vision-mk2-equipment.png",
    icon_size = 64,
    subgroup = "utility-equipment",
    order = "c[night-vision]-b[nightvision-mk2-recycling]"
  },
  -- Recycling Recipe: Nightvision MK3
  {
    type = "recipe",
    name = "nightvision-mk3-recycling",
    enabled = false,
    energy_required = 10,
    ingredients = {
      {type = "item", name = "nightvision-mk3", amount = 1}
    },
    results = space_age_active and {
      {type = "item", name = "carbon-fiber", amount = 5},
      {type = "item", name = "supercapacitor", amount = 5}
    } or {
      {type = "item", name = "processing-unit", amount = 5},
      {type = "item", name = "efficiency-module-3", amount = 1}
    },
    icon = "__NightvisionOverhaulSpaceAge__/graphics/icons/night-vision-mk3-equipment.png",
    icon_size = 64,
    subgroup = "utility-equipment",
    order = "c[night-vision]-c[nightvision-mk3-recycling]"
  },
  -- Technology: Nightvision MK1
  {
    type = "technology",
    name = "night-vision-mk1",
    icon_size = 256,
    icons = util.technology_icon_constant_equipment("__base__/graphics/technology/night-vision-equipment.png"),
    effects = {
      {
        type = "unlock-recipe",
        recipe = "nightvision-mk1"
      }
    },
    prerequisites = {"low-density-structure", "solar-panel-equipment"},
    unit = {
      count = 250,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1}
      },
      time = 30
    },
    order = "c-e-a"
  },
  -- Technology: Nightvision MK2
  {
    type = "technology",
    name = "night-vision-mk2",
    icon_size = 256,
    icons = util.technology_icon_constant_equipment("__NightvisionOverhaulSpaceAge__/graphics/technology/night-vision-mk2-equipment.png"),
    effects = {
      {
        type = "unlock-recipe",
        recipe = "nightvision-mk2"
      },
      {
        type = "unlock-recipe",
        recipe = "nightvision-mk2-recycling"
      }
    },
    prerequisites = space_age_active and {"night-vision-mk1", mk2_prereq} or {"night-vision-mk1", "efficiency-module-2"},
    unit = {
      count = 750,
      ingredients = space_age_active and {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"utility-science-pack", 1},
        {"space-science-pack", 1},
        {mk2_science, 1}
      } or {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"utility-science-pack", 1}
      },
      time = 45
    },
    order = "c-e-b"
  },
  -- Technology: Nightvision MK3
  {
    type = "technology",
    name = "night-vision-mk3",
    icon_size = 256,
    icons = util.technology_icon_constant_equipment("__NightvisionOverhaulSpaceAge__/graphics/technology/night-vision-mk3-equipment.png"),
    effects = {
      {
        type = "unlock-recipe",
        recipe = "nightvision-mk3"
      },
      {
        type = "unlock-recipe",
        recipe = "nightvision-mk3-recycling"
      }
    },
    prerequisites = space_age_active and {"night-vision-mk2", "electromagnetic-plant"} or {"night-vision-mk2", "efficiency-module-3"},
    unit = {
      count = 1000,
      ingredients = space_age_active and {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"utility-science-pack", 1},
        {"space-science-pack", 1},
        {"agricultural-science-pack", 1},
        {"electromagnetic-science-pack", 1}
      } or {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 1},
        {"utility-science-pack", 1}
      },
      time = 60
    },
    order = "c-e-c"
  }
})
