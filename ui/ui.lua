
Ui = Object:extend()


function Ui:new(font,l_system)
	self.font = font
	local yoffset = 100
	-- textboxes
	self.textbox = {}
	self.textbox[0] = Textbox("Axiom", 130, 35+yoffset, self.font, l_system.axiom) -- axiom
	self.textbox[0].bubble_info = "Initial state of the system, the 'seed'"

	self.textbox[1] = Textbox("Rule 1", 130, 75+yoffset, self.font, l_system.rules[1].is .. "=" .. l_system.rules[1].become) -- rule 1
	self.textbox[1].bubble_info = "<sentence1>=<sentence2> replaces the <sentence1> by the <sentence2> for every iterations.\n\nHere is the syntax:\n<F> draw a line\n<-> rotate counterclockwise\n<+> rotate clockwise\n<[> save current state\n<]> restore previous sate\n\nClick the refresh button!"

	self.textbox[2] = Textbox("Rule 2",130, 115+yoffset, self.font, "") -- rule 2
	self.textbox[2].bubble_info = "You can add an other rule :)"


	-- slidebars
	self.slidebar = {}
	self.slidebar[0] = Slidebar("Iterations", 130, 170+yoffset, 3, 1, 15, self.font) -- N_iter
	self.slidebar[0].bubble_info = "Number of times the rules are operated on the axiom. Click the refresh button!"

	self.slidebar[1] = Slidebar("Length", 130, 210+yoffset, 20, 0.5, 30, self.font) -- length
	self.slidebar[1].bubble_info = "Length of each segment used to draw the plant. Create a huge one!"

	self.slidebar[2] = Slidebar("Angle", 130, 250+yoffset, 20, 0, 180, self.font) -- angle
	self.slidebar[2].bubble_info = "Angle between segments rotated by <-> or <+>."


	-- buttons
	local yoffset_buttons = 50
	self.button = {} -- button list
	self.button[0] = Button(270,380,80,30,0,"Refresh",self.font)
	self.button[0].func = function()
		l_system.axiom = self.textbox[0].text

		local sep_idx = self.textbox[1].text:find("=")

		l_system.rules[1].is = self.textbox[1].text:sub(1,sep_idx-1)
		l_system.rules[1].become = self.textbox[1].text:sub(sep_idx+1)
		
		if self.textbox[2].text ~= self.textbox[2].empty_msg then
			local sep_idx = self.textbox[2].text:find("=")
			l_system.rules[2].is = self.textbox[2].text:sub(1,sep_idx-1)
			l_system.rules[2].become = self.textbox[2].text:sub(sep_idx+1)
		end

		l_system:clear() 
		l_system:generation()
	end

	self.button[1] = Button(10,0+yoffset_buttons,60,30,0,"Simple",self.font)
	self.button[1].func = function()
			self.slidebar[0].sup = 10
			self.textbox[0].text = "X" -- Axiom
			self.textbox[1].text = "X=F[-X][+X]" -- Rule 1
			self.textbox[2].text = "" -- Rule 2
		end

	self.button[2] = Button(80,0+yoffset_buttons,60,30,0,"Arrow",self.font)
	self.button[2].func = function()
			self.slidebar[0].sup = 8
			self.textbox[0].text = "X" -- Axiom
			self.textbox[1].text = "F=FF" -- Rule 1
			self.textbox[2].text = "X=F[+X][-X]FX" -- Rule 2
		end

	self.button[3] = Button(150,0+yoffset_buttons,60,30,0,"Sea weed",self.font)
		self.button[3].func = function()
			self.slidebar[0].sup = 7
			self.textbox[0].text = "X" -- Axiom
			self.textbox[1].text = "F=FF" -- Rule 1
			self.textbox[2].text = "X=F-[[-X]+X]+F[+FX]-X" -- Rule 2
		end

	self.button[4] = Button(220,0+yoffset_buttons,60,30,0,"Weavy",self.font)
		self.button[4].func = function()
			self.slidebar[0].sup = 8
			self.textbox[0].text = "X" -- Axiom
			self.textbox[1].text = "F=FF" -- Rule 1
			self.textbox[2].text = "X=F[-X]F[-X]+X" -- Rule 2
		end

	self.button[5] = Button(290,0+yoffset_buttons,60,30,0,"Tail",self.font)
		self.button[5].func = function()
			self.slidebar[0].sup = 5
			self.textbox[0].text = "F" -- Axiom
			self.textbox[1].text = "F=F[+F]F[-F]F" -- Rule 1
			self.textbox[2].text = "" -- Rule 2
		end

	self.button[6] = Button(10,40+yoffset_buttons,60,30,0,"Wavy",self.font)
		self.button[6].func = function()
			self.slidebar[0].sup = 5
			self.textbox[0].text = "F" -- Axiom
			self.textbox[1].text = "F=FF-[-F+F+F]+[+F-F-F]" -- Rule 1
			self.textbox[2].text = "" -- Rule 2
		end

	self.button[7] = Button(80,40+yoffset_buttons,60,30,0,"Fractals",self.font)
		self.button[7].func = function()
			self.slidebar[0].sup = 7
			self.textbox[0].text = "F" -- Axiom
			self.textbox[1].text = "F=F-F++F-F" -- Rule 1
			self.textbox[2].text = "" -- Rule 2
		end

	self.button[8] = Button(150,40+yoffset_buttons,60,30,0,"Dragon",self.font)
		self.button[8].func = function()
			self.slidebar[0].sup = 12
			self.textbox[0].text = "FX" -- Axiom
			self.textbox[1].text = "Y=-FX-Y" -- Rule 1
			self.textbox[2].text = "X=X+YF+" -- Rule 2
		end
end


function Ui:update(l_system)
	-- buttons
	for i = 0, #self.button do
		self.button[i]:update()
	end
	-- slidebars
	for i = 0, #self.slidebar do 
		self.slidebar[i]:update()
	end
	l_system.N_iter = self.slidebar[0].value
	l_system.length = self.slidebar[1].value
	l_system.angle = self.slidebar[2].value
	-- textboxes
	for i = 0, #self.textbox do 
		self.textbox[i]:update()
	end
end


function Ui:draw()
	-- buttons
	for i = 0, #self.button do -- draw menu buttons
		self.button[i]:draw()
	end
	-- slidebars
	for i = 0, #self.slidebar do -- draw menu buttons
		self.slidebar[i]:draw()
	end
	-- textboxes
	for i = 0, #self.textbox do 
		self.textbox[i]:draw()
	end
end


