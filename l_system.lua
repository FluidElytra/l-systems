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
	self.seed = Vector(900, 550) -- seed
	self.nodes = {self.seed} -- table of node coordinates
	self.vec = Vector(0, -self.length)
	self.animation_vec = Vector(0, 0)
	self.animation_angle = 0
	self:generation()
end


function L_system:update(dt)
	local vec = Vector(0, -self.length)
	local angle = self.angle*math.pi/180 -- half-angle between branches in radian
	local stack = {} -- table to store nodes position
	local letters = split(self.state[#self.state])
	

	-- self.animation_vec.x = 0.1*math.cos(2*love.timer.getTime())
	self.nodes = {self.seed}
	self.vec =  Vector(0, -self.length)
	self.animation_angle = 0.1*math.cos(1*love.timer.getTime())

	for i, letter in pairs(letters) do
		if letter == 'F' then
			self.vec:rotateInplace(self.animation_angle/(i*i))
			pos = self.nodes[i] + self.vec + self.animation_vec
		elseif letter == '-' then
			self.vec = self.vec:rotated(-angle)
		elseif letter == '+' then
			self.vec = self.vec:rotated(angle)
		elseif letter == '[' then -- save position
			stack[#stack+1] = {pos, self.vec, lastpos}
		elseif letter == ']' then -- restore last position
			pos, self.vec, lastpos = unpack(stack[#stack])
			stack[#stack] = nil
 		end
 		lastpos = pos
 		table.insert(self.nodes, pos) -- update nodes to draw
	end
end


function L_system:draw()
	if #self.state > 0 then
		love.graphics.setCanvas(self.canvas) -- draw in canvas
		love.graphics.clear()

		-- draw the l-system
 		for i,node in pairs(self.nodes) do
 			if i > 1 then
 				love.graphics.setLineWidth(5)
 				pos = node
 				lastpos = self.nodes[i-1]
 				love.graphics.line(pos.x, pos.y, lastpos.x, lastpos.y)
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
	self.nodes = {}
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
