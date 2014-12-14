minetest.override_item("farming_plus:potato_item", {
	description = "Raw potato"
})

minetest.register_craft({
	type = "cooking",
	recipe = "farming_plus:potato_item",
	output = "farming_plus:potato_cooked",
})

minetest.register_craftitem(":farming_plus:potato_cooked", {
	description = "Potato",
	inventory_image = "farming_potato_cooked.png",
	on_use = minetest.item_eat(4),
})

minetest.register_craftitem(":farming_plus:cocoa_bean", {
	description = "Cocoa bean",
	inventory_image = "farming_cocoa_bean.png",
	on_use = minetest.item_eat(1),
})

minetest.register_craftitem(":farming_plus:rhubarb_item", {
	description = "Rhubarb",
	inventory_image = "farming_rhubarb.png",
	on_use = minetest.item_eat(2),
})
