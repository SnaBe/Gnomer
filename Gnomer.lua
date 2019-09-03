-- Array of Gnome jokes
GnomeDB = {}
-- Default channel for chat messages
local defaultChannel = 'SAY'
-- Our previous number
local previousGnome = 0
-- Table of event handlers (functions)
local eventHandlers = {}
-- Function for handling when our addon loads
function eventHandlers.ADDON_LOADED(name)
    -- Only interested in our own addon 
    if name ~= 'Gnomer' then return end
    -- Get the player character's race
    local race = UnitRace('player')
    -- Only enable the addon for Gnomes
    if race ~= 'Gnome' then return end
    -- Print a message to the player
    Print('Loaded & enabled.')
    -- Register our slash commands
    RegisterSlashCommands()
end
-- Function for registering slash commands
function RegisterSlashCommands()
    -- Slash commands for gnome stuff
    SLASH_GNOME1 = '/gnome'
    -- Built in slash commander handler
    SlashCmdList.GNOME = function(msg)
        -- Split the command and arhuments from the message
        local cmd, arg = string.split(' ', msg)
        -- The specific command to lovercase, the command should not be case-sensitive 
        cmd = cmd:lower()
        -- Check for the commands
        if cmd == 'add' and arg then
            -- Call our addGnomer() function
            addGnomer(msg:match('^add%s+(.+)'))
        elseif cmd == 'random' then
            -- Call our getGnomed() function 
            getGnomed()
        elseif cmd == 'help' then
            -- The user needs help, show the a list of commands
            help()
        else
            -- Unknown command, show the user a list of commands
            help()
        end
    end
end
-- Function for getting a random gnome joke
function getRandomGnomer(db)
    -- Return a random number
    return math.random(table.getn(db))
end
-- Function chosing a random gnome joke
function getGnomed()
    -- Amount of Gnome jokes provied so far
    local jokes = table.getn(GnomeDB)
    -- Check if there's enough Gnome related jokes before continuing
    if jokes < 2 then
        -- Print a message to the player
        return Print('Please add at least ' .. 2 - jokes .. ' joke(s) to the Gnomer list.')
    end
    -- Generate a random number
    randomGnome = getRandomGnomer(GnomeDB)
    -- Keep going until we get a unique number
    while randomGnome == previousGnome do
        -- Generate a new random number
        randomGnome = getRandomGnomer(GnomeDB)
    end
    -- Our previous number gets updated
    previousGnome = randomGnome
    -- Send a chat message with the chosen Gnome joke
    print(GnomeDB[randomGnome])
    -- SendChatMessage(GnomeDB[randomGnome], defaultChannel, 'COMMON', 1)
end
-- Function to add a new Gnome joke
function addGnomer(str)
    -- Insert the string into the array
    table.insert(GnomeDB, str)
    -- Tell the user what they added to the Gnomer list
    Print('You added "' .. str .. '" to the Gnomer list!')
end
-- Custom print function
function Print(...)
    -- Print message prefix
    local prefix = '|cffFFD700Gnomer:|r'
    -- Add the message to the default chat frame (General)
    DEFAULT_CHAT_FRAME:AddMessage(string.join(' ', prefix, ...));
end
-- Help function to print the commands list
function help()
    -- Whitespace
    print(' ')
    -- Custom print
    Print('Here\'s a list commands:')
    Print('|cff00cc66/gnome add <string>|r - Add a joke to the Gnomer list.')
    Print('|cff00cc66/gnome random|r - Say a random Gnome related joke out.')
    Print('|cff00cc66/gnome help|r - Shows the command list.')
    -- Whitespace
    print(' ')   
end
-- Our event handler function
local function eventHandler(self, event, ...)
    return eventHandlers[event](...)
end
-- New event frame object
local eventFrame = CreateFrame('Frame')
-- Register the events to handle
eventFrame:RegisterEvent('ADDON_LOADED')
-- Register a script handler that will be called when OnEvent is called
eventFrame:SetScript('OnEvent', eventHandler)

