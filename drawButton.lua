DECK_ZONE_GUID = Global.getVar('DECK_ZONE_GUID')
DISCARD_ZONE_GUID = Global.getVar('DISCARD_ZONE_GUID')
MAX = 5

function onLoad()
    --[[ Create button --]]
    drawButton = {
        click_function = "drawFunc",
        function_owner = self,
        label          = "Draw",
        position       = {0, 1, 0},
        rotation       = {0, 0, 0},
        width          = 2900,
        height         = 850,
        font_size      = 340,
        color          = {1, 1, 1},
        font_color     = {0, 0, 0},
        tooltip        = "Draw Cards",
    }
    self.createButton(drawButton)
end

function drawFunc(obj, color, alt_click)
    local deck = Global.call('getDeck', DECK_ZONE_GUID)
    local discardDeck = Global.call('getDeck', DISCARD_ZONE_GUID)
    local handCount = #Player[color].getHandObjects()
    local needs = MAX - handCount

    if needs > 0 then
        if deck ~= nil and deck.tag == "Deck" then
            if #deck.getObjects() > needs then
                deck.deal(needs, color)
            else
                Global.call('moveDiscard')
                Wait.time(|| deck.deal(needs, color), 1)
            end
        else
            Global.call('moveDiscard')
            Wait.time(|| deck.deal(needs, color), 1)
        end
    end
end