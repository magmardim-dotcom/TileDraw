Wind = require "wind/main"

local function loadMap(w,h)
	local map = {}
	
	for y = 1, h do
		map[y] = {}
		for x = 1, w do
		  map[y][x] = 0
		end
	end
	return map
end

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

local function load_assets(folder)
	local t = {}
	
	items = love.filesystem.getDirectoryItems(folder)
	
	for k,v in ipairs(items) do
		local item = love.graphics.newImage(folder.."/"..v)
		local i = string.find(v, "%.") -- находит индекс точки в имени файла
		
		t[string.sub(v, 1, i-1)] = item -- создает значение в таблице
	end
	
	return t
end

local function indexTileset(img)
	local tableIndex = {}
	local width = img:getWidth()/Cellsize
	local height = img:getHeight()/Cellsize
	
	for y = 0, height do
		for x = 0, width do
			table.insert(tableIndex, {x = x, y = y})
		end
	end
	
	return tableIndex
end

local function windowNew(win)
	if type(win) ~= 'table' then error("type Win not a tabele") end
	
	return Wind.Win:new(win)
end

local function buttonNew(button)
	if type(button) ~= 'table' then error("type Button not a tabele") end
	
	return Wind.Button:new(button)
end

local function searchIndexforXY(tab, x, y)
	for k, v in ipairs(tab) do
		if v.x == x and v.y == y then return k end
	end
	return 0
end

local function writeMap(map)
	local str = "{ \n"
	
	for y = 1, #map do
		str = str.."{"
		for x = 1, #map[y] do
			str = str..map[y][x]..","
		end
		str = str.."}, \n"
	end
	
	return str.."}"
end

function love.load()
	love.graphics.setDefaultFilter('nearest')
	Width = 35
	Height = 18
	Cellsize = 20
	
	tilesets = load_assets('tilesets')
	ts = 'tl1'
	Index = indexTileset(tilesets[ts])
	drawTile = 1
		
	Map = loadMap(Width, Height)
	tile = 0
	
	mousepressed = false
	
	mapTiles = 	windowNew {
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
			love.graphics.setColor(0,0,0)
			for x = 0, Width-1 do
				love.graphics.line(Cellsize * x, 0, Cellsize * x, self.Height)
			end
			for y = 0, Height-1 do
				love.graphics.line(0, Cellsize * y, self.Width, Cellsize * y)
			end
		end,
		buttons = {buttonNew {
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
	mapTiles:activate()
	
	menuTileset = windowNew {
		X = 850,
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
			tileset = buttonNew {
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
					drawTile = searchIndexforXY(Index, mx, my)
				end
			},
			addW = buttonNew {
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
			subW = buttonNew {
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
			addH = buttonNew {
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
			subH = buttonNew {
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
			createLuaFile = buttonNew {
				X = 40, Y = 500,
				Width = 60, Height = 20,
				bgColor = {0,1,0, 1},
				lightColor = {1,0,0, 0.6},
				act = function(s)
					local data = writeMap(Map)
					love.filesystem.write( "data.txt", data)
					love.system.setClipboardText(data)
				end,
				texts = {string = "create"}
			},
			clear = buttonNew {
				X = 40, Y = 560,
				Width = 60, Height = 20,
				bgColor = {0,1,0, 1},
				lightColor = {1,0,0, 0.6},
				act = function(s)
					Map = loadMap(Width, Height)
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
	menuTileset:activate()
end

function love.draw()
	mapTiles:draw()
	menuTileset:draw()
		
	love.graphics.setColor(0, 0, 0)
	
	local msg = "X:	"..math.ceil(love.mouse.getX()/Cellsize).."\n".."Y:	"..math.ceil(love.mouse.getY()/Cellsize).."\nWidth:	"..Width..'\nHeight:	'..Height
	love.graphics.print(msg, 1100)
end

function love.update(dt)
	menuTileset:update(dt)
	mapTiles:update(dt)
	if mousepressed then
		local mx, my = love.mouse.getX(), love.mouse.getY()
		mapTiles:mousepressed(mx, my)
	end
end

function love.mousepressed(mx, my, button, isTouch)
	menuTileset:mousepressed(mx, my)
	mousepressed = true
end

function love.mousereleased(mx, my, button, isTouch)
	mousepressed = false
end
