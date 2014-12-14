minetest.register_node("special:xtorch", {
	description = "X Torch",
	drawtype = "plantlike",
	tiles = {
		{name="default_torch_on_floor_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}},
	},
	inventory_image = "default_torch_on_floor.png",
	wield_image = "default_torch_on_floor.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	light_source = LIGHT_MAX-1,
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.1, 0.1, 0.1, 0.1},
	},
	groups = {dig_immediate=3, flammable=1, attached_node=1, hot=2},
	sounds = default.node_sound_defaults(),
})

minetest.register_craft({
	output = "default:torch",
	recipe = {
		{"special:xtorch"},
	}
})

minetest.register_craft({
	output = "special:xtorch 2",
	recipe = {
		{"default:torch"},
		{"default:torch"},
	}
})