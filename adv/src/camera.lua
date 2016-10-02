camera = {}
camera.x = -300
camera.y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0
camera.speed = 300

function camera:set()
love.graphics.push()
love.graphics.rotate(-self.rotation)
love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
love.graphics.pop()
end

function camera:move(dx, dy)
self.x = self.x + (dx or 0)
self.y = self.y + (dy or 0)
end

function camera:rotate(dr)
self.rotation = self.rotation + dr
end

function camera:scale(sx, sy)
sx = sx or 1
self.scaleX = self.scaleX * sx
self.scaleY = self.scaleY * (sy or sx)
end

function camera:setPosition(x, y)
self.x = x or self.x
self.y = y or self.y
end

function camera:setScale(sx, sy)
self.scaleX = sx or self.scaleX
self.scaleY = sy or self.scaleY
end

function camera:update(dt)
    if love.keyboard.isDown("w") then
        camera.y = camera.y - camera.speed * dt
    elseif love.keyboard.isDown("s") and love.keyboard.isDown("lctrl") == false then
        camera.y = camera.y + camera.speed * dt
    end
    if love.keyboard.isDown("a") then
        camera.x = camera.x - camera.speed * dt
    elseif love.keyboard.isDown("d") then
        camera.x = camera.x + camera.speed * dt
    end
end
--[[
function love.wheelmoved(x, y)
    if y > 0 then
        camera.scaleY = camera.scaleY - 0.1
        camera.scaleX = camera.scaleX - 0.1
    elseif y < 0 then
        camera.scaleY = camera.scaleY + 0.1
        camera.scaleX = camera.scaleX + 0.1
    end
end]]--