Button = {}
Button.__index = Button
setmetatable(Button, Win) -- наследуем класс "Button" от класса "Win"

function Button:update(dt, ox, oy)
	if not self:isActive() then return end
	local mx, my = love.mouse.getPosition()
	local ox, oy = ox or 0, oy or 0
		
	if mx > self.X + ox and mx < self.X + self.Width + ox and my > self.Y + oy and my < self.Y + self.Height + oy then
		self.lighting = true
	else
		self.lighting = false
	end
end

local draw = Button.draw -- сохраняем функцию в переменную, чтобы переопределить

function Button:draw() -- переопределяем функцию отрисовки заново, чтобы добавить выделение кнопки
	draw(self)
	
	love.graphics.push()
	love.graphics.translate(self.X, self.Y)
	if self.lighting and self.lightColor then 
		love.graphics.setColor(self.lightColor)
		love.graphics.rectangle('fill', 0, 0, self.Width, self.Height, self.frameSegments or 0) 
	end
	love.graphics.pop()
end

function Button:mousepressed(mx, my)
	if self.act and self.lighting then
		self:act(s)
	end
end

function Button:__tostring()
	return 'It Button in cordinate '..self.X..'-'..self.Y..' and size: '..self.Width..'x'..self.Height
end

function Button:__type(_) return "button" end

return Button
