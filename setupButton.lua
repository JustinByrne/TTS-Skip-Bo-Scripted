ALL_PLAYERS = Global.getTable('ALL_PLAYERS')
DECK_ZONE_GUID = Global.getVar('DECK_ZONE_GUID')
PLAYER_STOCK_PILES = Global.getTable('PLAYER_STOCK_PILES')
setupInProgress = false
setupComplete = false

function onLoad()
    setupButton = {
        click_function = "setupFunc",
        function_owner = self,
        label          = "Setup Game",
        position       = {0, 1, 0},
        rotation       = {0, 180, 0},
        width          = 2900,
        height         = 850,
        font_size      = 340,
        color          = {1, 1, 1},
        font_color     = {0, 0, 0},
        tooltip        = "Setup the Game",
    }
    self.createButton(setupButton)
end

function setupFunc()
    if not setupComplete and not setupInProgress then
        setupInProgress = true
        startLuaCoroutine(self, 'setupCoroutine')
        setupComplete = true
        Wait.time(|| broadcastToAll("Youngest Player goes first", {r=1, b=1, g=1}), 2)
    elseif setupComplete then
        broadcastToAll("Setup has already been run, please reset the game if you wish to play again", {r=1, g=0, b=0})
    elseif setupInProgress then
        broadcastToAll("Setup is currently running, please wait", {r=1, g=0, b=0})
    end
end

function setupCoroutine()
    local deck = Global.call('getDeck', DECK_ZONE_GUID)
    deck.randomize()

    playerList = Player.getPlayers()
    local sortedSeatedPlayers = {}
    local playerOrder = ALL_PLAYERS
    local stockPile = 0

    if #playerList >= 1 and #playerList <=4 then
        stockPile = 29
    elseif #playerList >=5 and #playerList <=6 then
        stockPile = 19
    end

    if stockPile > 0 then
        for _, color in ipairs(playerOrder) do
            if Player[color].seated then
                table.insert(sortedSeatedPlayers, color)
            end
        end

        for i, color in ipairs(sortedSeatedPlayers) do
            local target = nil

            target = getObjectFromGUID(PLAYER_STOCK_PILES[color])
            
            --[[ dealing the stock pile --]]
            for i=1,stockPile do
                if color == "Pink" then
                    deck.takeObject({position=target.getPosition(), rotation={x=0, y=270, z=180}})
                elseif color == "Purple" then
                    deck.takeObject({position=target.getPosition(), rotation={x=0, y=90, z=180}})
                elseif color == "White" or color == "Red" then
                    deck.takeObject({position=target.getPosition(), rotation={x=0, y=180, z=180}})
                else
                    deck.takeObject({position=target.getPosition(), rotation={x=0, y=0, z=180}})
                end
            end

            if color == "Pink" then
                Wait.time(|| deck.takeObject({position=target.getPosition(), rotation={x=0, y=270, z=0}}), 1)
            elseif color == "Purple" then
                Wait.time(|| deck.takeObject({position=target.getPosition(), rotation={x=0, y=90, z=0}}), 1)
            elseif color == "White" or color == "Red" then
                Wait.time(|| deck.takeObject({position=target.getPosition(), rotation={x=0, y=180, z=0}}), 1)
            else
                Wait.time(|| deck.takeObject({position=target.getPosition(), rotation={x=0, y=0, z=0}}), 1)
            end

            coroutine.yield(0)
        end
        
        deck.deal(5)
    end
    
    setupInProgress = false
    return 1
end