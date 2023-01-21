--NovaMeter by Nova_Plays my discord is Nova_Plays#9126
--if you have problems or new ideas be free to dm me or ping me in the discord server i own

util.keep_running()
util.require_natives(1651208000)

-----------------
--update system--
-----------------
local status, auto_updater = pcall(require, "auto-updater")
if not status then
    local auto_update_complete = nil util.toast("Installing auto-updater...", TOAST_ALL)
    async_http.init("raw.githubusercontent.com", "/hexarobi/stand-lua-auto-updater/main/auto-updater.lua",
        function(result, headers, status_code)
            local function parse_auto_update_result(result, headers, status_code)
                local error_prefix = "Error downloading auto-updater: "
                if status_code ~= 200 then util.toast(error_prefix..status_code, TOAST_ALL) return false end
                if not result or result == "" then util.toast(error_prefix.."Found empty file.", TOAST_ALL) return false end
                filesystem.mkdir(filesystem.scripts_dir() .. "lib")
                local file = io.open(filesystem.scripts_dir() .. "lib\\auto-updater.lua", "wb")
                if file == nil then util.toast(error_prefix.."Could not open file for writing.", TOAST_ALL) return false end
                file:write(result) file:close() util.toast("Successfully installed auto-updater lib", TOAST_ALL) return true
            end
            auto_update_complete = parse_auto_update_result(result, headers, status_code)
        end, function() util.toast("Error downloading auto-updater lib. Update failed to download.", TOAST_ALL) end)
    async_http.dispatch() local i = 1 while (auto_update_complete == nil and i < 40) do util.yield(250) i = i + 1 end
    if auto_update_complete == nil then error("Error downloading auto-updater lib. HTTP Request timeout") end
    auto_updater = require("auto-updater")
end
if auto_updater == true then error("Invalid auto-updater lib. Please delete your Stand/Lua Scripts/lib/auto-updater.lua and try again") end

local default_check_interval = 604800
local auto_update_config = {
    source_url="https://raw.githubusercontent.com/NovaPlays134/NovaMeter/main/NovaMeter.lua",
    script_relpath=SCRIPT_RELPATH,
    switch_to_branch=selected_branch,
    verify_file_begins_with="--",
    check_interval=86400,
    silent_updates=true,
    dependencies={
        {
            name="NovaMeterLogo",
            source_url="https://raw.githubusercontent.com/NovaPlays134/NovaMeter/main/resources/NovaMeter/NovaMeterLogo.png",
            script_relpath="resources/NovaMeter/NovaMeterLogo.png",
            check_interval=default_check_interval,
        },

		{
            name="background",
            source_url="https://raw.githubusercontent.com/NovaPlays134/NovaMeter/main/resources/NovaMeter/background.png",
            script_relpath="resources/NovaMeter/background.png",
            check_interval=default_check_interval,
        },

		{
            name="meterline",
            source_url="https://raw.githubusercontent.com/NovaPlays134/NovaMeter/main/resources/NovaMeter/meterline.png",
            script_relpath="resources/NovaMeter/meterline.png",
            check_interval=default_check_interval,
        },

		{
            name="meterline2",
            source_url="https://raw.githubusercontent.com/NovaPlays134/NovaMeter/main/resources/NovaMeter/meterline2.png",
            script_relpath="resources/NovaMeter/meterline2.png",
            check_interval=default_check_interval,
        },

		{
            name="pin",
            source_url="https://raw.githubusercontent.com/NovaPlays134/NovaMeter/main/resources/NovaMeter/pin.png",
            script_relpath="resources/NovaMeter/pin.png",
            check_interval=default_check_interval,
		}
    }
}
auto_updater.run_auto_update(auto_update_config)

-----------------
--GETTING FILES--
-----------------
resources_dir = filesystem.resources_dir() .. '\\NovaMeter\\'

local speedometer = directx.create_texture(resources_dir .. "meterline.png")
local speedometer2 = directx.create_texture(resources_dir .. "meterline2.png")
local speedometerpin = directx.create_texture(resources_dir .. "pin.png")
local background = directx.create_texture(resources_dir .. "background.png")
local logo = directx.create_texture(resources_dir .. "NovaMeterLogo.png")
----------
--COLORS--
----------
local black = {["r"] = 0, ["g"] = 0, ["b"] = 0, ["a"] = 1.0}
local gray = {["r"] = 88/255, ["g"] = 87/255, ["b"] = 87/255, ["a"] = 1.0}
local white = {["r"] = 1, ["g"] = 1, ["b"] = 1, ["a"] = 1.0}
local blue = {["r"] = 0, ["g"] = 103/255, ["b"] = 165/255, ["a"] = 1.0}
local lightblue = {["r"] = 150/255, ["g"] = 202/255, ["b"] = 230/255, ["a"] = 1.0}
--background--
local background_color = gray
--speedometer--
local speedometer_color = black
--speedometer2--
local speedometer2_color = white
--pin--
local speedometerpin_color = black
--pin2--
local speedometerpin2_color = blue
--txt--
local unit_color = black
--txt2--
local unit2_color = lightblue

-----------
--OPTIONS--
-----------
--unit--
local mesh = 1
menu.list_select(menu.my_root(), "Measurement", {""}, "", {"MPH", "KPH"}, 1, function(index)
    mesh = index 
end)

local change = 1
menu.list_select(menu.my_root(), "Switch speedometer", {""}, "", {"Default", "NFS Speedometer"}, 1, function(index)
    change = index
end)

--position--
local speedometer_posX = 0.913
local speedometer_posY = 0.88
local txt_posX = 0.913
local txt_posY = 0.88 + 0.050
local txt2_posY = 0.88 + 0.064

--lists--
local remove_list = menu.list(menu.my_root(), "Remove Parts")
local color_list = menu.list(menu.my_root(), "Color's")
local position_list = menu.list(menu.my_root(), "Position")

--removes--
local remback = false
menu.toggle(remove_list, "Background", {}, "Removes the background.", function(include)
	remback = include
end, false)

local remmeter = false
menu.toggle(remove_list, "Speedometer line", {}, "Removes the speedometer line.", function(include)
	remmeter = include
end, false)

local remmeterpin = false
menu.toggle(remove_list, "Speedometer pin", {}, "Removes the pin.", function(include)
	remmeterpin = include
end, false)

local remtxt = false
menu.toggle(remove_list, "Measurement text", {}, "Removes the text.", function(include)
	remtxt = include
end, false)

--colors--
menu.colour(color_list, "Change speedometer background color", {}, "", background_color, true, function(colour)
	background_color = colour
end)

menu.colour(color_list, "Change speedometer colour", {}, "", speedometer_color, true, function(colour)
	speedometer_color = colour
	speedometer2_color = colour
end)

menu.colour(color_list, "Change speedometer pin colour", {}, "", speedometerpin_color, true, function(colour)
	speedometerpin_color = colour
	speedometerpin2_color = colour
end)

menu.colour(color_list, "Change speedometer unit colour", {}, "", unit_color, true, function(colour)
	unit_color = colour
	unit2_color = colour
end)

--position--
local txtposX = 0.913
menu.slider(position_list, "Speedometer pos X", {}, "Default value is 913", 1, 1000, speedometer_posX * 1000, 1, function(x)
	speedometer_posX = x / 1000
	txtposX = x / 1000
end)

menu.slider(position_list, "Speedometer pos Y", {}, "Default value is 888", 1, 1000, speedometer_posY * 1000, 1, function(y)
	speedometer_posY = y / 1000
	txt_posY = y / 1000 + 0.050
	txt2_posY = y / 1000 + 0.064
end)

menu.action(menu.my_root(), "Check for Update", {}, "The script will automatically check for updates at most daily, but you can manually check using this option anytime.", function()
    auto_update_config.check_interval = 0
    if auto_updater.run_auto_update(auto_update_config) then
        util.toast("No updates found")
    end
end)
menu.action(menu.my_root(), "Clean Reinstall", {}, "Force an update to the latest version, regardless of current version.", function()
    auto_update_config.clean_reinstall = true
    auto_updater.run_auto_update(auto_update_config)
end)

--logo loading--
if SCRIPT_MANUAL_START and not SCRIPT_SILENT_START then
    local fade_steps = 50
	-- Fade In
	for i = 0,fade_steps do
		directx.draw_texture(logo, 0.10, 0.10, 0.5, 0.5, 0.5, 0.5, 0, 1, 1, 1, i/fade_steps)
		util.yield()
	end
	for i = 0,100 do
		directx.draw_texture(logo, 0.10, 0.10, 0.5, 0.5, 0.5, 0.5, 0, 1, 1, 1, 1)
		util.yield()
	end
	-- Fade Out
	for i = fade_steps,0,-1 do
		directx.draw_texture(logo, 0.10, 0.10, 0.5, 0.5, 0.5, 0.5, 0, 1, 1, 1, i/fade_steps)
		util.yield()
	end
end

while true do 
	local veh = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
	if veh ~= 0 and PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
		local speed = ENTITY.GET_ENTITY_SPEED(veh)
		local mph = speed * 2.236936
		local kph = speed * 3.6
		local maxspeed = VEHICLE.GET_VEHICLE_ESTIMATED_MAX_SPEED(veh)
		local max_mph = maxspeed * 2.236936
		local max_kph = maxspeed * 3.6
		local value = " mph"
	
			if mesh == 1 then 
				measured_speed = mph 
				measured_max = max_mph
			else
				measured_speed = kph
				measured_max = max_kph
				value = " kmh"
			end
			local cal_speed = math.ceil(measured_speed)

			if cal_speed < 10 then
				txt_posX = txtposX - 0.017
		    elseif cal_speed >= 100 then
				txt_posX = txtposX - 0.022
			else
				txt_posX = txtposX - 0.019
			end

			local speed_rotation = (measured_speed/measured_max)*0.42
			    if speed_rotation >= 0.75 then 
				    speed_rotation = 0.75
			    end
	if change == 1 then
		--background--
		if remback == false then
		directx.draw_texture(background, 0.07, 0.07, 0.5, 0.5, speedometer_posX, speedometer_posY, 0.0, background_color)
		end
		--speedometerline--
		if remmeter == false then
		directx.draw_texture(speedometer, 0.066, 0.066, 0.5, 0.5, speedometer_posX, speedometer_posY, 0.0, speedometer_color)
        end
        --pin--
		if remmeterpin == false then
		directx.draw_texture(speedometerpin, 0.023, 0.023, 0.88, 0.125, speedometer_posX, speedometer_posY, speed_rotation, speedometerpin_color)
        end
		--speed--
		if remtxt == false then
		directx.draw_text(txt_posX, txt_posY, cal_speed .. value, ALIGN_TOP_LEFT, 0.6, unit_color, true)
		end
	else
		--speedometerline2--
		directx.draw_texture(speedometer2, 0.066, 0.066, 0.5, 0.5, speedometer_posX, speedometer_posY, 0.0, speedometer2_color)
		--pin--
		if remmeterpin == false then
		directx.draw_texture(speedometerpin, 0.023, 0.023, 0.88, 0.125, speedometer_posX, speedometer_posY, speed_rotation, speedometerpin2_color)
		end
		--speed--
		if remtxt == false then
		directx.draw_text(txt_posX, txt2_posY, cal_speed .. value, ALIGN_TOP_LEFT, 0.6, unit2_color, true)
		end
	end

    end
    util.yield()
end
