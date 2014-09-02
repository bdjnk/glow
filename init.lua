-- Boilerplate to support localized strings if intllib mod is installed.
local S
if intllib then
	S = intllib.Getter()
else
	S = function(s) return s end
end

minetest.register_node("glow:stone_with_worms", {
	description = S("Glow Worms in Stone"),
	tiles = { "default_stone.png^worms.png" },
	is_ground_content = true,
	groups = { cracky = 1 },
	sounds = default.node_sound_stone_defaults(),
	drop = "glow:stone_with_worms",
	paramtype = "light",
	light_source = 4,
})

minetest.register_on_generated(function(minp, maxp, seed)
	local stone_nodes = minetest.find_nodes_in_area(minp, maxp, "default:stone")
	for key, pos in pairs(stone_nodes) do
		if minetest.find_node_near(pos, 1, "air") ~= nil and math.random() < 0.001 and not near_surface(pos) then
			local posNeg = { x=pos.x-6, y=pos.y-6, z=pos.z-6 }
		  local posPos = { x=pos.x+6, y=pos.y+6, z=pos.z+6 }
			local worms = minetest.find_nodes_in_area(posNeg, posPos, "glow:stone_with_worms")
			local lava = minetest.find_nodes_in_area(posNeg, posPos, "default:lava_source")
			local water = minetest.find_nodes_in_area(posNeg, posPos, "group:water")
			if #worms == 0 and #lava == 0 and #water > 0 then
				for nx = -4, 4, 1 do
					for ny = -4, 4, 1 do
						for nz = -4, 4, 1 do
							if math.random() < 0.1 then
								local tpos = { x=pos.x+nx, y=pos.y+ny, z=pos.z+nz }
								if minetest.get_node(tpos).name == "default:stone" then
									minetest.add_node(tpos, { name = "glow:stone_with_worms" })
								end
							end
						end
					end
				end
			end
		end
	end
end)

minetest.register_abm({
	nodenames = { "default:stone" },
	neighbors = { "air" },
	interval = 120.0,
	chance = 200,
	action = function(pos, node, active_object_count, active_object_count_wider)
		if not near_surface(pos) then
			local posNeg = { x=pos.x-6, y=pos.y-6, z=pos.z-6 }
		  local posPos = { x=pos.x+6, y=pos.y+6, z=pos.z+6 }
			local worms = minetest.find_nodes_in_area(posNeg, posPos, "glow:stone_with_worms")
			local lava = minetest.find_nodes_in_area(posNeg, posPos, "default:lava_source")
			local water = minetest.find_nodes_in_area(posNeg, posPos, "group:water")
			if #worms == 0 and #lava == 0  and #water > 0 then
				minetest.add_node(pos, { name = "glow:stone_with_worms" })
			end
		end
	end,
})

minetest.register_abm({
	nodenames = { "glow:stone_with_worms" },
	interval = 60.0,
	chance = 10,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local posNeg = { x=pos.x-2, y=pos.y-2, z=pos.z-2 }
		local posPos = { x=pos.x+2, y=pos.y+2, z=pos.z+2 }
		local worms = minetest.find_nodes_in_area(posNeg, posPos, "glow:stone_with_worms")
		if #worms < 20 and math.random() < 0.7 then
			local apos = { x=pos.x+math.random(-1,1), y=pos.y+math.random(-1,1), z=pos.z+math.random(-1,1) } 
			if minetest.get_node(apos).name == "default:stone" and minetest.find_node_near(pos, 1, "air") ~= nil then
				minetest.add_node(apos, { name = "glow:stone_with_worms" })
			end
		else
			minetest.add_node(pos, { name = "default:stone" })
		end
	end,
})

function near_surface(pos)
	for dx = -1, 1, 1 do
		for dy = -1, 1, 1 do
			for dz = -1, 1, 1 do
				local dpos = { x=pos.x+dx, y=pos.y+dy, z=pos.z+dz }
				local light = minetest.get_node_light(dpos, 0.5)
				if light ~= nil and light > 4 then
					return true
				end
			end
		end
	end
	return false
end

function is_facing(pos, nodename)
	for d = -1, 1, 2 do
		if nodename == minetest.get_node({pos.x+d, pos.y,   pos.z  }).name then return true end
		if nodename == minetest.get_node({pos.x,   pos.y+d, pos.z  }).name then return true end
		if nodename == minetest.get_node({pos.x,   pos.y,   pos.z+d}).name then return true end
	end
	return false
end

minetest.register_node("glow:shrooms", {
	description = S("Glow Shrooms"),
	drawtype = "plantlike",
	tiles = { "shrooms.png" },
	inventory_image = "shrooms.png",
	wield_image = "shrooms.png",
	drop = 'glow:shrooms',
	groups = { snappy=3, flammable=2, flower=1, flora=1, attached_node=1 },
	sunlight_propagates = true,
	walkable = false,
	pointable = true,
	diggable = true,
	climbable = false,
	buildable_to = true,
	paramtype = "light",
	light_source = 3,
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = { -0.4, -0.5, -0.4, 0.4, 0.0, 0.4 },
	},
})

minetest.register_on_generated(function(minp, maxp, seed)
	local tree_nodes = minetest.find_nodes_in_area(minp, maxp, "default:tree")
	for key, pos in pairs(tree_nodes) do
		local bpos = { x=pos.x, y=pos.y-1, z=pos.z }
		if minetest.get_node(bpos).name ~= "default:tree" then
			if math.random() < 0.2 then
				add_shrooms(pos)
			end
		end
	end
end)

minetest.register_abm({
	nodenames = { "default:tree" },
	neighbors = {
		"air",
		"default:dirt",
	},
	interval = 60.0,
	chance = 60,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local posNeg = { x=pos.x-1, y=pos.y-1, z=pos.z-1 }
    local posPos = { x=pos.x+1, y=pos.y+1, z=pos.z+1 }
		local shrooms = minetest.find_nodes_in_area(posNeg, posPos, "glow:shrooms")
		if #shrooms == 0  or (#shrooms == 1 and math.random() < 0.3) then
			add_shrooms(pos)
		end
	end,
})

minetest.register_abm({
	nodenames = { "glow:shrooms" },
	neighbors = {
		"air",
		"default:dirt_with_grass",
	},
	interval = 40.0,
	chance = 10,
	action = function(pos, node, active_object_count, active_object_count_wider)
		if math.random() < 0.3 then
			add_shrooms(pos)
		else
			minetest.remove_node(pos)
		end
	end,
})

function add_shrooms(pos)
	if minetest.find_node_near(pos, 2, "glow:shrooms") == nil then
		for nx = -1, 1, 2 do
			for ny = -1, 1, 1 do
				for nz = -1, 1, 2 do
					local tpos = { x=pos.x+nx, y=pos.y-1+ny, z=pos.z+nz }
					if minetest.get_node(tpos).name == "default:dirt_with_grass" and math.random() < 0.2 then
						local ppos = { x=tpos.x, y=tpos.y+1, z=tpos.z }
						minetest.add_node(ppos, { name = "glow:shrooms" })
					end
				end
			end
		end
	end
end

minetest.register_node("glow:fireflies", {
	description = S("Fireflies"),
	drawtype = "glasslike",
	tiles = {
		{
			name = "fireflies.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2,
			},
		},
	},
	alpha = 100,
	paramtype = "light",
	light_source = 4,
	walkable = false,
	pointable = false,
	diggable = false,
	climbable = false,
	buildable_to = true,
})

minetest.register_abm({
	nodenames = { "air" },
	neighbors = {
		"default:grass_1",
		"default:grass_2",
		"default:grass_3",
		"default:grass_4",
		"default:grass_5",
	},
	interval = 2.0,
	chance = 300,
	action = function(pos, node, active_object_count, active_object_count_wider)
		if minetest.get_timeofday() > 0.74 or minetest.get_timeofday() < 0.22 then
			if minetest.find_node_near(pos, 9, "glow:fireflies") == nil then
				minetest.set_node(pos, {name = "glow:fireflies"})
			end
		end
	end,
})

minetest.register_abm({
	nodenames = {"glow:fireflies"},
	interval = 1.0,
	chance = 2,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.remove_node(pos)
	end,
})
