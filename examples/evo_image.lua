local field2D = require "field2D"

local dimx, dimy = 600, 400
local image = field2D(dimx, dimy)

math.randomseed(os.time())

function genome_random()
	return {
		math.random(),
		math.random(),
		math.random(),
		math.random(),
	}
end

local genome = genome_random()

-- how to render a particular cell:
function render(x, y)
	local nx = x / dimx
	local ny = y / dimy
	
	-- some function of the genome here:
	local ax = genome[1]
	local ay = genome[2]
	local mx = genome[3] * 10
	local my = genome[4] * 10
	
	-- simplest function of x,y and genome:
	v = (nx + ax) * mx + (ny + ay) * my
	
	return v % 1
end


image:set(render)

function update()
	genome = genome_random()
	image:set(render)
end


function draw()

	image:draw()

end

