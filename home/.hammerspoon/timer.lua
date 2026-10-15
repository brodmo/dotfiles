---@diagnostic disable-next-line: undefined-global
local hs = hs

local M = {} -- Module

local menubar = hs.menubar.new()
local startTime = os.time()
local lockedAt = nil

local function minutesSince(t)
	return (os.time() - t) / 60
end

local function formatDuration(minutes)
	minutes = math.floor(minutes)
	if minutes < 60 then
		return string.format("%dm", minutes)
	end
	return string.format("%dh %dm", math.floor(minutes / 60), minutes % 60)
end

local function refresh()
	local minutes = minutesSince(startTime)
	local emoji = minutes < 30 and "" or minutes < 60 and "☕ " or "🚨 "
	menubar:setTitle(emoji .. formatDuration(minutes))
end

local function onScreenEvent(e)
	if e == hs.caffeinate.watcher.screensDidLock then
		lockedAt = os.time()
	elseif e == hs.caffeinate.watcher.screensDidUnlock then -- any lock counts as a break
		local lockedFor = minutesSince(lockedAt)
		if lockedFor < 120 then
			hs.alert.show("☕ " .. formatDuration(lockedFor))
		end
		startTime = os.time()
		refresh()
	end
end

function M.start()
	-- keep references so they aren't garbage-collected
	M._refreshTimer = hs.timer.doEvery(10, refresh)
	M._lockWatcher = hs.caffeinate.watcher.new(onScreenEvent):start()
	refresh()
end

return M
