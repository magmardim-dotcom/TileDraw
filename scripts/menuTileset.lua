local function changeMapW(map, n)
	local n = n or 1
	
	Width = Width + n
	mapTiles.Width = Width * Cellsize
	mapTiles.buttons[1].Width = Width * Cellsize
	
	for y = 1, #map do
		if n < 0 then 		table.remove(map[y]) 	
		elseif n > 0 then	table.insert(map[y], 0)
		end
	end
end

local function changeMapH(map, n)
	local n = n or 1
	
	Height = Height + n
	mapTiles.Height = Height * Cellsize
	mapTiles.buttons[1].Height = Height * Cellsize
	
	local w = {}
	
	for x = 1, #map[1] do table.insert(w, 0) end
	
	if n < 0 then 		table.remove(map) 	
	elseif n > 0 then	table.insert(map, w)
	end
end

return funct.windowNew {
		X = 1160,
		Y = 0,
		Width = love.graphics.getWidth() - 650,
		Height = love.graphics.getHeight(),
		bgColor = {1,1,1},
		tsX = 0,
		tsY = 0,
		drawItem = function(s)
			love.graphics.push()
			love.graphics.translate(40, 20)
			love.graphics.draw(tilesets[ts])
			love.graphics.setColor(1,0,0)
			love.graphics.rectangle('line', s.tsX * Cellsize, s.tsY * Cellsize, Cellsize, Cellsize)
			love.graphics.pop()
		end,
		buttons = {
			tileset = funct.buttonNew {
				X = 40,
				Y = 20,
				Width = tilesets[ts]:getWidth(),
				Height = tilesets[ts]:getHeight(),	
				act = function(s) 
					local w = s.where
					local mx, my = love.mouse.getPosition()
					mx = math.ceil((mx - menuTileset.X - s.X)/Cellsize)-1
					my = math.ceil((my - menuTileset.Y - s.Y)/Cellsize)-1
					
					w.tsX = mx
					w.tsY = my
					drawTile = funct.searchIndexforXY(Index, mx, my)
				end
			},
			addW = funct.buttonNew {
				X = 40,
				Y = 360,
				Width = 20,
				Height = 20,
				bgColor = {0,1,0, 1},
				lightColor = {1,0,0, 0.6},
				act = function(s)
					changeMapW(Map, 1)
				end,
				texts = {string = "+"}
			},
			subW = funct.buttonNew {
				X = 140,
				Y = 360,
				Width = 20,
				Height = 20,
				bgColor = {0,1,0, 1},
				lightColor = {1,0,0, 0.6},
				act = function(s)
					changeMapW(Map, -1)
				end,
				texts = {string = "-"}
			},
			addH = funct.buttonNew {
				X = 40,
				Y = 400,
				Width = 20,
				Height = 20,
				bgColor = {0,1,0, 1},
				lightColor = {1,0,0, 0.6},
				act = function(s)
					changeMapH(Map, 1)
				end,
				texts = {string = "+"}
			},
			subH = funct.buttonNew {
				X = 140,
				Y = 400,
				Width = 20,
				Height = 20,
				bgColor = {0,1,0, 1},
				lightColor = {1,0,0, 0.6},
				act = function(s)
					changeMapH(Map, -1)
				end,
				texts = {string = "-"}
			},
			createLuaFile = funct.buttonNew {
				X = 40, Y = 500,
				Width = 60, Height = 20,
				bgColor = {0,1,0, 1},
				lightColor = {1,0,0, 0.6},
				act = function(s)
					local data = funct.writeMap(Map)
					love.filesystem.write( "data.txt", data)
					love.system.setClipboardText(data)
				end,
				texts = {string = "create"}
			},
			clear = funct.buttonNew {
				X = 40, Y = 560,
				Width = 60, Height = 20,
				bgColor = {0,1,0, 1},
				lightColor = {1,0,0, 0.6},
				act = function(s)
					Map = funct.loadMap(Width, Height)
				end,
				texts = {string = "clear"}
			},
		},
		texts = {
			{
				x = 70,
				y = 360,
				string = "Width",
				align = "left"
			},
			{
				x = 70,
				y = 400,
				string = "Height",
				align = "left"
			}
		}
	}
