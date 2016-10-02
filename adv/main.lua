require "src/spriteloader"
require "src/player"
require "src/camera"

require "assets/maps/map-1"

require "src/editor"
lume = require "src/lume"

mapwidth = 20
mapheight = 14

clayer = 1

function love.load()
    player:init()
    spriteloader:init()
    editor:init()
    
    local mapdefault = {}
    for a = 1, mapheight do
        mapdefault[a] = {}
        for i = 1, mapwidth do
            mapdefault[a][i] = 1
        end
    end
    
    spriteloader:generateMap(mapdefault, "Map1")
    spriteloader:generateMap(mapdefault, "Map2")
    spriteloader:generateMap(mapdefault, "Map3")
    
end

function love.update(dt)
    player:update()
    camera:update(dt)
    editor:update(dt)
end

function love.draw()
    camera:set()
        if editor.mapConf[1] == true then
            spriteloader:drawMap("Map1")
        end
        if editor.mapConf[2] == true then
            spriteloader:drawMap("Map2")
        end
        if editor.mapConf[3] == true then
            spriteloader:drawMap("Map3")
        end
        editor:drawset()
    camera:unset()
    editor:drawunset()
    love.graphics.print("FPS: "..love.timer.getFPS(), 10, 30)
    love.graphics.print("Drawing on Layer: "..clayer, 10, 10)
end

function love.keypressed(k)
    if k == "o" and editor.showGrid == false then
        editor.showGrid = true 
    elseif k == "o" and editor.showGrid == true then
        editor.showGrid = false 
    end
    if k == "kp1" then
        clayer = 1 
    elseif k == "kp2" then
        clayer = 2
    elseif k == "kp3" then
        clayer = 3
    end
end


function print_r ( t ) 
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    sub_print_r(t,"  ")
end