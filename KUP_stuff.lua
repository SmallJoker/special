-- JAIL START [
jail = {}
jail.min = {x=22,y=6,z=32}
jail.max = {x=47,y=15,z=47}
jail.jin = {x=26,y=11,z=38}
jail.jout = {x=21,y=11,z=37}

minetest.register_chatcommand("gojail", {
	params = "<name>",
	description = "Sends someone to jail.",
	privs = {interact=true, fast=true},
	func = function(name, param)
		if param == "" then
			local player = minetest.get_player_by_name(name)
			if(player ~= nil) then
				player:setpos(jail.jin)
			end
			return
		end
		if not minetest.check_player_privs(name, {ban=true}) then
			minetest.chat_send_player(name, "You do not have the permission to send players to jail.")
			return
		end
		if not minetest.auth_table[param] then
			minetest.chat_send_player(name, "Player "..param.." does not exist.")
			return
		end
		local priv = minetest.get_player_privs(param)
		if not priv.fast then
			minetest.chat_send_player(name, "'"..param.."' is already in the jail.")
			return
		end
		if priv.ban or priv.landrush then
			minetest.chat_send_player(name, "'"..param.."' can not go to jail.")
			return
		end
		priv["fast"] = nil
		--priv["interact"] = nil
		minetest.set_player_privs(param, priv)
		minetest.chat_send_player(param, "You are a prisoner now. Think about the things you did wrong!", true)
		
		local player = minetest.get_player_by_name(param)
		if player then
			player:setpos(jail.jin)
		end
		minetest.chat_send_player(name, "Sent '"..param.."' to jail.", true)
	end,
})

minetest.register_chatcommand("leavejail", {
	params = "<name>",
	description = "Lets someone leave the jail.",
	privs = {ban=true},
	func = function(name, param)
		if not minetest.auth_table[param] then
			minetest.chat_send_player(name, "Player "..param.." does not exist.")
			return
		end
		local priv = minetest.get_player_privs(param)
		if priv.fast and priv.interact then
			minetest.chat_send_player(name, "'"..param.."' is not in the jail.")
			return
		end
		priv["fast"] = true
		priv["interact"] = true
		minetest.set_player_privs(param, priv)
		minetest.chat_send_player(param, "You are now a free person. I hope we will never see us again.", true)
		--print("Jail: - "..param.." (by "..name..")")
		local player = minetest.get_player_by_name(param)
		if player then
			if player:get_hp() > 0 then
				player:setpos(jail.jout)
			end
		end
		minetest.chat_send_player(name, "'"..param.."' is free now.", true)
		if notes then
			--player_notes.add_note("JAIL", param, "leavejail by "..name)
		end
	end,
})

minetest.register_on_respawnplayer(function(obj)
	local priv = minetest.get_player_privs(obj:get_player_name())
	if priv.fast then
		if not priv.interact then
			priv["interact"] = true
			minetest.set_player_privs(obj:get_player_name(), priv)
		end
		return false
	end
	obj:setpos(jail.jin)
	return true
end)

local ttime = 0
minetest.register_globalstep(function(dtime)
	ttime = ttime + dtime
	if ttime < 8 then
		return
	end
	ttime = 0
	for _,player in ipairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		if not minetest.get_player_privs(name).fast then
			local plpos = player:getpos()
			if(plpos.x > jail.max.x or plpos.x < jail.min.x or
					plpos.y > jail.max.y or plpos.y < jail.min.y or
					plpos.z > jail.max.z or plpos.z < jail.min.z) then
				minetest.chat_send_player(name, "Gotcha! Go back to jail!")
				player:setpos(jail.jin)
				print(name.." tried to break out of the jail.")
			end
		end
	end
end)
-- ] JAIL END

-- SPAWN START [
minetest.register_chatcommand("spawn", {
	description = "Teleports you to your starting point.",
	params = "<optional name>",
	privs = {fast=true},
	func = function(name, param)
		if param == "" then
			param = "default"
		end
		
		local pos = cust_spawns[param]
		
		if pos then
			local player = minetest.get_player_by_name(name)
			player:setpos(pos)
			minetest.chat_send_player(name, "Teleporting to spawn: ".. param)
			return
		end
		
		local spawnlist = "default"
		for name, spos in pairs(cust_spawns) do
			if name ~= "default" then
				spawnlist = spawnlist..", "..name
			end
		end
		minetest.chat_send_player(name, "Spawn '"..param.."' not found. Available spawns: "..spawnlist)
	end,
})

cust_spawns = { }
if minetest.setting_get("static_spawnpoint") then
	cust_spawns["default"] = minetest.setting_get_pos("static_spawnpoint")
	if not cust_spawns["default"] then
		cust_spawns["default"] = {x=0,y=10,z=0}
	end
end
cust_spawns["gglp'scity"] = {x=804, y=17, z=-933}
cust_spawns["greentown"] = {x=88, y=16, z=-328}
cust_spawns["flowertower"] = {x=455, y=11, z=120}
-- ] SPAWN END