minetest.register_node(":moreblocks:copper_stone", {
	description = "Copper stone",
	tiles = {"moreblocks_copper_stone.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_craft({
	output = "moreblocks:copper_stone",
	recipe = {{"default:copper_lump", "default:stone"}},
})

minetest.register_craft({
	output = "default:copper_lump",
	recipe = {{"moreblocks:copper_stone"}},
})

minetest.register_craft({
	output = "default:coal_lump",
	recipe = {{"moreblocks:coal_stone"}},
})

minetest.register_craft({
	output = "default:iron_lump",
	recipe = {{"moreblocks:iron_stone"}},
})