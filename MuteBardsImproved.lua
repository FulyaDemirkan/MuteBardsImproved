MBI = {
  name = "MuteBardsImproved",
  version = "1.0.0",
  author = "psi-pisi"
};

local currentZone;

local defaultZones = {
  "Mistral",                          -- Zone: Khenarthi's Roost    Location: Mistral               Bard: Eye-Fancy
  "Skywatch Wayshrine",               -- Zone: Auridon              Location: Skywatch              Bard: Annagail
  "Skywatch",                         -- Zone: Auridon              Location: Skywatch              Bard: Lorais
  "Firsthold",                        -- Zone: Auridon              Location: Firsthold             Bard: Ealare
  "Elden Root",                       -- Zone: Grathwood            Location: Elden Root            Bard: Fasana
  "Marbruk",                          -- Zone: Greenshade           Location: Marbruk               Bard: Elderien
  "Woodhearth",                       -- Zone: Greenshade           Location: Woodhearth            Bard: Rendarion
  "Velyn Harbor",                     -- Zone: Malabal Tor          Location: Velyn Harbor          Bard: Gilinora Birdsong
  "Daggerfall Castle Town",           -- Zone: Glenumbra            Location: Daggerfall            Bard: Axel Plourde
  "Wayrest Residential District",     -- Zone: Stormhaven           Location: Wayrest               Bard: Oceane Coravel
  "Davon's Watch",                    -- Zone: Stonefalls           Location: Davon's Watch         Bard: Siriaki Black-Owl
  "Ebonheart",                        -- Zone: Stonefalls           Location: Ebonheart             Bard: Helpirion
  "Kragenmoor",                       -- Zone: Stonefalls           Location: Kragenmoor            Bard: Odrys Drim
  "Mournhold Residential District",   -- Zone: Deshaan              Location: Mournhold             Bard: Athanas Samori
  "Mournhold Guild Plaza",            -- Zone: Deshaan              Location: Mournhold             Bard: Ophalia Strong-Voice
  "Riften",                           -- Zone: The Rift             Location: Riften                Bard: Anriel
  "Nimalten",                         -- Zone: The Rift             Location: Nimalten              Bard: Enjaadia
  "Ivarstead",                        -- Zone: The Rift             Location: Ivarstead             Bard: Eofel
  "Windhelm",                         -- Zone: Eastmarch            Location: Windhelm              Bard: Arani Longhair & Garrimar & Nil the Bard & Fargurd
  "Fort Amol",                        -- Zone: Eastmarch            Location: Fort Amol             Bard: Holsorr the Tuneful
  "Stormhold",                        -- Zone: Shadowfen            Location: Stormhold             Bard: Littrel Green-Hilt
  "Rawl'kha",                         -- Zone: Reaper's March       Location: Rawl'kha              Bard: No name
  "Sentinel",                         -- Zone: Alik'r Dessert       Location: Sentinel              Bard: Serosh & Taralqua the Minstrel
  "Evermore",                         -- Zone: Bangkorai            Location: Evermore              Bard: Nimirazan
  "Belkarth",                         -- Zone: Craglorn             Location: Belkarth              Bard: Petronious Libo
  "Dragonstar",                       -- Zone: Craglorn             Location: Dragonstar            Bard: Beritta Crow-Song
  "Leyawiin",                         -- Zone: Blackwood            Location: Leyawiin              Bard: Audania Decanius 
  "Gideon",                           -- Zone: Blackwood            Location: Gideon                Bard: Haderus Vano
  "Fargrave City District",           -- Zone: The Deadlands        Location: Fargrave              Bard: Tirasie Mirel & Alain Caria
  "Vastyr",                           -- Zone: Galen                Location: Vastyr                Bard: Luce Gemain
  "Gonfalon Bay",                     -- Zone: High Isle            Location: Gonfalon Bay          Bard: Portic Boulat
  "Lilmoth",                          -- Zone: Murkmire             Location: Lilmoth               Bard: Kalanu
  "Bright-Throat Village",            -- Zone: Murkmire             Location: Bright-Throat Village Bard: Ah-Seshs
  "Rimmen",                           -- Zone: Northern Elsweyr     Location: Rimmen                Bard: Daahin
  "Senchal",                          -- Zone: Southern Elsweyr     Location: Senchal               Bard: Ja-zinki & Rakzzin
  "Alinor",                           -- Zone: Summerset            Location: Alinor                Bard: Laeriwene
  "Shimmerene",                       -- Zone: Summerset            Location: Shimmerene            Bard: Endolale
  "Necrom",                           -- Zone: Telvanni Peninsula   Location: Necrom                Bard: Tolvise DoSWran
  "Markarth",                         -- Zone: The Reach            Location: Markarth              Bard: Tisnevere
  "Vivec City",                       -- Zone: Vvardenfell          Location: Vivec City            Bard: Mrylav Aralor & Altansawen
  "Skingrad"                          -- Zone: West Weald           Location: Skingrad              Bard: Ita Dannus
}

MBI.AccountDefaults = {
  currentZone = '',
  volume = 70,
  printLogs = true,
  mutedZones = {}
};

local isMuted = false
local next = next

local function getMutedZones(accountDefaults)
  return accountDefaults and accountDefaults.mutedZones;
end

local function setSfxVolume(volume)
  SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_SFX_VOLUME, volume);
end

local function OnAddOnLoaded(addOnName)
  if (addOnName ~= MBI.name) then
    MBI:Initialize()
  end
end

function MBI:Initialize()
  --create the default table
  --create the saved variable access object here and assign it to savedVars
  MBI.SavedVariables = ZO_SavedVars:NewAccountWide("MuteBardsImproved_Settings", MBI.version, nil, MBI.AccountDefaults, GetWorldName());
  MBI.AccountDefaults.currentZone = MBI.SavedVariables.currentZone
  MBI.AccountDefaults.volume = MBI.SavedVariables.volume
  MBI.AccountDefaults.printLogs = MBI.SavedVariables.printLogs

  if next(MBI.SavedVariables.mutedZones) == nil then
    MBI.SavedVariables.mutedZones = defaultZones
    MBI.AccountDefaults.mutedZones = defaultZones
  else
    for index, data in pairs(MBI.SavedVariables.mutedZones) do
      MBI.AccountDefaults.mutedZones[index] = data
    end
  end

  --Unregister Loaded Callback
  EVENT_MANAGER:UnregisterForEvent(MBI.name, EVENT_ADD_ON_LOADED);

  MBI:InitSettingsPanel(MBI.AccountDefaults);
  MBI:Refresh();
end

function MBI:TogglePrintLogs(value)
  MBI.AccountDefaults.printLogs = value
  MBI.SavedVariables.printLogs = MBI.AccountDefaults.printLogsrx
end

function MBI:ChangeVolume(value)
  MBI.AccountDefaults.volume = value
  MBI.SavedVariables.volume = MBI.AccountDefaults.volume
end

function MBI:AddZone(zoneName, cb)
  if (self:ContainsZone(zoneName)) then
    d(MBI.name .. '> Zone "' .. zoneName .. '" is already in the list.');
    return;
  end
    d(MBI.name .. '> Adding zone "' .. zoneName .. '" to the list.');
    table.insert(MBI.AccountDefaults.mutedZones, zoneName);
    MBI.SavedVariables.mutedZones = MBI.AccountDefaults.mutedZones

  if (cb ~= nil) then
    cb();
  end
end

function MBI:RemoveZone(zoneName, cb)
  if (self:ContainsZone(zoneName)) then
    for i, v in pairs(getMutedZones(MBI.AccountDefaults)) do
      if (v:lower() == zoneName:lower()) then
        table.remove(MBI.AccountDefaults.mutedZones, i)
        MBI.SavedVariables.mutedZones = MBI.AccountDefaults.mutedZones
        d(MBI.name .. '> Zone "' .. zoneName .. '" is removed from the list.');
        if (cb ~= nil) then
          cb();
        end
        return
      end
    end
  end
end

function MBI:ContainsZone(zoneName)
  if (getMutedZones(MBI.AccountDefaults) == nil) then    
    return false;
  end
  for i, v in ipairs(getMutedZones(MBI.AccountDefaults)) do
    if (v ~= nil and zoneName ~= nil) then -- protects against indexing nil on next line  
      if (v:lower() == zoneName:lower()) then
        return true;
      end
    end
  end
  return false;
end

function MBI:GetZoneName()
  local mapName = GetMapName()
	local playerActiveSubzoneName = ZO_CachedStrFormat(SI_ZONE_NAME, GetPlayerActiveSubzoneName())
	local zoneIndex = GetCurrentMapZoneIndex()
	local zoneName = zo_strformat(SI_UNIT_NAME, GetZoneNameByIndex(zoneIndex))

  --d('playerActiveSubzoneName: ' ..tostring(playerActiveSubzoneName))
  --d('zoneName: ' ..tostring(zoneName))
  --d('mapName: ' ..tostring(zo_strformat(SI_WINDOW_TITLE_WORLD_MAP, mapName)))

	if (playerActiveSubzoneName ~= nil and playerActiveSubzoneName ~= '') then
		currentZone = playerActiveSubzoneName
  elseif (mapName ~= nil and mapName ~= '') then
		currentZone = mapName
	else
		currentZone = zoneName
	end
end

function MBI:PrintLog(event, volume)
  if MBI.AccountDefaults.printLogs then
    if event == "zoneChange" then
      if volume == 0 then
        d(MBI.name .. '> There is a bard around, sound effects are muted.')
      else
        d(MBI.name .. '> No bard is around now, sound effects are unmuted.')
      end
    elseif event == "game" then
      if volume == 0 then
        d(MBI.name .. '> Game has ended, sound effects are muted.')
      else
        d(MBI.name .. '> Game has started, sound effects are unmuted.')
      end
    end
  end
end

function MBI.InCombatState(inCombat)
  if inCombat then
    setSfxVolume(MBI.AccountDefaults.volume);
  end
end

function MBI.OnAreaChange()
  MBI:GetZoneName()
  --d('currentZone ' .. currentZone);

  if (MBI.AccountDefaults ~= nil and MBI.SavedVariables ~= nil) then
    MBI.AccountDefaults.currentZone = currentZone;
    MBI.SavedVariables.currentZone = MBI.AccountDefaults.currentZone
    
    --d('currentZone: ' ..tostring(currentZone))
    --d('MBI.SavedVariables.currentZone: ' ..tostring(MBI.SavedVariables.currentZone))
    if (MBI:ContainsZone(currentZone)) then
      MBI:PrintLog("zoneChange", 0)
      setSfxVolume(0);
      isMuted = true
    elseif isMuted then
      MBI:PrintLog("zoneChange", MBI.AccountDefaults.volume)
      setSfxVolume(MBI.AccountDefaults.volume);
      isMuted = false
    end
  end
end

function MBI.OnGameStateChange(_, flowState)
  if (MBI:ContainsZone(currentZone)) then
    if(flowState == 0) then
      MBI:PrintLog("game", 0)
      setSfxVolume(0);
      isMuted = true
    else
      if(flowState == 1) then
        MBI:PrintLog("game", MBI.AccountDefaults.volume)
      end
      setSfxVolume(MBI.AccountDefaults.volume);
      isMuted = false
    end
  end
end

EVENT_MANAGER:RegisterForEvent(MBI.name..'InCombatState', EVENT_PLAYER_COMBAT_STATE, MBI.InCombatState)
EVENT_MANAGER:RegisterForEvent(MBI.name..'OnPlayerActivated', EVENT_PLAYER_ACTIVATED, MBI.OnAreaChange)
EVENT_MANAGER:RegisterForEvent(MBI.name..'OnZoneChange', EVENT_ZONE_CHANGED, MBI.OnAreaChange)
EVENT_MANAGER:RegisterForEvent(MBI.name..'OnGameStateChange', EVENT_TRIBUTE_GAME_FLOW_STATE_CHANGE, MBI.OnGameStateChange)

--Register Loaded Callback
EVENT_MANAGER:RegisterForEvent(MBI.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded);

function MBI:Refresh()
  MBI.OnAreaChange()
end