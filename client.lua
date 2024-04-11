local QBCore = exports['qb-core']:GetCoreObject()



PRX_Police = 
{
    [1] = {
        name_car = "Futo",
        model = "futo"
    },
    [2] = {
        name_car = "Hellcat",
        model = "hellcat15"
    },
}


CreateThread(function()
    local coords = vector4(441.37, -974.68, 24.7, 180.49)
    local hash = "prop_parkingpay"
    RequestModel(hash)

    while not HasModelLoaded(hash) do
        Wait(1)
    end
    object = CreateObject(hash, coords.x, coords.y, coords.z, false)
    exports['qb-target']:AddBoxZone("police-garage", vector3(441.39, -974.63, 25.7), 1.5, 1.6, {
        name = "police-garage", -- This is the name of the zone recognized by PolyZone, this has to be unique so it doesn't mess up with other zones
        heading = 0.00,         -- The heading of the boxzone, this has to be a float value
        debugPoly = false,      -- This is for enabling/disabling the drawing of the box, it accepts only a boolean value (true or false), when true it will draw the polyzone in green
        minZ = 22.1,
        maxZ = 26.1
    }, {
        options = {
            {
                event = "police:garage:menu",
                icon = 'fas fa-car-side',
                label = 'Police Garage',
                job = "police"
            }
        },
        distance = 2.5,
    })
end)

RegisterNetEvent("police:garage:menu", function()
    local Menu = { {
        header = 'Law Enforcement Job Garage',
        icon = '',
        isMenuHeader = true, -- Set to true to make a nonclickable title
    }, }
    Menu[#Menu + 1] = {
        header = 'Close',
        txt = '',
        icon = 'fas fa-circle-xmark',
        -- disabled = false, -- optional, non-clickable and grey scale
        -- hidden = true, -- optional, hides the button completely
        params = {
            -- isServer = false, -- optional, specify event type
            event = '',
        }

    }
    for k, v in pairs(PRX_Police) do
        Menu[#Menu + 1] =
        {
            header = "Police" .. ' ' .. v.name_car,
            icon = 'fas fa-car',
            params = {
                event = 'police:garage:spawn',
                args = {
                    model = v.model
                }
            }
        }
    end
    exports['qb-menu']:openMenu(Menu)
end)

RegisterNetEvent("police:garage:spawn", function(args)
    local coordsv4 = vector4(437.23, -976.01, 20.00, 90.4)
    local coordv3 = vector3(coordsv4.x, coordsv4.y, coordsv4.z)
    if QBCore.Functions.SpawnClear(coordv3, 8)then
        QBCore.Functions.SpawnVehicle(args.model, function(veh)
            SetVehicleNumberPlateText(veh, 'Police' .. QBCore.Functions.GetPlayerData().citizenid)
            exports['LegacyFuel']:SetFuel(veh, 100.0)
            TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
            SetVehicleEngineOn(veh, true, true)
        end, coordsv4, true, true)
    else
        QBCore.Functions.Notify("Remove the vehicle to retrieve your vehicle", "error", 5000)
    end
end)
