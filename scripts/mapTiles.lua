return funct.windowNew {
		Width = Width * Cellsize,
		Height = Height * Cellsize,
		bgColor = {1,1,1},
		drawItem = function(self)
			love.graphics.setColor(1,1,1)
			for y = 1, #Map do
				for x = 1, #Map[y] do
					local index = Map[y][x]
					if Map[y][x] ~= 0 then 
						if Index[index] then
							local t = Index[index]
							local img = tilesets[ts]
							local quad = love.graphics.newQuad(t.x * Cellsize, t.y * Cellsize, Cellsize, Cellsize, img:getWidth(), img:getHeight())
							
							love.graphics.draw(tilesets[ts], quad, (x-1) * Cellsize, (y-1) * Cellsize)
						end
					end
				end
			end
			love.graphics.setColor(0,0,0,.5)
			for x = 0, Width-1 do
				love.graphics.line(Cellsize * x, 0, Cellsize * x, self.Height)
			end
			for y = 0, Height-1 do
				love.graphics.line(0, Cellsize * y, self.Width, Cellsize * y)
			end
			
			love.graphics.setColor(1,0,0)
			local w4, h4 = self.Width/4,  self.Height/4
			for x = 0, 3 do
				love.graphics.line(w4 * x, 0, w4 * x, self.Height)
			end
			for y = 0, 3 do
				love.graphics.line(0, h4 * y, self.Width, h4 * y)
			end
		end,
		buttons = {funct.buttonNew {
			Width = Width * Cellsize,
			Height = Height * Cellsize,
			act = function(s)
				local mx, my = love.mouse.getPosition()
				mx = math.ceil(mx/Cellsize)
				my = math.ceil(my/Cellsize)
				if love.mouse.isDown(1) then
					Map[my][mx] = drawTile
				elseif love.mouse.isDown(2) then
					Map[my][mx] = 0
				end
			end}
		}
	}
