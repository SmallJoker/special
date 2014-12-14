minetest.register_craft({
	output = "special:cleaner",
	recipe = {
		{ "", "wool:blue", "" },
		{ "default:steel_ingot", "default:steel_ingot", "default:steel_ingot" },
		{ "wool:white", "wool:white", "wool:white" },
	}
})

minetest.register_tool("special:cleaner", {
	description = "Cleaner",
	inventory_image = "cleaner.png",
	wield_image = "cleaner.png^[transformR180",
	on_use = function(itemstack, player, pointed_thing)
		local collected = 1
		local pos = vector.round(player:getpos())
		local drops = {}
		pos.y = pos.y + 1
		local all_obj = minetest.get_objects_inside_radius(pos, 10)
		for _,obj in ipairs(all_obj) do
			if not obj:is_player() and
					obj:get_luaentity().name == "__builtin:item" then
				local opos = vector.round(obj:getpos())
				local itemstring = obj:get_luaentity().itemstring
				local stack = ItemStack(itemstring)
				local item_name = stack:get_name()
				local item_count = stack:get_count()
				local stack_max = stack:get_stack_max()
				
				if stack_max > 1 and item_name ~= "" then
					if drops[item_name] then
						drops[item_name][1] = drops[item_name][1] + item_count
					else
						drops[item_name] = {item_count, stack_max}
					end
					obj:get_luaentity().itemstring = ""
					obj:remove()
				end
			end
		end
		for item,inf in pairs(drops) do
			while inf[1] > inf[2] do
				minetest.add_item(pos, item.." "..inf[2])
				inf[1] = inf[1] - inf[2]
			end
			minetest.add_item(pos, item.." "..inf[1])
			collected = collected + 1
		end
		itemstack:add_wear(collected * 400)
		return itemstack
	end
})