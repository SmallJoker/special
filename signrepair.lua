minetest.register_tool("special:signrepair", {
	description = "Sign repair tool",
	inventory_image = "anytool.png",
	stack_max = 1,
	groups = {not_in_creative_inventory=1},
	on_use = function(itemstack, player, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		local meta = minetest.get_meta(pointed_thing.under)
		if meta and meta:get_string("formspec") == "hack:sign_text_input" then
			meta:set_string("formspec", "field[text;;${text}]")
			minetest.chat_send_player(player:get_player_name(), "Repaired "..minetest.pos_to_string(pointed_thing.under))
		end
		itemstack:add_wear(170)
		return itemstack
	end
})