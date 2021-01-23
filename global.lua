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

--[[ Default onLoad function --]]
function onLoad()
    deckZone = getObjectFromGUID(DECK_ZONE_GUID)
    discardZone = getObjectFromGUID(DISCARD_ZONE_GUID)
end

--[[ getting the deck GUID --]]
function getDeck(GUID)
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
        obj.setRotation(180)
        Wait.time(function() movePile(zone.getGUID()) end, 0.75)
    end
end

function movePile(GUID)
    local deck = getDeck(GUID)
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
        if getDeck(DECK_ZONE_GUID) == nil and getDeck(DISCARD_ZONE_GUID) == nil then
            broadcastToAll('There are currently no cards in the discard pile, what have you done?', {r=1, g=1, b=1})
        elseif getDeck(DECK_ZONE_GUID) == nil and getDeck(DISCARD_ZONE_GUID) ~= nil then
            moveDiscard()
        end
    end
end

function moveDiscard()
    local deckZone = getObjectFromGUID(DECK_ZONE_GUID)
    getDeck(DISCARD_ZONE_GUID).flip()
    getDeck(DISCARD_ZONE_GUID).setPosition(deckZone.getPosition())
    Wait.time(|| getDeck(DECK_ZONE_GUID).randomize(), 0.75)
end

function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end