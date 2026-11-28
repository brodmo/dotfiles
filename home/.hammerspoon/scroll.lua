---@diagnostic disable-next-line: undefined-global
local hs = hs

local M = {} -- Module

local FRACTION = 1 / 3 -- of the window height per step

function M.step(direction) -- 1 = down, -1 = up
	local frame = hs.window.focusedWindow():frame()
	if not hs.geometry.point(hs.mouse.absolutePosition()):inside(frame) then -- scroll events go to the window under the pointer
		hs.mouse.absolutePosition(frame.center)
	end
	hs.eventtap.scrollWheel({ 0, -direction * math.floor(frame.h * FRACTION) }, {}, "pixel") -- fractions are silently sent as 0
end

return M
