Wind = require "wind/main"

funct = require "scripts/functions"
state = require "scripts/state"

local dbg = require "dbg"

function love.load()
	love.graphics.setDefaultFilter('nearest')
		
	tilesets = funct.load_assets('tilesets')
	ts = TileSets
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
	mapTiles:draw()
	menuTileset:draw()
		
	love.graphics.setColor(0, 0, 0)
	
	local msg = "X:	"..math.ceil(love.mouse.getX()/Cellsize).."\n".."Y:	"..math.ceil(love.mouse.getY()/Cellsize).."\nWidth:	"..Width..'\nHeight:	'..Height
	love.graphics.print(msg, 1100, 100)
	dbg:draw(30, 50)
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
