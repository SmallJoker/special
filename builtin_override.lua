-- Overrides some builtin things
-- 

minetest.registered_privileges["kick"] = nil
minetest.registered_privileges["bring"] = nil
minetest.registered_privileges["password"] = nil
minetest.chatcommands["setpassword"].privs = {server=true}
minetest.chatcommands["clearpassword"].privs = {server=true}

minetest.register_chatcommand("kick", {
	params = "<name> [reason]",
	description = "kick a player",
	privs = {ban=true},
	func = function(name, param)
		local tokick, reason = param:match("([^ ]+) (.+)")
		tokick = tokick or param
		if not minetest.kick_player(tokick, reason) then
			return false, "Failed to kick player "..tokick
		end
		minetest.chat_send_all(tokick.." kicked by "..name.." ("..(reason or "")..")")
		return
	end,
})

minetest.register_chatcommand("teleport", {
	params = "<X>,<Y>,<Z> | <to_name> | <name> <X>,<Y>,<Z> | <name> <to_name>",
	description = "teleport to given position",
	privs = {teleport=true},
	func = function(name, param)
		-- Returns (pos, true) if found, otherwise (pos, false)
		local function find_free_position_near(pos)
			local tries = {
				{x=1,y=0,z=0},
				{x=-1,y=0,z=0},
				{x=0,y=0,z=1},
				{x=0,y=0,z=-1},
			}
			for _, d in ipairs(tries) do
				local p = {x = pos.x+d.x, y = pos.y+d.y, z = pos.z+d.z}
				local n = minetest.get_node_or_nil(p)
				if n and n.name then
					local def = minetest.registered_nodes[n.name]
					if def and not def.walkable then
						return p, true
					end
				end
			end
			return pos, false
		end

		local teleportee = nil
		local p = {}
		p.x, p.y, p.z = string.match(param, "^([%d.-]+)[, ] *([%d.-]+)[, ] *([%d.-]+)$")
		p.x = tonumber(p.x)
		p.y = tonumber(p.y)
		p.z = tonumber(p.z)
		teleportee = minetest.get_player_by_name(name)
		if teleportee and p.x and p.y and p.z then
			teleportee:setpos(p)
			return true, "Teleporting to "..minetest.pos_to_string(p)
		end
		
		local teleportee = nil
		local p = nil
		local target_name = nil
		target_name = param:match("^([^ ]+)$")
		teleportee = minetest.get_player_by_name(name)
		if target_name then
			local target = minetest.get_player_by_name(target_name)
			if target then
				p = target:getpos()
			end
		end
		if teleportee and p then
			p = find_free_position_near(p)
			teleportee:setpos(p)
			return true, "Teleporting to " .. target_name
					.. " at "..minetest.pos_to_string(p)
		end
		
			local teleportee = nil
			local p = {}
			local teleportee_name = nil
			teleportee_name, p.x, p.y, p.z = param:match(
					"^([^ ]+) +([%d.-]+)[, ] *([%d.-]+)[, ] *([%d.-]+)$")
			p.x, p.y, p.z = tonumber(p.x), tonumber(p.y), tonumber(p.z)
			if teleportee_name then
				teleportee = minetest.get_player_by_name(teleportee_name)
			end
			if teleportee and p.x and p.y and p.z then
				teleportee:setpos(p)
				return true, "Teleporting " .. teleportee_name
						.. " to " .. minetest.pos_to_string(p)
			end
			
			local teleportee = nil
			local p = nil
			local teleportee_name = nil
			local target_name = nil
			teleportee_name, target_name = string.match(param, "^([^ ]+) +([^ ]+)$")
			if teleportee_name then
				teleportee = minetest.get_player_by_name(teleportee_name)
			end
			if target_name then
				local target = minetest.get_player_by_name(target_name)
				if target then
					p = target:getpos()
				end
			end
			if teleportee and p then
				p = find_free_position_near(p)
				teleportee:setpos(p)
				return true, "Teleporting " .. teleportee_name
						.. " to " .. target_name
						.. " at " .. minetest.pos_to_string(p)
			end

		return false, 'Invalid parameters ("' .. param
				.. '") or player not found (see /help teleport)'
	end,
})

function builtin_item_on_fallstop(self, pos, node) end
local time_to_live = tonumber(minetest.setting_get("item_entity_ttl")) or (30 * 60)

minetest.register_entity(":__builtin:item", {
	initial_properties = {
		hp_max = 1,
		physical = true,
		collide_with_objects = false,
		collisionbox = {-0.2, -0.2, -0.2, 0.2, 0.2, 0.2},
		visual = "wielditem",
		visual_size = {x = 0.3, y = 0.3},
		textures = {""},
		spritediv = {x = 1, y = 1},
		initial_sprite_basepos = {x = 0, y = 0},
		automatic_rotate = 3.14 * 0.1,
		is_visible = false,
	},
	
	itemstring = "",
	physical_state = true,
	age = 0,

	set_item = function(self, itemstring)
		local stack = ItemStack(itemstring)
		local count = stack:get_count()
		local itemname = stack:get_name()
		local max_count = stack:get_stack_max()
		
		if count > max_count then
			count = max_count
			self.itemstring = itemname.." "..max_count
		else
			self.itemstring = itemstring
		end
		if max_count < 4 then
			max_count = 4
		end
		local a = 0.2 + 0.2 * (count / max_count)
		
		local prop = {
			is_visible = true,
			visual = "wielditem",
			textures = {itemname},
			visual_size = {x=a, y=a},
			collisionbox = {-a, -a, -a, a, a, a}
		}
		self.object:set_properties(prop)
	end,

	get_staticdata = function(self)
		return minetest.serialize({
			itemstring = self.itemstring,
			always_collect = self.always_collect,
			age = self.age
		})
	end,

	on_activate = function(self, staticdata, dtime_s)
		if string.sub(staticdata, 1, string.len("return")) == "return" then
			local data = minetest.deserialize(staticdata)
			if data and type(data) == "table" then
				self.itemstring = data.itemstring
				self.always_collect = data.always_collect
				self.age = data.age or 0
			end
		else
			self.itemstring = staticdata
		end
		self.object:set_armor_groups({immortal=1})
		self.object:setvelocity({x=0, y=2, z=0})
		self.object:setacceleration({x=0, y=-10, z=0})
		self:set_item(self.itemstring)
	end,

	on_step = function(self, dtime)
		self.age = self.age + dtime
		if time_to_live > 0 and self.age > time_to_live then
			self.itemstring = ""
			self.object:remove()
			return
		end
		
		local p = self.object:getpos()
		p.y = p.y - 0.4
		local node = minetest.get_node(p)
		local def = minetest.registered_nodes[node.name]
		
		local fall = (def and not def.walkable)
		if self.physical_state == fall then
			return
		end
		
		self.object:setvelocity({x=0, y=0, z=0})
		if fall then
			self.object:setacceleration({x=0, y=-10, z=0})
		else
			builtin_item_on_fallstop(self, vector.round(p), node)
			self.object:setacceleration({x=0, y=0, z=0})
		end
		self.physical_state = fall
		self.object:set_properties({
			physical = fall
		})
	end,

	on_punch = function(self, hitter)
		if self.itemstring ~= "" then
			local left = hitter:get_inventory():add_item("main", self.itemstring)
			if not left:is_empty() then
				self.itemstring = left:to_string()
				return
			end
		end
		self.itemstring = ""
		self.object:remove()
	end,
})