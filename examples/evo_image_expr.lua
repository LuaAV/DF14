
-- geno is a series of numbers
-- pheno is an expression tree
-- interpret geno item as an operator or number
-- operators may need to consume additional elements for their arguments

win:setdim(400, 100)

local format = string.format
math.randomseed(os.time())

function arg(stack, n)
	local n = n or 1
	return stack[math.max(1, #stack - n + 1)]
end

operators = {
	function(stack, g, i)
		local a = arg(stack, g[i+1])
		local b = arg(stack, g[i+2])
		local c = arg(stack, g[i+2])
		return format("(%s > 0 and %s or %s)", a, b, c), 3
	end,
	-- add
	function(stack, g, i)
		local a = arg(stack, g[i+1])
		local b = arg(stack, g[i+2])
		return format("(%s + %s)", a, b), 2
	end,
	-- sub
	function(stack, g, i)
		local a = arg(stack, g[i+1])
		local b = arg(stack, g[i+2])
		return format("(%s ^ %s)", a, b), 2
	end,
	-- mul
	function(stack, g, i)
		local a = arg(stack, g[i+1])
		local b = arg(stack, g[i+2])
		return format("(%s * %s)", a, b), 2
	end,
	function(stack, g, i)
		local a = arg(stack, g[i+1])
		local b = arg(stack, g[i+2])
		return format("(%s %% %s)", a, b), 2
	end,
	function(stack, g, i)
		local a = arg(stack, g[i+1])
		local b = arg(stack, g[i+2])
		return format("math.atan2(%s, %s)", a, b), 2
	end,
	function(stack, g, i)
		local a = arg(stack, g[i+1])
		local b = arg(stack, g[i+2])
		return format("(%s > %s and 1 or 0)", a, b), 2
	end,
	-- sin
	function(stack, g, i)
		local a = arg(stack, g[i+1])
		return format("math.sin(%s)", a), 1
	end,
	function(stack, g, i)
		local a = arg(stack, g[i+1])
		return format("math.cos(%s)", a), 1
	end,
	function(stack, g, i)
		return "math.random()", 0
	end,
}

function interpret(g)
	local stack = { "1", "x", "y" }
	local stats = {}
	local i = 1
	while i <= #g do
		local op = operators[ g[i] ]
		local str, consumed = op(stack, g, i+1)
		local name = format("v%d", #stack+1)
		stack[#stack+1] = name
		stats[#stats+1] = format("local %s = %s", name, str)
		i = i + consumed + 1
	end
	stats[#stats+1] = format("return math.sin(%s)*0.5+0.5", stack[#stack])
	return table.concat(stats, "\n")
end

function genome_make(len)
	local g = {}
	for i = 1, len do
		g[i] = math.random(#operators)
	end
	return g
end

function genome_mutate(g, rate)
	local range = #operators
	local rate = (rate or 1)/range
	
	for i, gene in ipairs(g) do
		if math.random() < rate then
			gene = gene + math.random(3)-1
			gene = ((gene - 1) % range) + 1
			g[i] = gene
		end
	end
end	

function genome_print(g) print(unpack(g)) end

function genome_develop(g)
	local expr = interpret(g)
	local f = loadstring("return function(x, y)\n" .. expr .. "\nend")()
	return f, expr
end

local field2D = require "field2D"

local dim = 100
local image = field2D(dim, dim)

local pop = {}

for i = 1, 4 do
	local g = genome_make(100)
	local f, expr = genome_develop(g)
	local p = {
		genome = g,
		expr = expr,
		func = f,
	}
	pop[i] = p
end

-- click on a panel to select it for mutation:
function mouse(e, b, x, y)
	if e == "down" then
		local choice = math.ceil(x * #pop)
		local p = pop[choice]
		
		genome_mutate(p.genome, 0.1)
		local f, expr = genome_develop(p.genome)
		p.func = f
		print(expr)
	end
end

-- press "g" to breed the population
function keydown(k)	
	if k == "g" then
		local newpop = {}
		for i = 1, #pop do
			
			local mum = pop[math.random(#pop)].genome
			local dad = pop[math.random(#pop)].genome
			local g = {}
			
			local cross = math.random(#mum)
			
			for i = 1, cross do
				g[i] = mum[i]
			end
			for i = cross+1, #dad do
				g[i] = dad[i]
			end
			
			error("develop!")
			newpop[i] = g
		end
		pop = newpop
	end
end

function draw()
	local w = 1/#pop
	for i = 1, #pop do
		image:set(pop[i].func)
		image:draw(w * (i-1), 0, w, 1)
	end
end

