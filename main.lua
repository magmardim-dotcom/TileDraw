Wind = require "wind/main"

funct = require "scripts/functions"
state = require "scripts/state"

local dbg = require "dbg"

function love.load()
	love.graphics.setDefaultFilter('nearest')
		
	tilesets = funct.load_assets('tilesets')
	ts = TileSets[SelectTs] 
	Index = funct.indexTileset(tilesets[ts])
	drawTile = 1
		
	Map = funct.loadMap(Width, Height)
	tile = 0
	
	mousepressed = false
	
	mapTiles = 	require "scripts/mapTiles"
	mapTiles:activate()
	
	menuTileset = require "scripts/menuTileset"
	menuTileset:activate()
end

function love.draw()
	love.graphics.push()
	love.graphics.translate(-ofx, -ofy)
	love.graphics.scale(scale)
	mapTiles:draw()
	love.graphics.pop()
	menuTileset:draw()
		
	love.graphics.setColor(0, 0, 0)
	
	local msg = "X:	"..math.ceil(love.mouse.getX()/Cellsize).."\n".."Y:	"..math.ceil(love.mouse.getY()/Cellsize).."\nWidth:	"..Width..'\nHeight:	'..Height
	love.graphics.print(msg, 1260, 100)
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

function love.keypressed(key)
	if key == "z" then
		scale = scale <= 0.1 and 0.1 or scale - 0.1
	elseif key == "x" then
		scale = scale >= 1 and 1 or scale + 0.1
	end
	
	if key == "w" then
		ofy = ofy - Cellsize
	elseif key == "s" then
		ofy = ofy + Cellsize
	elseif key == "a" then
		ofx = ofx - Cellsize
	elseif key == "d" then
		ofx = ofx + Cellsize
	end
end
