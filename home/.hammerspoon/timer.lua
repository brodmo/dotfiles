---@diagnostic disable-next-line: undefined-global
local hs = hs

local M = {} -- Module

local menubar = hs.menubar.new()
local startTime = os.time()
local lockedAt = nil
local inputTimes = {} -- timestamps of recent key presses and clicks

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

local function inMeeting() -- mic or camera in use is the meeting proxy
	for _, mic in ipairs(hs.audiodevice.allInputDevices()) do
		if mic:inUse() then
			return true
		end
	end
	for _, cam in ipairs(hs.camera.allCameras()) do
		if cam:isInUse() then
			return true
		end
	end
	return false
end

local function isActive() -- enough input recently, so movies don't trigger the lock
	local cutoff = os.time() - 5 * 60
	while inputTimes[1] and inputTimes[1] < cutoff do
		table.remove(inputTimes, 1)
	end
	return #inputTimes >= 100
end

local function refresh()
	local minutes = minutesSince(startTime)
	local emoji = minutes < 30 and "" or minutes < 60 and "☕ " or "🌙 "
	menubar:setTitle(emoji .. formatDuration(minutes))
	if minutes >= 60 and isActive() and not inMeeting() then
		hs.execute("/opt/homebrew/bin/media-control pause") -- whatever is in Now Playing
		hs.caffeinate.lockScreen()
	end
end

local function onInput()
	table.insert(inputTimes, os.time())
	return false -- let the event through
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
	local types = hs.eventtap.event.types
	local inputEvents = { types.keyDown, types.leftMouseDown, types.rightMouseDown }
	M._inputTap = hs.eventtap.new(inputEvents, onInput):start()
	refresh()
end

return M
