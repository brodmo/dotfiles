---@diagnostic disable-next-line: undefined-global
local hs = hs

local M = {} -- Module

local function mutedIcon() -- mic-off icon, scaled to text height with a gap before the title
	local height, gap = 16, 14
	local icon = hs.image.imageFromPath(hs.configdir .. "/mic-slash.png") -- SF Symbol mic.slash.fill
	local width = icon:size().w * height / icon:size().h
	local canvas = hs.canvas.new({ w = width + gap, h = height })
	canvas[1] = { type = "image", image = icon, imageScaling = "scaleToFit", frame = { x = 0, y = 0, w = width, h = height } }
	return canvas:imageFromCanvas()
end
mutedIcon = mutedIcon()
local menubar -- icon of a menubar item shared with other modules

local function refresh()
	menubar:setIcon(hs.audiodevice.defaultInputDevice():inputMuted() and mutedIcon or nil, false) -- false: keep the red
end

function M.toggle()
	local mic = hs.audiodevice.defaultInputDevice()
	mic:setInputMuted(not mic:inputMuted())
	refresh()
end

function M.start(bar)
	menubar = bar
	hs.audiodevice.watcher.setCallback(refresh) -- default input changed, e.g. headset plugged in
	hs.audiodevice.watcher.start()
	refresh()
end

return M
