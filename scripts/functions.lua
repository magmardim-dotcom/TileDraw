local functions = {}

function functions.loadMap(w,h)
	local map = {}
	
	for y = 1, h do
		map[y] = {}
		for x = 1, w do
		  map[y][x] = 0
		end
	end
	return map
end

function functions.load_assets(folder)
	local t = {}
	
	items = love.filesystem.getDirectoryItems(folder)
	
	for k,v in ipairs(items) do
		local item = love.graphics.newImage(folder.."/"..v)
		local i = string.find(v, "%.") -- находит индекс точки в имени файла
		
		t[string.sub(v, 1, i-1)] = item -- создает значение в таблице
	end
	
	return t
end

function functions.indexTileset(img)
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

function functions.windowNew(win)
	if type(win) ~= 'table' then error("type Win not a tabele") end
	
	return Wind.Win:new(win)
end

function functions.buttonNew(button)
	if type(button) ~= 'table' then error("type Button not a tabele") end
	
	return Wind.Button:new(button)
end

function functions.writeMap(map)
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

function functions.searchIndexforXY(tab, x, y)
	for k, v in ipairs(tab) do
		if v.x == x and v.y == y then return k end
	end
	return 0
end

return functions
