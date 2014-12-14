function special_is_enabled(setting, modname, logic)
	if logic == nil then
		logic = true -- [true] = mod must be enabled
	end
	
	if not minetest.setting_getbool("special_"..setting) then
		return false
	end
	if modname then
		if minetest.get_modpath(modname) then
			return logic
		else
			return (not logic)
		end
	end
	return true
end

local modpath = minetest.get_modpath("special")
dofile(modpath.."/chatcommands.lua")
dofile(modpath.."/craftings.lua")
if special_is_enabled("sign_repair") then
	dofile(modpath.."/signrepair.lua")
end
if special_is_enabled("cleaner_tool") then
	dofile(modpath.."/cleaner.lua")
end
if special_is_enabled("exchange_shop", "bitchange", false) then
	dofile(modpath.."/shop.lua")
end
if special_is_enabled("farming_tweak", "farming_plus") then
	dofile(modpath.."/farming.lua")
end
if special_is_enabled("grinder", "mining_plus", false) then
	dofile(modpath.."/grinder.lua")
end
if special_is_enabled("moretrees_tweak", "moretrees") and 
		not minetest.registered_nodes["moretrees:willow_stick"] then
	dofile(modpath.."/moretrees.lua")
end
if special_is_enabled("builtin_override") then
	dofile(modpath.."/builtin_override.lua")
end
if special_is_enabled("autoplant_saplings") then
	if special_is_enabled("builtin_override") then
		dofile(modpath.."/sapling_planter.lua")
	else
		minetest.log("info", ("Could not enable the sapling auto-planter: "..
				"It depends on the setting special_builtin_override."))
	end
end
if special_is_enabled("obsidian_tools") then
	dofile(modpath.."/obsidian_tools.lua")
end
if special_is_enabled("chainsaw") then
	dofile(modpath.."/chainsaw.lua")
end
if special_is_enabled("moreblocks_tweak", "moreblocks") then
	dofile(modpath.."/moreblocks.lua")
end
if special_is_enabled("flint") then
	dofile(modpath.."/flint.lua")
end
if special_is_enabled("plantlike_torch") then
	dofile(modpath.."/xtorch.lua")
end
if special_is_enabled("KUP_stuff") then
	dofile(modpath.."/KUP_stuff.lua")
end

minetest.register_alias("special:xtorch", "darkage:lamp")
minetest.register_alias("mining_plus:air_bottle", "default:gold_ingot")

-- SET HEALTH [
minetest.register_on_leaveplayer(function(player)
	if player:get_hp() <= 0 then
		player:set_hp(10)
	end
end)
-- ] SET HEALTH END

dofile(modpath.."/craftings.lua")