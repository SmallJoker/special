minetest.register_node("special:fire", {
	description = "You hacker you!",
	drawtype = "plantlike",
	tiles = {{
		name="fire_basic_flame_animated.png",
		animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
	}},
	inventory_image = "fire_basic_flame.png",
	light_source = 14,
	groups = {dig_immediate=3, hot=3, not_in_creative_inventory=1},
	drop = "",
	walkable = false,
	buildable_to = true,
	damage_per_second = 1,
})

minetest.register_tool("special:flint", {
	description = "Flint",
	inventory_image = "special_flint.png",
	stack_max = 1,
	on_use = function(itemstack, player, pointed_thing)
		if math.random(4) ~= 2 then
			return
		end
		if pointed_thing.type ~= "node" then
			return
		end
		local pos = pointed_thing.above
		local player_name = player:get_player_name()
		if minetest.is_protected(pos, player_name) then
			minetest.record_protection_violation(pos, player_name)
			return
		end
		
		-- is flammable?
		pos.y = pos.y - 1
		local node_def = minetest.registered_nodes[minetest.get_node(pos).name]
		pos.y = pos.y + 1
		if node_def and node_def.groups then
			if node_def.groups.flammable and node_def.groups.flammable > 0 then
				minetest.set_node(pos, {name="special:fire"})
				itemstack:add_wear(65535 / 80 + 1)
				return itemstack
			end
		end
	end
})

minetest.register_craft({
	output = "special:flint",
	recipe = {
		{"", "default:mese_crystal_fragment", ""},
		{"default:stone", "group:stick", "default:stone"},
	}
})