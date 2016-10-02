player = {}

player.x = 0
player.y = 0
player.rangeX = love.graphics.getWidth()/ts
player.rangeY = love.graphics.getHeight()/ts

function player:init()
    
end

function player:update(dt)
    player.x, player.y = camera.x, camera.y
end