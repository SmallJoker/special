local u = moretrees.beech_model
u.rules_a		= "[&FFBFFA]////[&BFFFFA]////[&FBFFFA]"
u.rules_b		= "[&FFFA]////[&FFFA]////[&FFFA]"
u.rules_c		= nil
u.rules_d		= nil
u.angle			= 40
u.iterations	= 1
u.random_level	= 2
u.trunk_type	= "double"

moretrees.sequoia_model.axiom = "FFFFFFFFFFddccA///cccFddcFA///ddFcFA/cFFddFcdBddd"

for i, v in ipairs(moretrees.treelist) do
	local treename = v[1]
	local treedesc = v[2]
	
	if treename ~= "jungletree" then
		minetest.register_craftitem(":moretrees:"..treename.."_stick", {
			description = treedesc.." Stick",
			inventory_image = "moretrees_"..treename.."_stick.png",
			groups = {stick=1},
		})
		
		local droprarity = 100
		
		if treename == "palm" then
			droprarity = 20
		end
		
		minetest.override_item("moretrees:"..treename.."_leaves", {
			drop = {
				max_items = 1,
				items = {
					{items = {"moretrees:"..treename.."_sapling"}, rarity = droprarity },
					{items = {"moretrees:"..treename.."_stick"}, rarity = 40 },
					{items = {"moretrees:"..treename.."_leaves"} }
				}
			},
		})
		
		minetest.register_craft({
			output = "moretrees:"..treename.."_planks",
			recipe = {
				{"moretrees:"..treename.."_stick", "moretrees:"..treename.."_stick"},
				{"moretrees:"..treename.."_stick", "moretrees:"..treename.."_stick"},
			}
		})
		
		minetest.register_craft({
			output = "moretrees:"..treename.."_stick 4",
			recipe = {
				{"moretrees:"..treename.."_planks"},
			}
		})
	end
end

minetest.register_craft({
	output = "moretrees:mixedwood 2",
	recipe = {
		{"", "group:stick", "group:stick"},
		{"group:stick", "group:stick", "group:stick"},
		{"group:stick", "group:stick", "group:stick"}
	}
})

minetest.register_node(":moretrees:mixedwood", {
	description = "Mixed wooden planks",
	tiles = {"moretrees_mixedwood.png"},
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1},
	sounds = default.node_sound_wood_defaults(),
})