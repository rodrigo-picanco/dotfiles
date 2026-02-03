-- Hyper key configuration for app launching
-- Hyper = ⌘ + ⌥ + ⌃ + ⇧ (all modifiers)

-- Enable IPC for command line reload
require("hs.ipc")

-- Helper function to launch or focus an app
local function launchOrFocus(appName)
    hs.application.launchOrFocus(appName)
end

-- Helper function to run an Apple Shortcut
local function runShortcut(shortcutName)
    hs.alert.show("Running shortcut: " .. shortcutName)
    local applescript = string.format([[
        tell application "Shortcuts"
            run shortcut "%s"
        end tell
    ]], shortcutName)
    local success, result = hs.osascript.applescript(applescript)
    if not success then
        hs.alert.show("Shortcut failed: " .. tostring(result))
    end
    return success, result
end

-- Hyper + h: Safari (Personal) via Shortcuts
hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "h", function()
    runShortcut("Safari (Personal)")
end)

-- Hyper + j: Safari (Work) via Shortcuts
hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "j", function()
    runShortcut("Safari (Work)")
end)

-- Hyper + k: Slack
hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "k", function()
    launchOrFocus("Slack")
end)

-- Hyper + l: Ghostty Terminal
hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "l", function()
    launchOrFocus("Ghostty")
end)

hs.alert.show("Hammerspoon config loaded!")
