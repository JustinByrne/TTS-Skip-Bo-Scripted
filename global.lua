--[[ setting up global variables --]]
DISCARD_ZONE_GUID = "260d24"
DECK_ZONE_GUID = "47fbb9"
BUILD_PILE_GUIDS = {"eb5c7c", "20fb3c", "448502", "792127"}
PLAYER_STOCK_PILES = {}
PLAYER_STOCK_PILES.White = "b817db"
PLAYER_STOCK_PILES.Red = "f83774"
PLAYER_STOCK_PILES.Pink = "35eb63"
PLAYER_STOCK_PILES.Green = "4674eb"
PLAYER_STOCK_PILES.Blue = "d46711"
PLAYER_STOCK_PILES.Purple = "9dd608"
ALL_PLAYERS = {"White", "Red", "Pink", "Green", "Blue", "Purple"}

--[[ function variables --]]
setupInProgress = false
setupComplete = false

--[[ Default onLoad function --]]
function onLoad()
    deckZone = getObjectFromGUID(DECK_ZONE_GUID)
    discardZone = getObjectFromGUID(DISCARD_ZONE_GUID)
end

--[[ getting the deck GUID --]]
function getDeck()
    local zoneObjects = deckZone.getObjects()
    for _, item in ipairs(zoneObjects) do
        if item.tag == 'Deck' then
            return item
        end
    end
    for _, item in ipairs(zoneObjects) do
        if item.tag == 'Card' then
            return item
        end
    end
    return nil
end

function getDiscardDeck()
    local zoneObjects = discardZone.getObjects()
    for _, item in ipairs(zoneObjects) do
        if item.tag == 'Deck' then
            return item
        end
    end
    for _, item in ipairs(zoneObjects) do
        if item.tag == 'Card' then
            return item
        end
    end
    return nil
end

function getPileDeck(GUID)
    local pileZone = getObjectFromGUID(GUID)
    local zoneObjects = pileZone.getObjects()
    for _, item in ipairs(zoneObjects) do
        if item.tag == 'Deck' then
            return item
        end
    end
    for _, item in ipairs(zoneObjects) do
        if item.tag == 'Card' then
            return item
        end
    end
    return nil
end

--[[ Checking when a card enters a zone --]]
function onObjectEnterScriptingZone(zone, obj)
    if has_value(BUILD_PILE_GUIDS, zone.getGUID()) then
        Wait.time(function() movePile(zone.getGUID()) end, 0.5)
    end
end

function movePile(GUID)
    local deck = getPileDeck(GUID)
    if deck ~= nil then
        if deck.tag == 'Deck' and #deck.getObjects() == 12 then
            deck.setPosition(discardZone.getPosition())
        end
    end
end

--[[ Checking when a card leaves a zone --]]
function onObjectLeaveScriptingZone(zone, obj)
    --[[ Checking if main deck is empty --]]
    if zone.getGUID() == DECK_ZONE_GUID then
        if getDeck() == nil and getDiscardDeck() == nil then
            broadcastToAll('There are currently no cards in the discard pile, what have you done?', {r=1, g=1, b=1})
        elseif getDeck() == nil and getDiscardDeck() ~= nil then
            getDiscardDeck().flip()
            getDiscardDeck().setPosition(deckZone.getPosition())
            Wait.time(|| getDeck().randomize(), 0.5)
        end
    end
end

function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end