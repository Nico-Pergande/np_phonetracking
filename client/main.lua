ESX = nil
TrackerRunning = false
Target = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterCommand('tracking', function()
    TriggerEvent("np_phonetracking:openMenu")
end, false)

RegisterNetEvent("np_phonetracking:openMenu")
AddEventHandler("np_phonetracking:openMenu", function()
    if Config.AllowedJobs[ESX.PlayerData.job.name] ~= true then return end
    ESX.UI.Menu.CloseAll()

    local elements = {
        {label = _U('start_tracking'), value = 'start_tracking'},
        {label = _U('stop_tracking'), value = 'stop_tracking'}
	}

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tracking_menu', {
        title = _U('menu_name'),
        align = 'top-left',
        elements = elements
    },
    function(data, menu)
        local action = data.current.value
        if action == 'start_tracking' then
            requestPhoneNumber()
        elseif action == 'stop_tracking' then
            stopTracking()
        end
    end,
    function(data,menu)
        menu.close()
    end)
end)

function requestPhoneNumber()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'tracking_input_phone', {
		title = _U('enter_phone_number'),
    }, function(data, menu)
        ESX.TriggerServerCallback("np_phonetracking:getPlayerPosition", function(result)
            if result == nil or result == false then
                ESX.ShowNotification(_U("tracking_failed"))
            else
                local p = GetPlayerFromServerId(result.source)
                startTracking(GetPlayerPed(p))
            end
        end, data.value)
        menu.close() 
	end, function(data, menu)
		menu.close()
	end)
end

function startTracking(entity)
    if TrackerRunning then 
        ESX.ShowNotification(_U("tracking_already_running"))
        return
    end
    ESX.ShowNotification(_U("tracking_started_1")) -- wird gestartet
    Citizen.Wait(20000) -- Cooldown
    TrackerRunning = true
    ESX.ShowNotification(_U("tracking_started_2")) -- gestartet
    Target = AddBlipForEntity(entity)
    SetBlipHiddenOnLegend(Target, true)
    if Config.ShowLookAt then
        SetBlipSprite(Target, 42)
        SetBlipShowCone(Target, true)
    else
        SetBlipSprite(Target, 161)
    end
    SetBlipScale(Target, 0.5)
    Citizen.SetTimeout(Config.Timeout, function()
        stopTracking()
    end)
end

function stopTracking()
    ESX.ShowNotification(_U("tracking_stopped"))
    RemoveBlip(Target)
    TrackerRunning = false
end