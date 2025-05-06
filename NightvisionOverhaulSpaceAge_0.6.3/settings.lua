data:extend({
  -- LUT Choice Setting
  {
    type = "string-setting",
    name = "nightvision-lut-choice",
    setting_type = "startup",
    default_value = "mod",
    allowed_values = {"vanilla", "mod"},
    order = "a0"
  },
  -- MK1 Settings
  {
    type = "double-setting",
    name = "nightvision-halo-color-red-mk1",
    setting_type = "runtime-per-user",
    default_value = 0.25,
    minimum_value = 0.0,
    maximum_value = 1.0,
    order = "a1"
  },
  {
    type = "double-setting",
    name = "nightvision-halo-color-green-mk1",
    setting_type = "runtime-per-user",
    default_value = 0.6,
    minimum_value = 0.0,
    maximum_value = 1.0,
    order = "a2"
  },
  {
    type = "double-setting",
    name = "nightvision-halo-color-blue-mk1",
    setting_type = "runtime-per-user",
    default_value = 0.25,
    minimum_value = 0.0,
    maximum_value = 1.0,
    order = "a3"
  },
  {
    type = "double-setting",
    name = "nightvision-halo-intensity-mk1",
    setting_type = "runtime-per-user",
    default_value = 0.4,
    minimum_value = 0.1,
    maximum_value = 2.0,
    order = "a4"
  },
  {
    type = "double-setting",
    name = "nightvision-halo-scale-mk1",
    setting_type = "runtime-per-user",
    default_value = 10.0,
    minimum_value = 1.0,
    maximum_value = 40.0,
    order = "a5"
  },
  -- MK2 Settings
  {
    type = "double-setting",
    name = "nightvision-halo-color-red-mk2",
    setting_type = "runtime-per-user",
    default_value = 0.4,
    minimum_value = 0.0,
    maximum_value = 1.0,
    order = "b1"
  },
  {
    type = "double-setting",
    name = "nightvision-halo-color-green-mk2",
    setting_type = "runtime-per-user",
    default_value = 0.8,
    minimum_value = 0.0,
    maximum_value = 1.0,
    order = "b2"
  },
  {
    type = "double-setting",
    name = "nightvision-halo-color-blue-mk2",
    setting_type = "runtime-per-user",
    default_value = 0.5,
    minimum_value = 0.0,
    maximum_value = 1.0,
    order = "b3"
  },
  {
    type = "double-setting",
    name = "nightvision-halo-intensity-mk2",
    setting_type = "runtime-per-user",
    default_value = 0.6,
    minimum_value = 0.1,
    maximum_value = 2.0,
    order = "b4"
  },
  {
    type = "double-setting",
    name = "nightvision-halo-scale-mk2",
    setting_type = "runtime-per-user",
    default_value = 14.0,
    minimum_value = 1.0,
    maximum_value = 40.0,
    order = "b5"
  },
  -- MK3 Settings
  {
    type = "double-setting",
    name = "nightvision-halo-color-red-mk3",
    setting_type = "runtime-per-user",
    default_value = 0.8,
    minimum_value = 0.0,
    maximum_value = 1.0,
    order = "c1"
  },
  {
    type = "double-setting",
    name = "nightvision-halo-color-green-mk3",
    setting_type = "runtime-per-user",
    default_value = 1.0,
    minimum_value = 0.0,
    maximum_value = 1.0,
    order = "c2"
  },
  {
    type = "double-setting",
    name = "nightvision-halo-color-blue-mk3",
    setting_type = "runtime-per-user",
    default_value = 0.8,
    minimum_value = 0.0,
    maximum_value = 1.0,
    order = "c3"
  },
  {
    type = "double-setting",
    name = "nightvision-halo-intensity-mk3",
    setting_type = "runtime-per-user",
    default_value = 0.9,
    minimum_value = 0.1,
    maximum_value = 2.0,
    order = "c4"
  },
  {
    type = "double-setting",
    name = "nightvision-halo-scale-mk3",
    setting_type = "runtime-per-user",
    default_value = 20.0,
    minimum_value = 1.0,
    maximum_value = 40.0,
    order = "c5"
  }
})
