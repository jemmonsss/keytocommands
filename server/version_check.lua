-- Block letters for version info
local version = [[
/$$      /$$ /$$$$$$$$ /$$        /$$$$$$  /$$$$$$ /$$$$$$$$ /$$     /$$
| $$$    /$$$|__  $$__/| $$       /$$__  $$|_  $$_/|__  $$__/|  $$   /$$/
| $$$$  /$$$$   | $$   | $$      | $$  \__/  | $$     | $$    \  $$ /$$/ 
| $$ $$/$$ $$   | $$   | $$      | $$        | $$     | $$     \  $$$$/  
| $$  $$$| $$   | $$   | $$      | $$        | $$     | $$      \  $$/   
| $$\  $ | $$   | $$   | $$      | $$    $$  | $$     | $$       | $$    
| $$ \/  | $$   | $$   | $$$$$$$$|  $$$$$$/ /$$$$$$   | $$       | $$    
|__/     |__/   |__/   |________/ \______/ |______/   |__/       |__/    

        🚀 Keybind Manager by ^3J_emmons_07^0 | Version: ^21.0.0^0
]]

-- ✅ Server-side: Display the version in the console when the script starts
AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        print("^6===================================================")
        print(version)  -- Print to the console
        print("^6===================================================")

    end
end)
