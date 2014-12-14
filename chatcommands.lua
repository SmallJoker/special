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
				minetest.chat_send_player(name, "Can not slap player '"..param.."', player not found.")
				return
			end
			if last_slap == param then
				minetest.chat_send_player(name, "You are not very nice :(")
				return
			end
			last_slap = param
			local pos = vector.round(target:getpos())
			minetest.sound_play("special_slap", {
				pos = pos,
				max_hear_distance = 3,
				gain = 0.5,
			})
			minetest.chat_send_all(name.." slaps "..param.." around a bit with a large trout")
			local hp = target:get_hp()
			target:set_hp(hp - 1)
			if hp == 1 then
				print(name.." killed "..param.." by remote slapping")
			end
		end,
	})
end

-- PING START [
local pinger = {
	ttime = 0,
	count = 0,
	player = ""
}

minetest.register_chatcommand("ping", {
	description = "Pings the server!",
	privs = {interact=true},
	func = function(name, param)
		pinger.player = name
		pinger.ttime = 0
		pinger.count = 1
		minetest.chat_send_player(name, "Ping sent!")
	end,
})

minetest.register_globalstep(function(t)
	if pinger.count < 1 then
		return
	end
	if pinger.count > 8 then
		local ntime = math.floor((pinger.ttime*100)+0.5) / 100
		minetest.chat_send_player(pinger.player, "Pong! after "..ntime.."s")
		minetest.log("info", "Pong, "..(pinger.player).."! "..ntime.."s")
		pinger.player = ""
		pinger.ttime = 0
		pinger.count = 0
	else
		pinger.ttime = pinger.ttime + t
		pinger.count = pinger.count + 1
	end
end)
-- ] PING END

if special_is_enabled("plant_command") then
	-- Incompatible with MTG
	minetest.register_chatcommand("plant", {
		description = "Nature++",
		privs = {server=true},
		func = function(name, param)
			minetest.chat_send_player(name, "Creating trees...")
			local pos = minetest.get_player_by_name(name):getpos()
			pos = vector.round(pos)
			local minp = {x=pos.x-32, y=pos.y-16, z=pos.z-32}
			local maxp = {x=pos.x+32, y=pos.y+16, z=pos.z+32}
			local count = 0
			local vm = minetest.get_voxel_manip()
			local minp, maxp = vm:read_from_map(minp, maxp)
			local area = VoxelArea:new{MinEdge=minp, MaxEdge=maxp}
			local data = vm:get_data()
			local grass_pos = minetest.find_nodes_in_area(minp, maxp, "default:dirt_with_grass")
			local c_air = minetest.get_content_id("air")
			
			--local border = {x=maxp.x-p.x,y=maxp.y-p.y,z=maxp.z-p.z}
			for i,p in ipairs(grass_pos) do
				if math.random(60) == 10 then
					--if border.x < 2 or border.x > 30 
					p.y = p.y + 1
					if data[area:index(p.x, p.y, p.z)] == c_air then
						default.grow_tree(data, area, p, math.random(1, 4) == 1, math.random(1,100000))
						count = count + 1
					end
				end
			end
			
			vm:set_data(data)
			vm:write_to_map(data)
			vm:update_map()
			minetest.chat_send_player(name, "Planted "..count.." new trees!")
			minetest.log("info", name.." planted "..count.." trees")
		end,
	})
end