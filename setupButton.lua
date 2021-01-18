ALL_PLAYERS = Global.getTable('ALL_PLAYERS')
DECK_ZONE_GUID = Global.getVar('DECK_ZONE_GUID')
PLAYER_STOCK_PILES = Global.getTable('PLAYER_STOCK_PILES')
setupInProgress = false
setupComplete = false

function onLoad()
    --[[ Create button --]]
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
    if not setupComplete then
        setupInProgress = true
        startLuaCoroutine(self, 'setupCoroutine')
        setupComplete = true
        Wait.time(|| broadcastToAll("Youngest Player goes first", {r=1, b=1, g=1}), 2)
    else
            local msg = "Setup has already been run, please reset the game if you wish to play again"
            local rgb = {r=1, b=1, g=1}
            broadcastToAll(msg, rgb);
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
                deck.takeObject({flip=false, position=target.getPosition()})
            end

            Wait.time(|| deck.takeObject({flip=true, position=target.getPosition()}), 0.5)

            coroutine.yield(0)
        end
        
        deck.deal(5)
    end
    
    setupInProgress = false
    return 1
end