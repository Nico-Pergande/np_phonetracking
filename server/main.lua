ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

print('^5<^7————————————————————————————— ^5[np_phonetracking]^7 —————————————————————————————^5>^7')
print('^5')
print('^3» ^5Phonetracking by np_dev started')
print('^5')
print('^3» ^2Discord: ^5https://discord.nico-pergande.dev')
print('^3» ^2Twitch: ^5https://twitch.nico-pergande.dev')
print('^5')
print('^5<^7————————————————————————————— ^5[np_phonetracking]^7 —————————————————————————————^5>^7')

ESX.RegisterServerCallback('np_phonetracking:getPlayerPosition', function(source, cb, phoneNumber)
    local xPlayer = ESX.GetPlayerFromId(source)
    if Config.AllowedJobs[xPlayer.job.name] ~= true then cb(false) end

    MySQL.Async.fetchAll('SELECT identifier FROM users WHERE phone_number = @phone', {
        ["@phone"] = phoneNumber
    }, function(result)
        if result[1] then
            local xPlayer = ESX.GetPlayerFromIdentifier(result[1].identifier)

            if xPlayer then
                cb(xPlayer)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)