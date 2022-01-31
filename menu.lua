_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Main Menu", "~b~this is the description")
_menuPool:Add(mainMenu)


bool = false
function FirstItem(menu)
    local checkbox = NativeUI.CreateCheckboxItem("On/off Duty", bool, "Toggle this to go on duty.")
    menu:AddItem(checkbox)
    menu.OnCheckboxChange = function(sender,item,checked_)
        if item == checkbox then
            bool = checked_
            notify(tostring(bool))
        end
    end
end

function SecondItem(menu)
    local click = NativeUI.CreativeItem("Heal", "~g~Heal yourself.")
    menu:AddItem(click)
    menu.OnItemSelect = function(sender,item,index)
        if item == click then
            SetEntityHealth(PlayerPedID(), 200)
            notify("~g~ Healed..")
        end
    end
end

weapons = {
    "WEAPON_STUNGUN",
    "WEAPON_CARBINERIFLE",
    "WEAPON_COMBATPISTOL",
    "WEAPON_NIGHTSTICK",
    "WEAPON_G17",
    "WEAPON_MK18"
}
function ThirdItem(menu)
    local gunList =  NativeUI.CreateListItem("Choose Weapons", weapons, 1)
    menu:AddItem(gunList)
    menu.OnListSelect = function(sender,item,index)
        if item == gunList then
            local selectedGun = item:IndexToItem(index)
            giveWeapon(selectedGun)
            notify("Spawned in a ~b~".. selectedGun)
        end
    end
end

seats = {-1,0,1,2}
function ForthItem(menu)
    local submenu = _menuPool:AddSubMenu(menu, "~b~Essentials")
    local carItem = NativeUI.CreateItem("Vehicle Spawner","Spawns Vehicles")
    carItem.Activated = function(sender,item)
        if item == carItem then
            spawnCar("18charger")
        end
    end
    local seat = NativeUI.CreateSliderItem("Change Seat in Vehicle", seats, 1)
    submenu.OnSliderChange = function(sender, item, index)
        if item == seat then
            vehSeat = item:IndexToItem(index)
            local pedsCar = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            SetPedIntoVehicle(PlayerPedId(), pedsCar, vehSeat)
        end
    end
    submenu:AddItem(carItem)
    submenu:AddItem(seat)
end



-- Initalizing Menu

FirstItem(mainMenu)
SecondItem(mainMenu)
ThirdItem(mainMenu)
ForthItem(mainMenu)
_menuPool:RefreshIndex()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        if IsControlJustPressed(1,56) then
            mainMenu:Visible(not mainMenu:visible())
        end
    end
end)




















function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end

function giveWeapon(hash)
    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(hash), 999, false, false)
end

function spawnCar(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(50)
    end

    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), false))
    local vehicle = CreateVehicle(car, x + 2, y + 2, z + 1, GetEntityHeading(PlayerPedId()), true, false)
    SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
    
    SetEntityAsNoLongerNeeded(vehicle)
    SetModelAsNoLongerNeeded(vehicleName)
    
    --[[ SetEntityAsMissionEntity(vehicle, true, true) ]]
end