DECK_ZONE_GUID = Global.getVar('DECK_ZONE_GUID')

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
    local handCount = Player[color].getHandObjects()
    local max = 5
    local needs = 0
    
    if #handCount < max then
        needs = max - #handCount
        deck.deal(needs, color)
    end
end