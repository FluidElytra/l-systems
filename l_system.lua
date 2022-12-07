----------------------------------------------
--											--
--					L_system 				--
--											--
----------------------------------------------
L_system = Object:extend()

local nodeColor = {201/255,104/255,135/255}
local branchColor = {1,1,1}
local branchPerNode = 2
local seed = Vector(500,500)

local axiom = "X"

local rules1 = {{is = 'X', become = 'F[-X][+X]'},
				{is = '', become = ''}}

local rules2 = {{is = 'F', become = 'FF'},
				{is = 'X', become = 'F[+X][-X]FX'}}

local rules3 = {{is = 'F', become = 'FF'},
				{is = 'X', become = 'F-[[-X]+X]+F[+FX]-X'}}


function L_system:new(N_iter)
	self.axiom = axiom
	self.rules = rules1

	self.N_iter = N_iter
	self.length = 3
	self.state = {}
	self.angle = 10
	self.canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())

	self:generation()
end


function L_system:update()

end


function L_system:draw()
	if #self.state > 0 then
		love.graphics.setCanvas(self.canvas) -- draw in canvas
		love.graphics.clear()

		local print_state = false
		local print_graph = true
		
		if print_state == true then -- print state
			local y = 0
			for i, state in pairs(self.state) do
				y = y + 20
				love.graphics.printf(i, CMU_typewriter, 0, y, 30, 'center')	
				love.graphics.printf(state, CMU_typewriter, 40, y, 1400, 'left')		
			end
		end

		if print_graph == true then -- translate state into graphics
			local pos = Vector(900, 550) -- seed
			local lastpos = pos
			local vec = Vector(0, -self.length)
			local angle = self.angle*math.pi/180 -- half-angle between branches in radian
			local stack = {} -- table to store nodes position

			local letter = split(self.state[#self.state])

			for i = 0, #letter do
				if letter[i] == 'F' then
					pos = pos + vec
				elseif letter[i] == '-' then
					vec = vec:rotated(-angle)
				elseif letter[i] == '+' then
					vec = vec:rotated(angle)
				elseif letter[i] == '[' then -- save position
					stack[#stack+1] = {pos, vec, lastpos}
				elseif letter[i] == ']' then -- restore last position
					pos, vec, lastpos = unpack(stack[#stack])
					stack[#stack] = nil
		 		end
		 		love.graphics.line(lastpos.x, lastpos.y, pos.x, pos.y)
		 		lastpos = pos
	 		end
		end
		love.graphics.setCanvas()
	else
		love.graphics.setCanvas(self.canvas) -- draw nothing in the canvas
		love.graphics.clear()
		love.graphics.setCanvas()
	end
end


function L_system:generation(axiom, rules)
	self.state[0] = self.axiom

	for i = 0, self.N_iter-1 do
		local buff = split(self.state[i])

		for j = 1, #buff do
			for _, rule in pairs(self.rules) do
				if buff[j] == rule.is then
					buff[j] = rule.become
				end
			end
		end

		self.state[i+1] = ''
		for j = 1, #buff do
			self.state[i+1] = self.state[i+1] .. buff[j]
		end
	end
end

function L_system:clear()
	self.state = {}
end



----------------------------------------------
--											--
--					OTHER 					--
--											--
----------------------------------------------
function split(str) -- fill an array with the letters of str
	local t = {}
	for i=1, str:len() do
		t[#t+1] = str:sub(i, i)
	end
	return t
end


local function areIntersecting(A, B, C, D) -- might be useful to make branches conscient of other ones
	local d = (A.x - B.x) * (C.y - D.y) - (A.y - B.y) * (C.x - D.x)
	local a = A.x * B.y - A.y * B.x
	local b = C.x * D.y - C.y * D.x
	local x = (a * (C.x - D.x) - (A.x - B.x) * b) / d
	local y = (a * (C.y - D.y) - (A.y - B.y) * b) / d
	
	if x > math.min(A.x, B.x) and x < math.max(A.x, B.x) and x > math.min(C.x, D.x) and x < math.max(C.x, D.x) then
		return true
	end

	return false
end
