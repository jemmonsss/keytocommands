local keybinds = Config.DefaultKeybinds -- ✅ Load default keybinds from config

-- ✅ Debugging to ensure the script runs
print("^3[DEBUG]^0 client.lua loaded successfully!")

-- ✅ Load keybinds from the database (if enabled in config)
RegisterNetEvent('client:loadKeybinds')
AddEventHandler('client:loadKeybinds', function(dbKeybinds)
    if Config.UseDatabase then
        for _, keybind in ipairs(dbKeybinds) do
            keybinds[keybind.key] = keybind.command
        end
        if Config.Debug then
            print("^2[Keybind Manager]^0 Keybinds loaded from database.")
        end
    end
end)

-- ✅ Key mappings for FiveM controls
local validControls = Config.ValidControls -- ✅ Load valid keys from config

function GetKeyMappingID(key)
    return validControls[key:upper()]
end

-- ✅ Register default keybinds (Handles F2 = "keybindmenu")
Citizen.CreateThread(function()
    Citizen.Wait(1000) -- Give time for everything to load
    for key, command in pairs(Config.DefaultKeybinds) do
        if validControls[key:upper()] then
            keybinds[key] = command
            print("^2[Keybind Manager]^0 Loaded default keybind: " .. key .. " → " .. command)
        else
            print("^1[ERROR]^0 Invalid default keybind: " .. key)
        end
    end
end)

-- ✅ Detect key presses (optimized)
Citizen.CreateThread(function()
    while true do
        if next(keybinds) == nil then 
            Citizen.Wait(500) -- ✅ Reduce CPU usage when no keybinds exist
        else
            Citizen.Wait(0)
            for key, command in pairs(keybinds) do
                local keyID = GetKeyMappingID(key)
                if keyID and IsControlJustReleased(0, keyID) then
                    ExecuteCommand(command)
                end
            end
        end
    end
end)

-- ✅ Open the NUI menu with UI Customization
RegisterCommand("keybindmenu", function()
    print("^3[DEBUG]^0 /keybindmenu command executed!")

    if not SendNUIMessage then
        print("^1[ERROR]^0 SendNUIMessage is nil. Possible NUI issue.")
        return
    end

    if not SetNuiFocus then
        print("^1[ERROR]^0 SetNuiFocus is nil. Possible function issue.")
        return
    end

    -- ✅ Request latest keybinds from server before opening menu
    TriggerServerEvent("server:fetchKeybinds")

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openKeybindMenu",
        keybinds = keybinds,
        menuTitle = Config.UI.MenuTitle,
        buttonColor = Config.UI.ButtonColor,
        hoverColor = Config.UI.HoverColor,
        backgroundColor = Config.UI.BackgroundColor -- ✅ Apply background color
    })

    print("^2[Keybind Manager]^0 NUI Open Triggered!")
end, false)

-- ✅ Open NUI Menu
function OpenKeybindMenu_NUI()
    print("^3[DEBUG]^0 Opening NUI menu...")

    local keybindList = {}
    for key, command in pairs(keybinds) do
        table.insert(keybindList, { key = key, command = command })
    end

    SendNUIMessage({
        action = "openKeybindMenu",
        keybinds = keybindList
    })

    SetNuiFocus(true, true)
end

-- ✅ Refresh keybinds before opening the menu
RegisterNetEvent("client:updateKeybinds")
AddEventHandler("client:updateKeybinds", function(keybinds)
    SendNUIMessage({
        action = "refreshKeybinds",
        keybinds = keybinds
    })
end)

-- ✅ Remove a keybind and refresh UI
RegisterNUICallback("removeKeybind", function(data, cb)
    local key = data.key
    if keybinds[key] then
        keybinds[key] = nil
        SetResourceKvp("custom_keybinds", json.encode(keybinds))

        -- ✅ Save to database if enabled
        if Config.UseDatabase then
            TriggerServerEvent('server:removeKeybind', key)
        end
    end

    -- ✅ Refresh keybinds instantly
    SendNUIMessage({
        action = "refreshKeybinds",
        keybinds = keybinds
    })

    cb("ok")
end)

-- ✅ Bind a key and refresh UI without closing the menu
RegisterNUICallback("bindKey", function(data, cb)
    local key = data.key:upper()
    local command = data.command

    local keyID = GetKeyMappingID(key)
    if not keyID then
        cb("invalid")
        return
    end

    keybinds[key] = command
    SetResourceKvp("custom_keybinds", json.encode(keybinds))

    -- ✅ Save to database if enabled
    if Config.UseDatabase then
        TriggerServerEvent('server:saveKeybind', key, command)
    end

    -- ✅ Refresh keybinds instantly
    SendNUIMessage({
        action = "refreshKeybinds",
        keybinds = keybinds
    })

    cb("ok")
end)

-- ✅ Close menu and release mouse focus
RegisterNUICallback("closeMenu", function(_, cb)
    print("^3[DEBUG]^0 Closing NUI menu...")
    SetNuiFocus(false, false)
    cb("ok")
end)

-- ✅ Set NUI Focus manually (fixes mouse issue)
RegisterNUICallback("setNuiFocus", function(data, cb)
    local focus = data.focus
    SetNuiFocus(focus, focus)
    cb("ok")
end)

-- ✅ Auto-load keybinds when the player joins
Citizen.CreateThread(function()
    Citizen.Wait(5000) -- Wait for FiveM to fully load
    if Config.UseDatabase then
        print("^3[DEBUG]^0 Requesting keybinds from database...")
        TriggerServerEvent('server:loadKeybinds')
    end
end)
