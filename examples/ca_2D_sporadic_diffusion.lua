-- load in the "field2D" library module (from /modules/field2D.lua):
local field2D = require "field2D"

local random = math.random
local srandom = function() return random() * 2 - 1 end

-- choose the size of the field
local dim = 128

-- allocate the field
local field = field2D.new(dim, dim)

function reset()
	for x = 1, dim-2 do
		for y = 1, dim-2 do
			local v = 0
			if random() < 0.5 then
				v = math.random()
			end		
			field:set(v, x, y)
		end
	end	
end
reset()

function rule(x, y)
	local x1 = x/dim
	local y1 = y/dim
	local o = field:get(x, y)
	local nx = x
	local ny = y
	local r = random(8)
	if r == 1 then
		nx = nx + 1
	elseif r == 2 then
		ny = ny + 1
	elseif r == 3 then
		nx = nx - 1
	elseif r == 4 then
		ny = ny - 1
	elseif r == 5 then
		nx = nx + 1
		ny = ny + 1
	elseif r == 6 then
		nx = nx - 1
		ny = ny + 1
	elseif r == 7 then
		nx = nx + 1
		ny = ny - 1
	elseif r == 8 then
		nx = nx - 1
		ny = ny - 1
	end
	local n = field:get(nx, ny)
		
	-- spread the value 'n' between x,y and nx,ny:
	if o < n + srandom() * 0.1 then
		field:set(o + n/2, nx, ny)
		field:set( n/2, x, y)
	end
end	



-- update the state of the scene (toggle this on and off with spacebar):
function update(dt)
	for i = 1, 10000 do
		-- choose a random cell:
		local x = random(dim-2)
		local y = random(dim-2)
		rule(x, y)
	end
end

-- how to render the scene (toggle fullscreen with the Esc key):
function draw()	
	-- draw the field:
	field:draw()
end

-- handle keypress events:
function keydown(k)
	if k == "c" then
		-- set all cells to zero:
		field:clear()
	end
end


-- handle mouse events:
function mouse(event, btn, x, y)
	-- clicking & dragging should draw values into the field:
	if event == "down" or event == "drag" then
		
		-- scale window coords (0..1) up to the size of the field:
		local x = x * field.width
		local y = y * field.height
	
		-- spread the updates over a wide area:
		for i = 1, 10 do
			-- pick a random cell near to the mouse position:
			local span = 3
			local fx = x + math.random(span) - math.random(span)
			local fy = y + math.random(span) - math.random(span)
			
			-- set this cell to either 0 or 1:
			field:set(coin(), fx, fy)
		end
	end
end
