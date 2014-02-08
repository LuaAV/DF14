
-- http://en.wikipedia.org/wiki/Fractal_flame

-- V
local operators = {
	function(x, y) return x, y end,
	function(x, y) return sin(x), sin(y) end,
	function(x, y) 
		local m = x*x + y*y
		return x/m, y/m
	end,
}

function F(x, y, operator_weights)
	local xout, yout = 0, 0
	for i, op in ipairs(operators) do
		local w = operator_weights[i]
		local x1, y1 = op(x, y)
		xout = xout + x1 * w
		yout = yout + y1 * w
	end
	return xout, yout
end

-- pick a random point
local p = vec3(math.random, math.random(), math.random())

-- pick an equation from a weighted set:
local F, a, b, c, d, e, f = pick_function()

local v = F(a*p.x + b*p.y + c, d*x + e*y + f)