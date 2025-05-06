-- Disable vanilla nightvision equipment
if data.raw["night-vision-equipment"]["night-vision-equipment"] then
  data.raw["night-vision-equipment"]["night-vision-equipment"].energy_input = "0W" -- Prevent activation
  data.raw["night-vision-equipment"]["night-vision-equipment"].darkness_to_turn_on = 1.0 -- Never activates
end

-- Disable vanilla nightvision item
if data.raw.item["night-vision-equipment"] then
  data.raw.item["night-vision-equipment"].hidden = true
  data.raw.item["night-vision-equipment"].place_as_equipment_result = nil
end

-- Disable vanilla nightvision recipe
if data.raw.recipe["night-vision-equipment"] then
  data.raw.recipe["night-vision-equipment"].enabled = false
  data.raw.recipe["night-vision-equipment"].hidden = true
end

-- Disable vanilla nightvision technology
if data.raw.technology["night-vision-equipment"] then
  data.raw.technology["night-vision-equipment"].enabled = false
  data.raw.technology["night-vision-equipment"].hidden = true
  data.raw.technology["night-vision-equipment"].effects = {}
end
