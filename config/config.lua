Config = {}

-- ✅ Default Keybinds (Players can modify these)
Config.DefaultKeybinds = {
    ["F2"] = "keybindmenu"
}

-- ✅ Enable Debug Mode (Shows additional console logs)
Config.Debug = false

-- ✅ Database Settings (For future customization)
Config.UseDatabase = true -- Set to false if you want keybinds saved only locally

-- ✅ UI Customization (Change colors, menu title)
Config.UI = {
    MenuTitle = "Keybind Manager",
    BackgroundColor = "rgba(30, 30, 30, 0.95)",
    ButtonColor = "#5d00ba",
    HoverColor = "#2a282b"
}



-- ✅ Valid Controls for FiveM Keybinds
Config.ValidControls = {
    ["ESC"] = 322, ["TAB"] = 37, ["SHIFT"] = 21, ["CTRL"] = 36, ["ALT"] = 19,
    ["SPACE"] = 22, ["ENTER"] = 18, ["BACKSPACE"] = 177, ["DEL"] = 178,
    ["ARROWUP"] = 172, ["ARROWDOWN"] = 173, ["ARROWLEFT"] = 174, ["ARROWRIGHT"] = 175,
    ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F4"] = 166, ["F5"] = 167,
    ["F6"] = 168, ["F7"] = 169, ["F8"] = 56, ["F9"] = 57, ["F10"] = 58,
    ["F11"] = 344, ["F12"] = 345,
    ["H"] = 74, ["E"] = 38, ["G"] = 47, ["M"] = 244, ["K"] = 311, ["L"] = 182,
    ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249,
    ["Y"] = 246, ["U"] = 303, ["T"] = 245, ["P"] = 199, ["O"] = 197, ["I"] = 177,
    ["J"] = 246, ["Q"] = 44, ["R"] = 45, ["W"] = 32, ["A"] = 34, ["S"] = 8, ["D"] = 9,
    ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165,
    ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["0"] = 243,
    ["-"] = 84, ["="] = 83, ["["] = 39, ["]"] = 40, [";"] = 51, ["'"] = 52,
    ["\\"] = 53, ["."] = 81, [","] = 82, ["/"] = 56, ["CAPS"] = 137,
    ["NUM0"] = 82, ["NUM1"] = 79, ["NUM2"] = 80, ["NUM3"] = 81,
    ["NUM4"] = 75, ["NUM5"] = 76, ["NUM6"] = 77, ["NUM7"] = 71,
    ["NUM8"] = 72, ["NUM9"] = 73, ["NUM+"] = 69, ["NUM-"] = 74,
    ["NUM/"] = 309, ["NUM*"] = 298, ["NUMENTER"] = 191, ["NUMDEL"] = 83,
    ["SCROLL"] = 302, ["PAUSE"] = 289, ["INSERT"] = 121, ["HOME"] = 212,
    ["PAGEUP"] = 207, ["PAGEDOWN"] = 208, ["END"] = 201
}


-- ✅ Logging Settings (Enable logs for keybinds)
Config.Logging = {
    Enable = true, -- Log when keybinds are set/removed
    LogFile = "logs/keybinds.log" -- Path to log file (if logging is enabled)
}

-- ✅ Permissions (Restrict Keybinds to Certain Roles)
Config.Permissions = {
    RestrictKeybinds = false, -- Set to true to require permission for setting keybinds
    AllowedGroups = { "admin", "moderator" } -- Only these groups can change keybinds
}

-- ✅ Keybind Reset Settings (Allows server admins to reset keybinds)
Config.AllowReset = true -- If true, admins can use /resetkeybinds to wipe keybinds

-- ✅ Auto-Save Interval (How often keybinds are saved to the database)
Config.AutoSaveInterval = 10 -- In minutes (set to 0 to disable auto-save)

-- ✅ Notification System (Customizable alerts)
Config.Notifications = {
    UseChat = true, -- Send notifications via chat
    UseNotify = false, -- Send notifications via built-in notify system
    NotifyCommand = "qb-notify" -- If using a notify script, set the command
}
