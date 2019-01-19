local composer=require("composer")

local scene=composer.newScene()

local function gotoGame()
    composer.gotoScene("game",{time=800,effect="crossFade"})
end

function scene:create(event)
    
    local sceneGroup=self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    local playButton=display.newText(sceneGroup,"Play",display.contentCenterX,0,native.systemFont,44)
    playButton:setFillColor(0.82,0.86,0.5)
    
    playButton:addEventListener("tap",gotoGame)
end

function scene:show(event)
    local sceneGroup=self.view
    local phase=event.phase
    if (phase=="will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif (phase=="did") then
        -- composer.removeHidden()
    end
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
return scene
