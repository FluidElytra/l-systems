Object = require "lib/classic"
Vector = require "lib/hump.vector"
Timer = require "lib/hump.timer"
utf8 = require("utf8")
require "l_system"
require "ui/ui"
require "ui/slidebar"
require "ui/slidebutton"
require "ui/button"
require "ui/textbox"


timer = Timer.new()
devMode = false
love.graphics.setDefaultFilter('nearest','nearest')
love.window.setMode(1400, 800)
love.graphics.setBackgroundColor(31/255, 36/255, 48/255)
CMU_serif = love.graphics.newFont("fonts/computer-modern/cmunrm.ttf", 15)
CMU_serif_italic = love.graphics.newFont("fonts/computer-modern/cmunci.ttf", 15)
CMU_typewriter = love.graphics.newFont("fonts/computer-modern/cmuntb.ttf", 15)
math.randomseed(os.time()) -- seed of the random generation


function love.load()
	plant = L_system(3)
	UI = Ui(CMU_typewriter, plant)
end


function love.update(dt)
	plant:update()
	UI:update(plant)
end


function love.draw()
	plant:draw()
	love.graphics.draw(plant.canvas)
	UI:draw()
end


function love.textinput(t)
	for i = 0, #UI.textbox do
		UI.textbox[i]:getText(t)
	end
end


function love.keypressed(key)
	for i = 0, #UI.textbox do
		UI.textbox[i]:controls()
	end
end

