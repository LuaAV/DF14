local draw2D = require "draw2D"
local vec2 = require "vec2"

local random = math.random
function srandom() return random()*2-1 end

--[[
-- gene structure:
function make_genome()
	return {
		-- form:
		random(math.pi * 2),	-- front angle
		random(math.pi * 2),	-- rear angle
		srandom() * 9,			-- front elongation
		srandom() * 9,			-- rear elongation
		srandom() * 9,			-- expand X
		srandom() * 9,			-- expand Y
		random(9),				-- iterations
		srandom() * 1.5,		-- gradient
		-- color:
		random(),				-- red component
		random(),				-- green component
		random(),				-- blue component
	}	
end
--]]


-- http://www.well.com/~hernan/biomorphs/biomorphs.js
function rand20() return math.random(21)-1 end

function copy_genome(g) return { unpack(g) } end

function mutate_genome(g)
	-- which one to mutate:
	local gene = math.random(#g)
	-- create a copy:
	local genome = copy_genome(g)
	-- mutate +1 or -1:
	if math.random(2) == 1 then
		genome[gene] = (g[gene] + 1) % 21
	else
		genome[gene] = (g[gene] - 1) % 21
	end
	return genome
end

function make_biomorph()
	local genome = {}
	
	function genome:randomize()
		for i = 1, 11 do
			self[i] = rand20()
		end
	end
	
	function genome:draw(width, height)
		local x, y = width/2, height/2
		local treedepth = genes[0] % 9 + 1 -- from 1..10
		local growdirection = vec2(0, 1)
		self:drawtree(x, y, treedepth, growdirection)
	end
	
	function genome:drawtree(x, y, treedepth, growdirection)
		local xgene = (treedepth % 3) + 1
		local ygene = xgene + 3
		local i = x + 
	end
end




