minetest.register_node("glow:stone_with_worms", {
	description = "Glow Worms in Stone",
	tiles = {"default_stone.png^worms.png"},
	is_ground_content = true,
	groups = {cracky=1},
	drop = "glow:stone_with_worms",
	paramtype = "light",
	light_source = 4,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "glow:stone_with_worms",
	wherein        = "default:stone",
	clust_scarcity = 600,
	clust_num_ores = 3,
	clust_size     = 9,
	height_min     = -100,
	height_max     = 20,
})

minetest.register_node("glow:shrooms", {
	description = "Glow Shrooms",
	drawtype = "plantlike",
	tiles = { "shrooms.png" },
	inventory_image = "shrooms.png",
	wield_image = "shrooms.png",
	drop = 'glow:shrooms',
	groups = { snappy = 3, flammable=2, flower=1, flora=1, attached_node=1 },
	sunlight_propagates = true,
	walkable = false,
	pointable = true,
	diggable = true,
	climbable = false,
	buildable_to = true,
	paramtype = "light",
	light_source = 4,
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
		if minetest.get_node(bpos).name ~= "default:tree" and math.random() <= 0.2 then
			for nx = -1, 1, 2 do
				for ny = -1, 1, 2 do
					for nz = -1, 1, 2 do
						local tpos = { x=bpos.x+nx, y=bpos.y+ny, z=bpos.z+nz }
						if minetest.get_node(tpos).name == "default:dirt_with_grass" then
							local ppos = { x=tpos.x, y=tpos.y+1, z=tpos.z }
							minetest.add_node(ppos, { name = "glow:shrooms" })
						end
					end
				end
			end
		end
	end
end)
