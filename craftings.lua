minetest.register_craft({
	output = "default:lava_source",
	recipe = {
		{"default:stick"},
		{"bucket:bucket_lava"},
		{"vessels:glass_bottle"},
	},
	replacements = { {"bucket:bucket_lava", "bucket:bucket_empty"} },
})

minetest.register_craft({
	output = "bucket:bucket_lava",
	recipe = {
		{"default:stick"},
		{"default:lava_source"},
		{"bucket:bucket_empty"},
	},
	replacements = { {"bucket:bucket_empty", "bucket:bucket_lava"} },
})

minetest.register_craftitem(":mining_plus:c_leaves", {
	description = "Compressed Leaves",
	inventory_image = "default_leaves.png",
})

minetest.register_craft({
	output = "mining_plus:c_leaves",
	recipe = {
		{"group:leaves", "group:leaves", "group:leaves"},
		{"group:leaves", "group:leaves", "group:leaves"},
		{"group:leaves", "group:leaves", "group:leaves"}
	}
})

minetest.register_craft({
	output = "mining_plus:c_leaves",
	recipe = {
		{"farming:weed", "farming:weed", "farming:weed"},
		{"farming:weed", "farming:weed", "farming:weed"},
		{"farming:weed", "farming:weed", "farming:weed"}
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "mining_plus:c_leaves",
	burntime = 15,
})

if minetest.get_modpath("darkage") then
	minetest.register_craft({
		type = "shapeless",
		output = "default:clay",
		recipe = {
			"darkage:darkdirt", "darkage:darkdirt",
			"default:gravel", "default:sand", "default:junglegrass"
		}
	})
end