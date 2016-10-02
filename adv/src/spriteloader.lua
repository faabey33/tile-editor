spriteloader = {}
block = {}

maps = {}

--tilesize
ts = 32--game.current["tilesize"]
scale = 1--game.current["scale"]

atlas = {
    --[[{ "black", 0, 0, "none"},
    { "red", ts, 0, "none" },
    { "floor-tiles-white", ts*2, 0, "none" },
    { "floor-tiles-red", ts*3, 0, "none" },
    { "floor-tiles-checker", ts*4, 0, "none" },
    { "floor-tiles-checker-yellow", ts*5, 0, "none" },
    { "floor-wood", ts*6, 0, "none" },
    { "floor-concrete", ts*7, 0, "none"},
    { "floor-concrete-left", ts*8, 0, "none"},
    { "floor-concrete-right", ts*9, 0, "none"},
    { "wall-bricks", ts*10, 0, "none"},
    { "floor-sidewalk-edge", ts*11, 0, "none"},
    { "floor-sidewalk-mid", ts*12, 0, "none"},
    { "floor-wood-bright-edge", ts*13, 0, "none"},
    { "floor-wood-bright", ts*14, 0, "none"},
    
    { "wall-red-single-top", 0, ts, "block-all"},
    { "wall-red-left-top", ts, ts, "block-all"},
    { "wall-red-right-top", ts*2, ts, "block-all"},
    { "wall-red-mid-top", ts*3, ts, "block-all"},
    { "wall-red-top-top-only-l", ts*4, ts, "block-all"},
    { "wall-red-top-top-only-rlb", ts*5, ts, "block-all"},
    { "wall-red-top-top-only-frb", ts*6, ts, "block-all"},
    { "wall-red-top-top-only-b", ts*7, ts, "block-all"},
    { "wall-red-top-top-only-rb", ts*8, ts, "block-all"},
    { "wall-red-top-top-only-lb", ts*9, ts, "block-all"},
    { "wall-red-top-top-only-lr", ts*10, ts, "block-all"},
    { "wall-stone-single-top", ts*11, ts, "block-all"},
    { "wall-metal-left", ts*12, ts, "block-all"},
    { "wall-metal-single", ts*13, ts, "block-all"},
    { "empty", ts*14, ts, "block-all"},
    
    { "wall-red-down-single", 0, ts*2, "block-all"},
    { "wall-red-down-left", ts, ts*2, "block-all"},
    { "wall-red-down-right", ts*2, ts*2, "block-all"},
    { "wall-red-down-mid", ts*3, ts*2, "block-all"},
    { "wall-red-top-top-only-r", ts*4, ts*2, "block-all"},
    { "wall-red-top-top-only-fbl", ts*5, ts*2, "block-all"},
    { "wall-red-top-top-only-lrf", ts*6, ts*2, "block-all"},
    { "wall-red-top-top-only-f", ts*7, ts*2, "block-all"},
    { "wall-red-top-top-only-fr", ts*8, ts*2, "block-all"},
    { "wall-red-top-top-only-fl", ts*9, ts*2, "block-all"},
    { "wall-red-top-top-only-fb", ts*10, ts*2, "block-all"},
    { "wall-stone-down-single", ts*11, ts*2, "block-all"},
    { "wall-metal-right", ts*12, ts*2, "block-all"},
    { "wall-metal-dunno", ts*13, ts*2, "block-all"},
    { "empty", ts*14, ts*2, "block-all"},
    
    { "fridge-top", 0, ts*3, "block-all"},
    { "stove-top", ts, ts*3, "block-all"},
    { "table-top-left", ts*2, ts*3, "block-all"},
    { "table-top-right", ts*3, ts*3, "block-all"},
    { "kitchen-sink-full", ts*4, ts*3, "block-all"},
    { "kitchen-sink-empty", ts*5, ts*3, "block-all"},
    { "kitchen-radio", ts*6, ts*3, "block-all"},
    { "bookshelf-filled-top-left", ts*7, ts*3, "block-all"},
    { "bookshelf-fille-top-right", ts*8, ts*3, "block-all"},
    { "bookshelf-empty-top-left", ts*9, ts*3, "block-all"},
    { "bookshelf-empty-top-right", ts*10, ts*3, "block-all"},
    { "table-tv-top", ts*11, ts*3, "block-all"},
    { "desk-left", ts*12, ts*3, "block-all"},
    { "bed-top-left", ts*13, ts*3, "block-all"},
    { "bed-top-right", ts*14, ts*3, "block-all"}]]
}

function spriteloader:init(anim8)
    tilesheet = love.graphics.newImage("assets/tilesheet.png")
    tilesheet:setFilter("linear", "nearest")
    
    local atlas_index = 1
    local height = math.floor(tilesheet:getHeight()/ts)-1
    local width = math.floor(tilesheet:getWidth()/ts)

    for l = 0, height do
        for f = 0, width do
            atlas[atlas_index] = { l*width+f, ts*f, ts*l, "none" }
            atlas_index = atlas_index + 1
        end
    end
    for a = 1, #atlas do
        block[atlas[a][1]] = love.graphics.newQuad(atlas[a][2], atlas[a][3], ts, ts, tilesheet:getDimensions())
    end
end

function spriteloader:generateMap(map, mapname)
    length = #map[1]
    maps[mapname] = {}
    maps[mapname]["width"] = length
    maps[mapname]["height"] = #map
    for i = 1, #map do
        for a = 1, length do
            id = map[i][a]
            local block_name = ""
            if id == "@" then
                --get spawn point out of pos of @ symbol
                maps[mapname]["spawn"] = { a, i }
                --set to air block
                maps[mapname][(i-1)*length+a] = "air"
            else
                block_name = atlas[id][1]
                maps[mapname][(i-1)*length+a] = block_name
            end
        end
    end
end

function spriteloader:drawMap(mapname)
    love.graphics.setColor(255,255,255,255)
    --love.graphics.draw(tilesheet, block["brown-plain"], x, y, 0, scale, scale)
    local width = maps[mapname]["width"]
    local height = maps[mapname]["height"]
    for i = 1, height do
        for a = 1, width do
            local x = math.floor((a-1)*ts*scale)
            local y = math.floor((i-1)*ts*scale)+1 --dont even ask why there is a +1
            --if x < player.x + player.rangeX*ts*scale and x > player.x - player.rangeX*ts*scale and y > player.y - player.rangeY*ts*scale and y < --player.y + player.rangeY*ts*scale then
                love.graphics.draw(tilesheet, block[maps[mapname][(i-1)*width+a]], x, y, 0, scale, scale)
            --end
        end
    end
end