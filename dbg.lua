local dbg = {}
local visible = false

function dbg:draw()
	if visible then
		local stats = love.graphics.getStats()
		local fps = tostring(love.timer.getFPS())
		local memory = string.format('%.0f', tostring(collectgarbage('count')))
		
		love.graphics.push()
		love.graphics.setColor(0, 1, 0)
			 love.graphics.print(
				"FPS: " .. fps .. "\n" ..
				"Memory: "..memory .. "\n" ..
				"Draw Calls: " .. stats.drawcalls .. "\n" ..
				"Textures: " .. stats.images .. "\n" ..
				--~ "Texture Mem: " .. math.floor(stats.texturememory / 1024) .. " KB",
				"Texture Mem: " .. math.floor(stats.texturememory / 1024) .. " KB",
				10, 10 -- Координаты (x, y)
			)
		love.graphics.pop()
	end
end

function dbg:show()
	visible = true
end

function dbg:hide()
	visible = false
end

function dbg:get()
	return visible
end

return dbg
