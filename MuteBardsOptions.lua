MBI = MBI or {};
local isInitialized = false;
local zoneToRemove
local dropdownOption

local function copyTable(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in pairs(orig) do
          copy[orig_key] = orig_value
      end
  else
      copy = orig
  end
  return copy
end

local function firstNonEmptyValue(zoneOptions)
  local tempTable = copyTable(zoneOptions)
  local keys = {}
  for k,_ in pairs(tempTable) do
      table.insert(keys, k)
  end
  table.sort(keys)
  return tempTable[keys[1]]
end

local function getCurrentZoneName(savedVariables)
  if (savedVariables ~= nil and savedVariables.currentZone ~= nil and savedVariables.currentZone ~= "") then
    return savedVariables.currentZone;
  end
  return "UNKNOWN"
end

local function generateDropdownOption(savedVariables)
  local currentZone = getCurrentZoneName(savedVariables)

  if MBI:ContainsZone(currentZone) then
    dropdownOption = currentZone
  else
    local zoneOptions =  copyTable(savedVariables.mutedZones)
    table.sort(zoneOptions)
    dropdownOption = firstNonEmptyValue(zoneOptions)
  end
  zoneToRemove = dropdownOption
  return dropdownOption
end

function MBI:InitSettingsPanel(savedVariables)
  local function refreshCallback()
    self:Refresh();
  end
  
  local panelName = "Mute Bards Improved"

  local panelData = {
    type = "panel",
    name = panelName,
    displayName = panelName,
    author = "@psi-pisi",
    version = self.version,
    website = "https://www.esoui.com/downloads/info4016-MuteBardsImproved.html",
    feedback = "https://www.esoui.com/downloads/info4016-MuteBardsImproved.html#comments",
    slashCommand = "/mbi",
    registerForRefresh = true,
    registerForDefaults = false
  }

  local optionsTable = {
    {
      type = "header",
      name = "Zone Settings",
      width = "full"
    },
    {
      type = "divider",
      width = "full",
      height = 10,
      alpha = 0.25
    },
    {
      type = "description",
      title = "Current Zone:",
      text = function() return "  " .. getCurrentZoneName(savedVariables) end,
      width = "full"
    },
    {
      type = "button",
      name = "Add Current Zone",
      disabled = function()  return getCurrentZoneName(savedVariables) == "UNKNOWN" end,
      func = function()
        if (getCurrentZoneName(savedVariables) ~= "UNKNOWN") then
          self:AddZone(getCurrentZoneName(savedVariables), refreshCallback);
          mutedZonesDropdown:UpdateChoices(savedVariables.mutedZones)
          ReloadUI("ingame")
        end
      end,
      width = "full",
      warning = "This will reload the UI for changes to be applied."
    },
    {
      type = "divider",
      width = "full",
      height = 10,
      alpha = 0.25
    },
		{
			type = "dropdown",
			name = "Muted Zones",
			choices = savedVariables.mutedZones,
      sort = "name-up",
      default = dropdownOption,
			getFunc = function() return generateDropdownOption(savedVariables) end,
			setFunc = function(value) zoneToRemove = value end,
      reference = "mutedZonesDropdown",
		},
    {
      type = "button",
      name = "Remove Zone",
      func = function()
        self:RemoveZone(zoneToRemove, refreshCallback);
        mutedZonesDropdown:UpdateChoices(savedVariables.mutedZones)
        ReloadUI("ingame")
      end,
      width = "full",
      warning = "This will reload the UI for changes to be applied."
    },
    {
      type = "header",
      name = "Sound Settings",
      width = "full"
    },
    {
      type = "divider",
      width = "full",
      height = 10,
      alpha = 0.25
    },
    {
      type = "description",
      text = "Default sound effects volume when you are not around Bards.",
      width = "full"
    },
    {
			type = "slider",
			name = "Volume",
			min = 1,
			max = 100,
			step = 1,
			getFunc = function() return savedVariables.volume end,
			setFunc = function(value) MBI:ChangeVolume(value) end,
		},
    {
      type = "header",
      name = "Log Settings",
      width = "full"
    },
    {
      type = "divider",
      width = "full",
      height = 10,
      alpha = 0.25
    },
    {
      type = "description",
      text = "Since zones keep changing while you are moving around, it may cause too many logs getting printed in the chat.",
      width = "full"
    },
    {
      type = "description",
      text = "You can disable printing logs when sound effects are muted or unmuted.",
      width = "full"
    },
    {
      type = "checkbox",
      name = "Print mute/unmute logs",
      getFunc = function() return savedVariables.printLogs end,
      setFunc = function(value) MBI:TogglePrintLogs(value) end,
      width = "full"
  }
  }

  local LAM = LibAddonMenu2

  if (not isInitialized) then
    LAM:RegisterAddonPanel(panelName, panelData);
  end

  LAM:RegisterOptionControls(panelName, optionsTable);

  isInitialized = true;
end