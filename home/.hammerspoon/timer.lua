---@diagnostic disable-next-line: undefined-global
local hs = hs

local M = {} -- Module

local menubar = hs.menubar.new()
local startTime = os.time()
local nextPopupAt = 75
local lockedAt = nil
local onBreak = false

local function minutesSince(t)
	return (os.time() - t) / 60
end

local function formatDuration(minutes)
	if minutes < 60 then
		return string.format("%dm", minutes)
	end
	return string.format("%dh %dm", math.floor(minutes / 60), minutes % 60)
end

local function refresh()
	if lockedAt then return end
	local minutes = math.floor(minutesSince(startTime))
	local emoji = minutes < 45 and "" or minutes < 75 and "⚠️ " or "🚨 "
	local text = emoji .. formatDuration(minutes)
	menubar:setTitle(text)

	if minutes >= nextPopupAt then
		nextPopupAt = nextPopupAt + 15
		if hs.dialog.blockAlert(text, "Take a break", "OK", "Not now") == "OK" then
			onBreak = true
			hs.caffeinate.lockScreen()
		end
	end
end

local function reset()
	startTime = os.time()
	nextPopupAt = 75
	refresh()
end

local function onScreenEvent(e)
	if e == hs.caffeinate.watcher.screensDidLock then
		lockedAt = os.time()
	elseif e == hs.caffeinate.watcher.screensDidUnlock then
		local lockedFor = minutesSince(lockedAt)
		lockedAt = nil
		if onBreak or lockedFor >= 30 then
			onBreak = false
			reset()
		elseif lockedFor >= 3 and minutesSince(startTime) >= 45 then
			if hs.dialog.blockAlert("Taken a break?", "", "Yes", "No") == "Yes" then
				reset()
			end
		end
	end
end

function M.start()
	-- keep references so they aren't garbage-collected
	M._refreshTimer = hs.timer.doEvery(10, refresh)
	M._lockWatcher = hs.caffeinate.watcher.new(onScreenEvent):start()
	refresh()
end

return M
