minetest.register_chatcommand("mypos", {
	description = "What is my position?",
	privs = {interact=true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local pos = vector.round(player:getpos())
		minetest.chat_send_player(name, "Your coordiantes: "..minetest.pos_to_string(pos))
	end,
})

if special_is_enabled("slap_command") then
	local last_slap = ""
	minetest.register_chatcommand("slap", {
		description = "Slaps <player>",
		params = "<player>",
		privs = {interact=true, fast=true},
		func = function(name, param)
			local target = minetest.get_player_by_name(param)
			if not target then
				minetest.chat_send_player(name, "Player "..param.." was not found.")
				return
			end
			if last_slap == param then
				minetest.chat_send_player(name, "That person does not deserve to be slapped twice in a row.")
				return
			end
			last_slap = param
			local pos = vector.round(target:getpos())
			minetest.sound_play("special_slap", {
				pos = pos,
				max_hear_distance = 3,
				gain = 0.4,
			})
			minetest.chat_send_all(name.." slaps "..param.." around a bit with a large trout")
		end,
	})
end

if special_is_enabled("plant_command") then
	minetest.register_chatcommand("plant", {
		description = "Plants trees arund you",
		privs = {server=true},
		func = function(name, param)
			minetest.chat_send_player(name, "Creating trees...")
			local pos = minetest.get_player_by_name(name):getpos()
			pos = vector.round(pos)
			local minp = {x=pos.x-32, y=pos.y-16, z=pos.z-32}
			local maxp = {x=pos.x+32, y=pos.y+16, z=pos.z+32}
			
			local vm = minetest.get_voxel_manip()
			local minp, maxp = vm:read_from_map(minp, maxp)
			local area = VoxelArea:new{MinEdge=minp, MaxEdge=maxp}
			local data = vm:get_data()
			local grass_pos = minetest.find_nodes_in_area(minp, maxp, "default:dirt_with_grass")
			local c_air = minetest.get_content_id("air")

			local count = 0
			for i, p in pairs(grass_pos) do
				if math.random(60) == 10 then
					p.y = p.y + 1
					if data[area:index(p.x, p.y, p.z)] == c_air then
						default.grow_sapling(pos)
						count = count + 1
					end
				end
			end

			minetest.chat_send_player(name, "Planted "..count.." new trees!")
			minetest.log("info", name.." planted "..count.." trees")
		end,
	})
end