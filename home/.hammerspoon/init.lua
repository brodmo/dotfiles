local hyper = require("hyper")
local apps = require("apps")
local keys = require("keys")
local display = require("display")
local timer = require("timer")

timer.start() -- session-length clock in the menubar

--- APP HOTKEYS ---

hyper.bindAction("w", function() apps.open("Brave Browser") end) -- Web
hyper.bindAction("f", function() apps.open("draw.io") end) -- Files
hyper.bindAction("p", function() apps.cycle({ "Zed", "PyCharm" }) end) -- Programming

hyper.bindAction("a", function() apps.cycle({ "Claude", "ChatGPT" }) end) -- AI
hyper.bindAction("r", function() apps.open("Obsidian") end) -- Read
hyper.bindAction("s", function() apps.open("Spotify") end)
hyper.bindAction("t", function() apps.open("Ghostty") end) -- Terminal

hyper.bindAction("z", function() apps.open("Zotero") end)
hyper.bindAction("x", function() apps.open("Google Chrome") end) -- eXtra browser
hyper.bindAction("c", function() apps.open("Todoist") end) -- Checklist

hyper.bindAction(";", function() apps.open("System Settings") end)

--- KEYBINDS ---

hyper.bindKey("h", "left")
hyper.bindKey("n", "down")
hyper.bindKey("e", "up")
hyper.bindKey("i", "right")

hyper.bindAction(",", function() keys.sendKey({}, "pageup") end)
hyper.bindAction(".", function() keys.sendKey({}, "pagedown") end)

hyper.bindAction("escape", function() keys.sendMediaKey("PLAY") end)
hyper.bindAction("f1", function() keys.sendMediaKey("SOUND_DOWN") end)
hyper.bindAction("f2", function() keys.sendMediaKey("SOUND_UP") end)

hyper.bindAction("2", function() keys.sendKey({ "cmd", "shift" }, "[") end)
hyper.bindAction("3", function() keys.sendKey({ "cmd", "shift" }, "]") end)

--- DISPLAY CONTROLS ---

hyper.bindAction("left", function() display.tileWindow("left") end)
hyper.bindAction("right", function() display.tileWindow("right") end)

hyper.bindAction("up", function() display.maximizeWindow() end)
hyper.bindAction("down", function() display.centerWindow(0.7, 0.8) end)

hyper.bindAction("[", function() display.moveToScreen({ "west", "north" }) end)
hyper.bindAction("]", function() display.moveToScreen({ "east", "south" }) end)
