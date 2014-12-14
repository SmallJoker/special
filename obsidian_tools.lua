minetest.register_tool(":default:pick_obsidian", {
	description = "Obsidian Pickaxe",
	inventory_image = "default_tool_pickobsidian.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=2.0, [2]=1.2, [3]=1.0}, uses=11, maxlevel=3},
		},
		damage_groups = {fleshy=3},
	},
})
-- diam, mese, steel ++ | wood +1 | 3   stone
minetest.register_tool(":default:shovel_obsidian", {
	description = "Obsidian Shovel",
	inventory_image = "default_tool_shovelobsidian.png",
	wield_image = "default_tool_shovelobsidian.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=3,
		groupcaps={
			crumbly = {times={[1]=1.10, [2]=0.80, [3]=0.50}, uses=11, maxlevel=3},
		},
		damage_groups = {fleshy=2},
	},
})

minetest.register_tool(":default:axe_obsidian", {
	description = "Obsidian Axe",
	inventory_image = "default_tool_axeobsidian.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=2.10, [2]=1.40, [3]=1.10}, uses=11, maxlevel=3},
		},
		damage_groups = {fleshy=3},
	},
})

minetest.register_craft({
	output = "default:pick_obsidian",
	recipe = {
		{"default:obsidian", "default:obsidian", "default:obsidian"},
		{"", "group:stick", ""},
		{"", "group:stick", ""},
	}
})

minetest.register_craft({
	output = "default:axe_obsidian",
	recipe = {
		{"default:obsidian", "default:obsidian", ""},
		{"default:obsidian", "group:stick", ""},
		{"", "group:stick", ""},
	}
})

minetest.register_craft({
	output = "default:shovel_obsidian",
	recipe = {
		{"default:obsidian"},
		{"group:stick"},
		{"group:stick"},
	}
})