local ServerStartTime = os.time()
local CommandCount = 0
local PlayerData = {}

RageUI = RageUI or {}
RageUI.Server = {}

function RageUI.Server.GetPlayerData(source)
    local src = tonumber(source)
    return PlayerData[src] or {
        source = src,
        name = GetPlayerName(src) or "Inconnu",
        cash = 0,
        bank = 0,
        job = "Sans emploi",
        ping = 0,
        connected = true,
        firstJoin = os.time()
    }
end

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local source = source
    print(string.format("[RageUI] %s (ID: %s) connecte au serveur.", playerName or "Inconnu", source))
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    local name = GetPlayerName(source) or "Inconnu"
    PlayerData[tonumber(source)] = nil
    print(string.format("[RageUI] %s (ID: %s) deconnecte. Raison: %s", name, source, reason))

    TriggerClientEvent('RageUI:ServerNotification', -1, {
        text = string.format("%s a quitte le serveur", name),
        style = "warning",
        duration = 4000
    })
end)

RegisterNetEvent('RageUI:InitPlayer')
AddEventHandler('RageUI:InitPlayer', function()
    local source = source
    local srcNum = tonumber(source)
    local name = GetPlayerName(source) or "Inconnu"

    PlayerData[srcNum] = {
        source = srcNum,
        name = name,
        cash = 5000,
        bank = 15000,
        job = "Citoyen",
        ping = 0,
        connected = true,
        firstJoin = os.time()
    }

    TriggerClientEvent('RageUI:ServerNotify', source, {
        text = string.format("Bienvenue ~g~%s~s~ sur le serveur RageUI!", name),
        style = "success",
        duration = 5000
    })

    TriggerClientEvent('RageUI:PlayerData', source, RageUI.Server.GetPlayerData(source))

    TriggerClientEvent('RageUI:ServerNotification', -1, {
        text = string.format("%s a rejoint le serveur", name),
        style = "info",
        duration = 4000
    })
end)

RegisterNetEvent('RageUI:ServerNotify')
AddEventHandler('RageUI:ServerNotify', function(data)
    local source = source
    if data and data.text then
        TriggerClientEvent('RageUI:ServerNotify', source, data)
    end
end)

RegisterNetEvent('RageUI:ValidateCommand')
AddEventHandler('RageUI:ValidateCommand', function(command)
    local source = source
    if not command then return end
    CommandCount = CommandCount + 1

    local args = {}
    for arg in command:gmatch("%S+") do
        table.insert(args, arg)
    end

    local cmd = args[1] and args[1]:lower() or ""
    table.remove(args, 1)

    if cmd == "givecash" then
        local target = tonumber(args[1])
        local amount = tonumber(args[2])
        if target and amount and amount > 0 then
            local pData = RageUI.Server.GetPlayerData(source)
            local tData = PlayerData[target]
            if tData then
                if pData.cash >= amount then
                    pData.cash = pData.cash - amount
                    tData.cash = (tData.cash or 0) + amount
                    TriggerClientEvent('RageUI:ServerNotify', target, {
                        text = string.format("~g~$%s~s~ recu de %s", amount, GetPlayerName(source) or "Inconnu"),
                        style = "success"
                    })
                    TriggerClientEvent('RageUI:ServerNotify', source, {
                        text = string.format("~g~$%s~s~ envoye a %s", amount, GetPlayerName(target) or "Inconnu"),
                        style = "success"
                    })
                    TriggerClientEvent('RageUI:PlayerData', source, pData)
                    TriggerClientEvent('RageUI:PlayerData', target, tData)
                else
                    TriggerClientEvent('RageUI:ServerNotify', source, {
                        text = "~r~Argent insuffisant!",
                        style = "error"
                    })
                end
            else
                TriggerClientEvent('RageUI:ServerNotify', source, {
                    text = "~r~Joueur cible hors ligne!",
                    style = "error"
                })
            end
        end
    elseif cmd == "help" then
        TriggerClientEvent('RageUI:ServerNotify', source, {
            text = "Commandes: givecash [id] [montant], stats, position, joueurs",
            style = "info"
        })
    elseif cmd == "stats" then
        local pData = RageUI.Server.GetPlayerData(source)
        TriggerClientEvent('RageUI:ServerNotify', source, {
            text = string.format("Cash: ~g~$%s~s~ | Banque: ~b~$%s~s~ | Job: ~y~%s", pData.cash, pData.bank, pData.job),
            style = "info"
        })
    elseif cmd == "joueurs" then
        local players = GetPlayers()
        TriggerClientEvent('RageUI:ServerNotify', source, {
            text = string.format("Joueurs connectes: ~b~%d", #players),
            style = "info"
        })
    elseif cmd == "position" then
        print(string.format("[RageUI] Commande position demandee par %s (%s)", GetPlayerName(source), source))
        TriggerClientEvent('RageUI:ServerNotify', source, {
            text = "Position enregistree (voir console serveur)",
            style = "info"
        })
    else
        TriggerClientEvent('RageUI:ServerNotify', source, {
            text = string.format("Commande inconnue: ~r~%s~s~ | Tapez /help", cmd),
            style = "warning"
        })
    end
end)

RegisterNetEvent('RageUI:GetPlayers')
AddEventHandler('RageUI:GetPlayers', function()
    local source = source
    local players = {}
    for _, sid in ipairs(GetPlayers()) do
        local pData = RageUI.Server.GetPlayerData(sid)
        table.insert(players, {
            id = tonumber(sid),
            name = pData.name,
            job = pData.job,
            ping = GetPlayerPing(sid)
        })
    end
    TriggerClientEvent('RageUI:PlayersList', source, players)
end)

RegisterNetEvent('RageUI:GetDashboard')
AddEventHandler('RageUI:GetDashboard', function()
    local source = source
    TriggerClientEvent('RageUI:DashboardData', source, {
        players = #GetPlayers(),
        uptime = os.difftime(os.time(), ServerStartTime) .. "s",
        ping = GetPlayerPing(source),
        commands = CommandCount
    })
end)

RegisterNetEvent('RageUI:RestartResource')
AddEventHandler('RageUI:RestartResource', function()
    local source = source
    local name = GetPlayerName(source)
    
    -- Check permissions before restarting
    if not IsPlayerAceAllowed(source, "command.restart") then
        print(string.format("[RageUI] %s (%s) a tente de redemarrer la ressource sans permission.", name, source))
        TriggerClientEvent('RageUI:ServerNotify', source, {
            text = "~r~Vous n'avez pas la permission de faire cela.",
            style = "error"
        })
        return
    end

    print(string.format("[RageUI] %s (%s) a demande le redemarrage de la ressource.", name, source))
    TriggerClientEvent('RageUI:ServerNotify', source, {
        text = "Redemarrage de la resource...",
        style = "warning"
    })
    Citizen.Wait(500)
    ExecuteCommand("restart " .. GetCurrentResourceName())
end)





local function SendNotificationToAll(text, style, duration)
    TriggerClientEvent('RageUI:ServerNotify', -1, {
        text = text,
        style = style or "info",
        duration = duration or 4000
    })
end

RageUI.Server.NotifyAll = SendNotificationToAll

print(string.format("[RageUI] Serveur charge | RageUI By CypherDev Like UnityRP"))
