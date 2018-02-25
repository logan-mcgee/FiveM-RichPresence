local WaitTime = 10000 -- How often do you want to update the status (In MS)


Citizen.CreateThread(function()
	while true do
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
		local StreetHash = GetStreetNameAtCoord(x, y, z)
		Citizen.Wait(WaitTime)
		if StreetHash ~= nil then
			StreetName = GetStreetNameFromHashKey(StreetHash)
			if IsPedOnFoot(PlayerPedId()) and not IsEntityInWater(PlayerPedId()) then
				if IsPedRunning(PlayerPedId()) or GetEntitySpeed(PlayerPedId()) > 2.0 then
					SetRichPresence("Running down "..StreetName)
				elseif not IsPedRunning(PlayerPedId()) and GetEntitySpeed(PlayerPedId()) > 1.0 and GetEntitySpeed(PlayerPedId()) < 2.0 then
					SetRichPresence("Walking down "..StreetName)
				else
					SetRichPresence("Standing on "..StreetName)
				end
			elseif GetVehiclePedIsUsing(PlayerPedId()) ~= nil and not IsPedInAnyHeli(PlayerPedId()) and not IsPedInAnyPlane(PlayerPedId()) and not IsPedOnFoot(PlayerPedId()) and not IsPedInAnySub(PlayerPedId()) and not IsPedInAnyBoat(PlayerPedId()) then
				local MPH = math.ceil(GetEntitySpeed(GetVehiclePedIsUsing(PlayerPedId())) * 2.236936)
				local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
				if MPH > 50 then
					SetRichPresence("Speeding down "..StreetName.." In a "..VehName)
				elseif MPH <= 50 and MPH > 0 then
					SetRichPresence("Cruising down "..StreetName.." In a "..VehName)
				elseif MPH == 0 then
					SetRichPresence("Parked on "..StreetName.." In a "..VehName)
				end
			elseif IsPedInAnyHeli(PlayerPedId()) or IsPedInAnyPlane(PlayerPedId()) then
				local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
				SetRichPresence("Flying over "..StreetName.." in a "..VehName)
			elseif IsEntityInWater(PlayerPedId()) then
				SetRichPresence("Swimming around")
			elseif IsPedInAnyBoat(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
				local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
				SetRichPresence("Sailing around in a "..VehName)
			elseif IsPedInAnySub(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
				SetRichPresence("In a yellow submarine")
			end
		end
	end
end)
