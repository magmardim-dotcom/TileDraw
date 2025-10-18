Win = {}	
Win.__index = Win

function Win:new(s)
	local win = s
		win.Width = s.Width or 0
		win.Height = s.Height or 0 
		win.X = s.X or 0
		win.Y = s.Y or 0
		win.alph = s.alph or 1
		win.bgColor = s.bgColor or {0,0,0,0}
		win.lMargin  = s.lMargin or 0 -- левый отступ
		win.rMargin  = s.rMargin or 0 -- правый отступ
		win.upMargin = s.upMargin or 0 -- верхний отступ
		win.act = s.act or function() end
		win.drawItem = s.drawItem or nil
		
		-- проходим по значения в таблице buttons и добавляем в значения ссылку на родительское окно 
		if win.buttons then
			for _,v in pairs(win.buttons) do
				v.where = win
			end
		end
		---
		local activate = false -- отвечает за то будет ли окно активно
		
		function win:activate() -- активирует окно и все кнопки окна
			activate = true
			if not win.buttons then return end
			if type(win.buttons) == "table" then
				for k, v in pairs(win.buttons) do							
					if classtype(v) == "button" then win.buttons[k]:activate() end
				end
			elseif type(win.buttons) == "function" then
				win.buttons:activate()
			else
				error("type of win.buttons shold be a function or table")
			end
		end
		function win:unactivate()
			activate = false
			if not win.buttons then return end
			if #win.buttons and #win.buttons > 0 then
				for k, v in pairs(win.buttons) do							
					win.buttons[k]:unactivate()
				end
			else
				win.buttons:unactivate()
			end
		end
		function win:isActive()
			if activate then
				return true
			else
				return false
			end
		end

	return setmetatable(win, self)
end

function Win:draw()
	love.graphics.setDefaultFilter('nearest')
	if not self:isActive() then return end
		love.graphics.push()
			love.graphics.translate(self.X, self.Y)
			-- рисуем BG
			if self.bgColor then
				love.graphics.setColor(self.bgColor)
				love.graphics.rectangle('fill', 0, 0, self.Width, self.Height, self.frameSegments or 0)
				
				if self.frameColor then
					love.graphics.setColor(self.frameColor)
					love.graphics.setLineWidth(self.frameLineWidth or 10)
					love.graphics.rectangle('line', 0, 0, self.Width, self.Height, self.frameSegments or 0)
				end
			end
			
			-- рисуем images {}
			love.graphics.setColor(1,1,1)
			if self.images then
				if #self.images and #self.images > 0 then
					for k, v in pairs(self.images) do
						local s = self.images[k]
						
						love.graphics.draw(s.img, s.X or 0, s.Y or 0, 0, s.x_scale or 1, s.y_scale or 1)
					end
				else
					local s = self.images
					
					love.graphics.draw(s.img, s.X or 0, s.Y or 0, 0, s.x_scale or 1, s.y_scale or 1)
				end
			end 
			
			-- рисуем drawItem
			if self.drawItem then
				if type(self.drawItem) == "function" then
					self.drawItem(self)
				elseif type(self.drawItem) == "table" then
					for _, funct in pairs(self.drawItem) do
						funct(self)
					end
				else
					error("type of drawItem shold be a function or table")
				end
			end
			-- рисуем text_block
			love.graphics.push()
				love.graphics.translate(self.lMargin , self.upMargin)
				
				local txt = function(s,t) -- функция отрисовки блоков текста
					if t.font then love.graphics.setFont(t.font) end
					love.graphics.setColor(t.textColor or {0,0,0})
					love.graphics.printf(
						t.string, 
						t.x or 0, 
						t.y or 0, 
						(t.width or self.Width) - self.lMargin - self.rMargin, 
						t.align or 'center')
				end
				
				if self.texts then
					if #self.texts and #self.texts > 0 then
						for k, v in pairs(self.texts) do							
							txt(self, self.texts[k])
						end
					else
						txt(self, self.texts)
					end
				end				
			love.graphics.pop()
			
			-- добавляем кнопки
				if self.buttons then
					if type(self.buttons) == "table" then 
						for k, v in pairs(self.buttons) do							
							v:draw()
						end
					elseif type(self.buttons) == "function" then
						self.buttons:draw()
					else
						error("type of buttons shold be a function or table")
					end
				end
		love.graphics.pop()
end

function Win:update(dt)
	if not self:isActive() then return end
	
	if self.buttons then
		if type(self.buttons) == "table" then
			for k, v in pairs(self.buttons) do							
				if classtype(v) == "button" then self.buttons[k]:update(dt, self.X, self.Y) end 
			end
		else
			self.buttons:update(dt, self.X, self.Y)
		end
	end
	
	if self.timer then self:timer(dt) end
end

function Win:mousepressed(mx, my)
	if not self:isActive() then return end
	
	if mx > self.X and mx < self.X+self.Width and my > self.Y and my < self.Y+self.Height then
		if self.buttons then
			if type(self.buttons) == "table" then
				for k, v in pairs(self.buttons) do							
					self.buttons[k]:mousepressed(mx, my)
				end
			else
				self.buttons:mousepressed(mx, my)
			end
		end		
	end
end

function Win:__tostring()
	return 'It Window in cordinate '..self.X..'-'..self.Y..' and size: '..self.Width..'x'..self.Height
end

function classtype(v)
    local mt = getmetatable(v)
    if mt and mt.__type then
        return mt.__type(v)   -- пользовательский метод
    end
    return type(v)            -- стандартный тип
end

function Win:__type(_) return "window" end

return Win
