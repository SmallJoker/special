function builtin_item_on_fallstop(self, pos, node)
	if minetest.get_item_group(node.name, "soil") == 0 then
		return
	end

	if minetest.is_protected(pos, ":nobody") then
		return
	end
	
	local stack = ItemStack(self.itemstring)
	if stack:get_count() > 1 then
		return
	end
	
	if minetest.find_node_near(pos, 3, {"group:sapling", "group:tree"}) then
		return
	end
	
	local item = stack:get_name()
	if minetest.get_item_group(item, "sapling") == 0 then
		return
	end
	
	pos.y = pos.y + 1
	if minetest.get_node(pos).name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = item})
	self.itemstring = ""
	self.object:remove()
end