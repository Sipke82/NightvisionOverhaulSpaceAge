-- Initialize global table structure (safe for on_load)
local function initialize_global_state()
  global = global or {}
  global.halo_enabled = global.halo_enabled or {}
  global.player_data = global.player_data or {}
end

-- Update player equipment state (checks equipped armor)
local function update_player_equipment_state(player)
  local player_data = global.player_data[player.index] or {
    has_halo_equipment = false,
    equipment_type = nil,
    last_darkness = 0,
    last_checked_tick = 0
  }
  local has_halo = false
  local equipment_type = nil
  if player.character then
    local armor = player.get_inventory(defines.inventory.character_armor)
    if armor and not armor.is_empty() then
      local grid = armor[1].grid
      if grid then
        for _, equipment in pairs(grid.equipment) do
          if (equipment.name == "nightvision-mk1" or equipment.name == "nightvision-mk2" or equipment.name == "nightvision-mk3") and equipment.energy > 0 then
            has_halo = true
            equipment_type = equipment.name:match("nightvision%-(mk%d)")
            break
          end
        end
      end
    end
  end
  player_data.has_halo_equipment = has_halo
  player_data.equipment_type = equipment_type
  global.player_data[player.index] = player_data
  log("NightvisionOverhaulSpaceAge 0.6.3: Player " .. player.index .. " equipment state updated: has_halo=" .. tostring(has_halo) .. ", type=" .. (equipment_type or "none"))
  return has_halo
end

-- Initialize player-specific data (requires game.players, not safe for on_load)
local function initialize_player_data()
  for _, player in pairs(game.players) do
    if player.character then
      global.halo_enabled[player.index] = { render_ids = {} }
      global.player_data[player.index] = global.player_data[player.index] or {
        has_halo_equipment = false,
        equipment_type = nil,
        last_darkness = 0,
        last_checked_tick = 0
      }
      update_player_equipment_state(player)
      global.player_data[player.index].last_darkness = player.surface.darkness
      global.player_data[player.index].last_checked_tick = game.tick
      update_halo(player, global.player_data[player.index].has_halo_equipment)
    end
  end
end

-- Initialize on mod init
script.on_init(function()
  initialize_global_state()
  initialize_player_data()
end)

-- Handle configuration changes
script.on_configuration_changed(function()
  initialize_global_state()
  initialize_player_data()
end)

-- Initialize on save load
script.on_load(function()
  initialize_global_state()
end)

-- One-time check after load to ensure halo is initialized
script.on_event(defines.events.on_tick, function(event)
  if event.tick == 1 then
    initialize_player_data()
    log("NightvisionOverhaulSpaceAge 0.6.3: Post-load initialization on tick 1")
  end
end)

-- Update halo state periodically
script.on_nth_tick(15, function(event)
  if not global or not global.halo_enabled or not global.player_data then
    -- Skip if global is not initialized
    log("NightvisionOverhaulSpaceAge 0.6.3: Skipping on_nth_tick due to uninitialized global")
    return
  end
  for _, player in pairs(game.players) do
    if player.character and player.connected then
      local state = global.halo_enabled[player.index] or { render_ids = {} }
      local player_data = global.player_data[player.index] or {
        has_halo_equipment = false,
        equipment_type = nil,
        last_darkness = 0,
        last_checked_tick = 0
      }

      -- Update equipment state
      local has_halo = update_player_equipment_state(player)

      -- Update darkness immediately for first few ticks or every 60 ticks
      if event.tick - player_data.last_checked_tick >= 60 or event.tick < 60 then
        player_data.last_darkness = player.surface.darkness
        player_data.last_checked_tick = event.tick
      end

      -- Check if halo should be active
      local should_have_halo = player_data.last_darkness > 0.3 and has_halo
      log("NightvisionOverhaulSpaceAge 0.6.3: Player " .. player.index .. " should_have_halo=" .. tostring(should_have_halo) .. ", darkness=" .. player_data.last_darkness)

      if should_have_halo then
        -- Get player-specific settings based on equipment type
        local suffix = player_data.equipment_type or "mk1"
        local settings = {
          color = {
            r = player.mod_settings["nightvision-halo-color-red-" .. suffix].value,
            g = player.mod_settings["nightvision-halo-color-green-" .. suffix].value,
            b = player.mod_settings["nightvision-halo-color-blue-" .. suffix].value
          },
          intensity = player.mod_settings["nightvision-halo-intensity-" .. suffix].value,
          scale = player.mod_settings["nightvision-halo-scale-" .. suffix].value
        }
        -- Clean up invalid renderings
        local valid_render_ids = {}
        for _, render_id in ipairs(state.render_ids) do
          local success, ttl = pcall(function() return rendering.get_time_to_live(render_id) end)
          if success and ttl > 0 then
            table.insert(valid_render_ids, render_id)
            rendering.set_time_to_live(render_id, 45)
          else
            pcall(function() rendering.destroy(render_id) end)
          end
        end
        state.render_ids = valid_render_ids

        -- Create new rendering if needed, limit to 3
        if #state.render_ids < 3 then
          local new_render_id = rendering.draw_light{
            sprite = "utility/light_medium",
            scale = settings.scale,
            intensity = settings.intensity,
            color = settings.color,
            minimum_darkness = 0,
            target = player.character,
            surface = player.character.surface,
            time_to_live = 45 -- 0.75 seconds
          }
          table.insert(state.render_ids, new_render_id)
          log("NightvisionOverhaulSpaceAge 0.6.3: Player " .. player.index .. " created new rendering, render_ids=" .. #state.render_ids)
        end
      else
        -- Clear all renderings
        for _, render_id in ipairs(state.render_ids) do
          pcall(function() rendering.destroy(render_id) end)
        end
        state.render_ids = {}
        log("NightvisionOverhaulSpaceAge 0.6.3: Player " .. player.index .. " cleared renderings, should_have_halo=false")
      end

      global.halo_enabled[player.index] = state
      global.player_data[player.index] = player_data
    end
  end
end)

-- Update equipment state on placement/removal
script.on_event(defines.events.on_player_placed_equipment, function(event)
  local player = game.players[event.player_index]
  local equipment = event.equipment.name
  if equipment == "nightvision-mk1" or equipment == "nightvision-mk2" or equipment == "nightvision-mk3" then
    global.player_data[player.index].has_halo_equipment = true
    global.player_data[player.index].equipment_type = equipment:match("nightvision%-(mk%d)")
    log("NightvisionOverhaulSpaceAge 0.6.3: Player " .. player.index .. " equipped " .. equipment)
    update_halo(player, true)
  end
end)

script.on_event(defines.events.on_player_removed_equipment, function(event)
  local player = game.players[event.player_index]
  local equipment = event.equipment
  if equipment == "nightvision-mk1" or equipment == "nightvision-mk2" or equipment == "nightvision-mk3" then
    global.player_data[player.index].has_halo_equipment = false
    global.player_data[player.index].equipment_type = nil
    log("NightvisionOverhaulSpaceAge 0.6.3: Player " .. player.index .. " removed " .. equipment)
    update_halo(player, false)
  end
end)

-- Handle armor changes
script.on_event(defines.events.on_player_armor_inventory_changed, function(event)
  local player = game.players[event.player_index]
  if player.character then
    update_player_equipment_state(player)
    update_halo(player, global.player_data[player.index].has_halo_equipment)
  end
end)

-- Helper function to update halo state immediately
function update_halo(player, should_have_halo)
  if not global or not global.halo_enabled or not global.player_data then
    log("NightvisionOverhaulSpaceAge 0.6.3: Skipping update_halo due to uninitialized global")
    return
  end
  local state = global.halo_enabled[player.index] or { render_ids = {} }
  local player_data = global.player_data[player.index] or {
    has_halo_equipment = false,
    equipment_type = nil,
    last_darkness = 0,
    last_checked_tick = 0
  }

  -- Update darkness immediately
  player_data.last_darkness = player.surface.darkness
  player_data.last_checked_tick = game.tick

  should_have_halo = should_have_halo and player_data.last_darkness > 0.3
  log("NightvisionOverhaulSpaceAge 0.6.3: Player " .. player.index .. " update_halo: should_have_halo=" .. tostring(should_have_halo) .. ", darkness=" .. player_data.last_darkness)

  if should_have_halo then
    -- Get player-specific settings based on equipment type
    local suffix = player_data.equipment_type or "mk1"
    local settings = {
      color = {
        r = player.mod_settings["nightvision-halo-color-red-" .. suffix].value,
        g = player.mod_settings["nightvision-halo-color-green-" .. suffix].value,
        b = player.mod_settings["nightvision-halo-color-blue-" .. suffix].value
      },
      intensity = player.mod_settings["nightvision-halo-intensity-" .. suffix].value,
      scale = player.mod_settings["nightvision-halo-scale-" .. suffix].value
    }
    -- Clean up all existing renderings
    for _, render_id in ipairs(state.render_ids) do
      pcall(function() rendering.destroy(render_id) end)
    end
    state.render_ids = {}

    -- Create initial rendering
    local new_render_id = rendering.draw_light{
      sprite = "utility/light_medium",
      scale = settings.scale,
      intensity = settings.intensity,
      color = settings.color,
      minimum_darkness = 0,
      target = player.character,
      surface = player.character.surface,
      time_to_live = 45 -- 0.75 seconds
    }
    table.insert(state.render_ids, new_render_id)
    log("NightvisionOverhaulSpaceAge 0.6.3: Player " .. player.index .. " update_halo created new rendering")
  else
    -- Clear all renderings
    for _, render_id in ipairs(state.render_ids) do
      pcall(function() rendering.destroy(render_id) end)
    end
    state.render_ids = {}
    log("NightvisionOverhaulSpaceAge 0.6.3: Player " .. player.index .. " update_halo cleared renderings")
  end

  global.halo_enabled[player.index] = state
  global.player_data[player.index] = player_data
end

-- Restore halo state after player creation or reconnection
script.on_event(defines.events.on_player_created, function(event)
  local player = game.players[event.player_index]
  if player.character then
    initialize_player_data()
  end
end)

script.on_event(defines.events.on_player_joined_game, function(event)
  local player = game.players[event.player_index]
  if player.character then
    initialize_player_data()
    log("NightvisionOverhaulSpaceAge 0.6.3: Player " .. player.index .. " joined, reinitialized halo state")
  end
end)
