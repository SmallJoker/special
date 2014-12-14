-- Chainsaw tool created by Krock
-- License: WTFPL

local chainsaw_dig = { "bamboo:bamboo", "default:cactus", "default:papyrus" }
local chainsaw_drops = {}

minetest.register_tool(":bitchange:chainsaw", {
	description = "Chainsaw",
	inventory_image = "chainsaw.png",
	stack_max = 1,
	on_use = function(itemstack, player, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		local pos = pointed_thing.under
		chainsaw_drops = {}
		local wear = chainsaw_saw(pos, itemstack:get_wear(), player:get_player_name())
		itemstack:add_wear(wear * 25)
		pos = pointed_thing.above
		local inv = player:get_inventory()
		for item,count in pairs(chainsaw_drops) do
			while count > 99 do
				if inv:room_for_item("main", item.." 99") then
					inv:add_item("main", item.." 99")
				else
					minetest.add_item(pos, item.." 99")
				end
				count = count - 99
			end
			if inv:room_for_item("main", item.." "..count) then
				inv:add_item("main", item.." "..count)
			else
				minetest.add_item(pos, item.." "..count)
			end
		end
		chainsaw_drops = {}
		return itemstack
	end,
})

function chainsaw_saw(pos, old_wear, player_name)
	local lastname = "xyz"
	local wear = 0
	local npos = {x = pos.x - 1, y = pos.y, z = pos.z - 1}
	if minetest.is_protected(pos, player_name) then
		minetest.record_protection_violation(pos, player_name)
		return 0
	end
	for _a = -1, 2 do
	for _c = -1, 2 do
	for _b = 1, 32 do
		if old_wear + (wear * 25) > 65535 then
			return wear
		end
		local jump_check = false
		local node = minetest.get_node(npos)
		if node.name ~= "ignore" and node.name ~= "air" and node.name ~= "default:water_flowing" then
			if lastname == node.name then
				jump_check = true
			end
			local nwear = chainsaw_saw_one(npos, node.name, jump_check)
			if nwear > 0 then
				wear = wear + nwear
				lastname = node.name
				minetest.remove_node(npos)
			end
		end
		npos.y = npos.y + 1
	end
	npos.y = pos.y
	npos.z = pos.z + _c
	end
	npos.x = pos.x + _a
	end
	return wear
end

function chainsaw_saw_one(pos, node_name, jump_check)
	local grp = minetest.registered_nodes[node_name]
	if not grp or not grp.groups then
		return 5
	end
	if grp.groups.leaves then
		if math.random(3) ~= 2 then
			return 0
		end
		jump_check = (grp.groups.leaves or grp.groups.tree)
	end
	if not jump_check then
		local contains = false
		if grp.groups.tree then
			contains = true
		end
		if not contains then
			for _, listname in pairs(chainsaw_dig) do
				if(node_name == listname) then
					contains = true
					break
				end
			end
		end
		if not contains then
			return 0
		end
	end
	
	minetest.remove_node(pos)
	local drops = minetest.get_node_drops(node_name)
	for _, item in ipairs(drops) do
		local stack = ItemStack(item)
		local item_name = stack:get_name()
		local item_count = stack:get_count()
		
		if chainsaw_drops[item_name] then
			chainsaw_drops[item_name] = chainsaw_drops[item_name] + item_count
		else
			chainsaw_drops[item_name] = item_count
		end
	end
	if grp.groups.tree then
		return 8
	elseif grp.groups.leaves then
		return 1
	else
		return 3
	end
end

minetest.register_craft({
	output = "bitchange:chainsaw",
	recipe = {
		{"default:copper_ingot", "default:steel_ingot", "default:diamond"},
		{"default:copperblock", "default:mese_crystal_fragment", "default:steel_ingot"},
	}
})