local oxmysql = exports.oxmysql

-- ✅ Logging Function (Only logs if enabled in Config)
function LogKeybindAction(message)
    if Config.Logging.Enable then
        print("^5[Keybind Manager]^0 " .. message)
    end
end

-- ✅ Send Notifications (Supports Chat & Notify Systems)
function SendNotification(src, message)
    if Config.Notifications.UseChat then
        TriggerClientEvent('chat:addMessage', src, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Keybind Manager", message}
        })
    elseif Config.Notifications.UseNotify then
        TriggerClientEvent(Config.Notifications.NotifyCommand, src, {
            type = "info",
            text = message
        })
    end
end

-- ✅ Auto-create table on server start (If database is enabled)
Citizen.CreateThread(function()
    if Config.UseDatabase then
        oxmysql:execute([[
            CREATE TABLE IF NOT EXISTS `keybinds` (
                `id` INT AUTO_INCREMENT PRIMARY KEY,
                `identifier` VARCHAR(50) NOT NULL,
                `key` VARCHAR(10) NOT NULL,
                `command` VARCHAR(255) NOT NULL
            );
        ]], {}, function()
            LogKeybindAction("Database check complete. Table ready!")
        end)
    end
end)

-- ✅ Fetch Keybinds When the Menu Opens
RegisterNetEvent("server:fetchKeybinds")
AddEventHandler("server:fetchKeybinds", function()
    local src = source
    RefreshKeybindsForPlayer(src)
end)

-- ✅ Save Keybind to Database & Refresh UI
RegisterNetEvent('server:saveKeybind')
AddEventHandler('server:saveKeybind', function(key, command)
    if not Config.UseDatabase then return end

    local src = source
    local identifier = GetPlayerIdentifier(src, 0)

    oxmysql:execute("REPLACE INTO keybinds (identifier, key, command) VALUES (?, ?, ?)", {identifier, key, command}, function()
        LogKeybindAction("Keybind saved for " .. identifier .. ": " .. key .. " → " .. command)
        SendNotification(src, "Keybind for " .. key .. " saved successfully!")

        -- ✅ Refresh UI
        RefreshKeybindsForPlayer(src)
    end)
end)

-- ✅ Remove Keybind from Database & Refresh UI
RegisterNetEvent('server:removeKeybind')
AddEventHandler('server:removeKeybind', function(key)
    if not Config.UseDatabase then return end

    local src = source
    local identifier = GetPlayerIdentifier(src, 0)

    oxmysql:execute("DELETE FROM keybinds WHERE identifier = ? AND key = ?", {identifier, key}, function()
        LogKeybindAction("Keybind removed for " .. identifier .. ": " .. key)
        SendNotification(src, "Keybind for " .. key .. " removed!")

        -- ✅ Refresh UI
        RefreshKeybindsForPlayer(src)
    end)
end)

-- ✅ Reset All Keybinds for a Player (Only if Config.AllowReset is enabled)
RegisterCommand("resetkeybinds", function(source, args, rawCommand)
    if not Config.AllowReset then
        print("^1[Keybind Manager]^0 Keybind reset is disabled in Config.")
        return
    end

    local src = source
    local identifier = GetPlayerIdentifier(src, 0)

    oxmysql:execute("DELETE FROM keybinds WHERE identifier = ?", {identifier}, function()
        LogKeybindAction("All keybinds reset for " .. identifier)
        TriggerClientEvent('client:resetKeybinds', src)
        SendNotification(src, "All keybinds have been reset!")

        -- ✅ Refresh UI
        RefreshKeybindsForPlayer(src)
    end)
end, false)

-- ✅ Function to Send Updated Keybinds to Client
function RefreshKeybindsForPlayer(src)
    local identifier = GetPlayerIdentifier(src, 0)

    oxmysql:execute("SELECT key, command FROM keybinds WHERE identifier = ?", {identifier}, function(result)
        local keybinds = {}

        for _, row in ipairs(result) do
            table.insert(keybinds, { key = row.key, command = row.command })
        end

        -- ✅ Send updated keybinds to UI
        TriggerClientEvent("client:updateKeybinds", src, {
            keybinds = keybinds,
            buttonColor = Config.UI.ButtonColor,
            hoverColor = Config.UI.HoverColor
        })

        LogKeybindAction("Keybinds refreshed for " .. identifier)
    end)
end
