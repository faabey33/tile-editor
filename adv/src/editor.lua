editor = {}

editor.showGrid = false
editor.mx = 0
editor.my = 0

editor.selectedblock = ""

editor.blocks = {}

editor.blocksloaded = false

editor.buttons = {}

editor.mapConf = { true, true, true }
editor.saved = { true, true, true }

editor.buttontick = 0
editor.buttonint = 0.2

editor.barcolor = {{0,255,255,255}, {127,255,212,255}, {220,20,60,255}, {255,255,255,255}, {0,0,0,255}}
editor.barcolorselected = 1

editor.blockbarpage = 1

function editor:init()
    
    blockbary = 200
    
    for a = 1, 3 do
        local y1 = 60+35*(a-1)
        table.insert(editor.buttons, { x = 10, y = y1, w=120, h=30})
        table.insert(editor.buttons, { x = 140, y = y1, w=90, h=30})
    end
    editor.buttons[1]["text"] = "Save Layer 1"
    editor.buttons[2]["text"] = "Show/Hide"
    editor.buttons[3]["text"] = "Save Layer 2"
    editor.buttons[4]["text"] = "Show/Hide"
    editor.buttons[5]["text"] = "Save Layer 3"
    editor.buttons[6]["text"] = "Show/Hide"
    
    local bx = love.graphics.getWidth()-ts*2
    local by = love.graphics.getHeight()-blockbary
    
    table.insert(editor.buttons, { t = "clear", x = bx, y = by, w = 120, h = 60, img = love.graphics.newImage("assets/next_page.png")})
    table.insert(editor.buttons, { t = "clear", x = bx, y = by+ts*2, w = 120, h = 60, img = love.graphics.newImage("assets/previous_page.png")})
    table.insert(editor.buttons, { t = "clear", x = bx, y = by+ts*4, w = 120, h = 60, img = love.graphics.newImage("assets/change_background.png")})

    table.insert(editor.buttons, { ta = "left", x = 10, y = 180, w = 220, h = 300})
    editor.buttons[10]["action"] = function() end
    editor.buttons[10]["text"] = "Map Information\n\nWidth: "..mapwidth.."\nHeight: "..mapheight.."\nTotal Blocks: "..mapheight*mapwidth.."\n\n\nTileset Information\n\nTotal Tiles: "
    
    editor.buttons[7]["action"] = function()
        if editor.blockbarpage < 3 then
            editor.blockbarpage=editor.blockbarpage+1 
        end
    end
    editor.buttons[8]["action"] = function()
        if editor.blockbarpage > 1 then
            editor.blockbarpage=editor.blockbarpage-1 
        end
    end
    --button change background color
    editor.buttons[9]["action"] = function()
        if editor.barcolorselected < #editor.barcolor then
            editor.barcolorselected = editor.barcolorselected + 1
        else
            editor.barcolorselected = 1
        end
    end
    
    editor.editingMap = "Map"..clayer
    
    local items_max = (math.floor(love.graphics.getWidth()/ts))-5
    
    for a = 1, items_max*6 do
        
        local r = getInvRow(a, items_max)
        
        editor.blocks[a] = {}
        editor.blocks[a][1] = atlas[a][1]
        editor.blocks[a][2] = (a-1-r*items_max)*(ts)
        editor.blocks[a][3] = love.graphics.getHeight()-blockbary+2+(r*ts)
    end
    for a = items_max*6+1, items_max*12 do
        --local r = getInvRow(a, items_max, 2)
        editor.blocks[a] = {}
        editor.blocks[a][1] = atlas[a][1]
        editor.blocks[a][2] = (a-items_max*6)*(ts) - (math.floor((a-items_max*6)/items_max)) * ts*items_max + 2--(a-1-(items_max*6)-r*items_max)*(ts+2)+2
        editor.blocks[a][3] = love.graphics.getHeight()-blockbary+2 + math.floor((a-items_max*6)/items_max)*ts -- + ((r-5)*ts)
    end
    for a = items_max*12, #atlas do
        --local r = getInvRow(a, items_max, 2)
        editor.blocks[a] = {}
        editor.blocks[a][1] = atlas[a][1]
        editor.blocks[a][2] = (a-items_max*12)*(ts) - (math.floor((a-items_max*12)/items_max)) * ts*items_max + 2--(a-1-(items_max*6)-r*items_max)*(ts+2)+2
        editor.blocks[a][3] = love.graphics.getHeight()-blockbary+2 + math.floor((a-items_max*12)/items_max)*ts -- + ((r-5)*ts)
    end
    
    editor.blocksloaded = true
    editor.buttons[10]["text"] = editor.buttons[10]["text"]..#block.."\nTilesize: "..ts.."\n\n\nHelp\n\nMove: WASD\nLMB: Select/Set Block\nRMB: Clear Selection\nMousewheel: Change Page"
end

function editor:update(dt)
    editor.editingMap = "Map"..clayer
    local items_max = (math.floor(love.graphics.getWidth()/ts))-5
    if editor.blocksloaded == true and love.mouse.isDown(1) and love.mouse.getY() > (love.graphics.getHeight()-blockbary) then
        if editor.blockbarpage == 1 then
            for a = 1, items_max*6 do
                local x, y = love.mouse.getPosition()
                if checkBoxCol(x, y, 1, 1, editor.blocks[a][2], editor.blocks[a][3], ts, ts) then
                    editor.selectedblock = editor.blocks[a][1]
                end
            end
        elseif editor.blockbarpage == 2 then
            for a = items_max*6+1, items_max*12 do
                local x, y = love.mouse.getPosition()
                if checkBoxCol(x, y, 1, 1, editor.blocks[a][2], editor.blocks[a][3], ts, ts) then
                    editor.selectedblock = editor.blocks[a][1]
                end
            end
        elseif editor.blockbarpage == 3 then
            for a = items_max*12+1, #editor.blocks do
                local x, y = love.mouse.getPosition()
                if checkBoxCol(x, y, 1, 1, editor.blocks[a][2], editor.blocks[a][3], ts, ts) then
                    editor.selectedblock = editor.blocks[a][1]
                end
            end
        end
    end
    if love.mouse.isDown(2) then
        editor.selectedblock = ""
    end
    if editor.selectedblock ~= "" and editor.blocksloaded == true and love.mouse.isDown(1) and love.mouse.getY() < (love.graphics.getHeight()-blockbary) then
        local rowIndex = (editor.my/32)*maps[editor.editingMap]["width"]
        local colIndex = ((editor.mx/32)+1)
        if rowIndex/30+1 <= mapheight and rowIndex/30+1 > 0 and colIndex <= mapwidth and colIndex > 0 then
            for a = 1, #atlas do
                if editor.selectedblock == atlas[a][1] then
                    print("set block "..atlas[a][1].." @ "..rowIndex+colIndex)
                    editor.saved[clayer] = false
                    maps[editor.editingMap][rowIndex+colIndex] = atlas[a][1]
                end
            end
        end
    end
    
    --nasty way for buttons
    local xx, yy = love.mouse.getPosition()
    if editor.buttontick < 5 then
        editor.buttontick = editor.buttontick + 1 * dt
    end
    
    if editor.buttontick > editor.buttonint then
        for a = 1, #editor.buttons do
            if checkBoxCol(xx, yy, 1, 1, editor.buttons[a]["x"], editor.buttons[a]["y"], editor.buttons[a]["w"], editor.buttons[a]["h"]) and love.mouse.isDown(1) then
                editor.buttontick = 0
                --print(a%2)
                if (a%2 ~= 0) and editor.buttons[a]["action"] == nil then
                    local k = 1
                    if a == 1 then
                    elseif a == 3 then
                        k = 2
                    elseif a == 5 then
                        k = 3 
                    end
                    love.system.setClipboardText(lume.serialize(maps["Map"..k]))
                    print("copied Map Layer "..k)
                    editor.saved[k] = true
                elseif editor.buttons[a]["action"] == nil then
                    local k = 1
                    if a == 2 then
                    elseif a == 4 then
                        k = 2
                    elseif a == 6 then
                        k = 3
                    end
                    --print("show/hide map layer "..k)
                    if editor.mapConf[k] == true then
                        editor.mapConf[k] = false
                    else
                        editor.mapConf[k] = true 
                    end
                elseif editor.buttons[a]["action"] ~= nil then
                     editor.buttons[a]["action"]()
                end
            end
        end
    end
    
    --update buttons texts
    for i = 2, 6, 2 do
        if editor.mapConf[i/2] == true then
            editor.buttons[i]["text"] = "Hide"
        elseif editor.mapConf[i/2] == false then
            editor.buttons[i]["text"] = "Show"
        end
    end
    
end

function editor:drawset()
    if editor.showGrid == true then
        for a = 0, mapwidth-1 do
            for i = 0, mapheight-1 do
                love.graphics.rectangle("line", ts*a, ts*i, ts, ts)  
            end
        end
        for u = 0, mapwidth-1 do
            love.graphics.printf(u+1, ts*u, -ts/2-16, ts, "center") 
        end
        for i = 0, mapheight-1 do
            love.graphics.printf(i+1, -ts, ts*i+16, ts, "left") 
        end
    end
    love.graphics.rectangle("line", editor.mx, editor.my, ts, ts)
    if editor.selectedblock ~= "" then
        --print(editor.selectedblock)
        love.graphics.draw(tilesheet, block[editor.selectedblock], editor.mx, editor.my, math.rad(0))
    end
    love.graphics.rectangle("line", 0, 0, ts*mapwidth, ts*mapheight)
end

function editor:drawunset()
    love.graphics.setColor(0,0,0,255)
    love.graphics.rectangle("fill", 0, 0, 240, 490)
    love.graphics.setColor(editor.barcolor[editor.barcolorselected])
    love.graphics.rectangle("fill", 0, love.graphics.getHeight()-blockbary, love.graphics.getWidth(), blockbary)
    love.graphics.setColor(255,255,255,255)
    
    editor.mx, editor.my = math.floor(((love.mouse.getX()+camera.x)*camera.scaleX)/ts)*ts, math.floor(((love.mouse.getY()+camera.y)*camera.scaleY)/ts)*ts
    
    local items_max = (math.floor(love.graphics.getWidth()/ts)-5)
    
    if editor.blockbarpage == 1 then
        for a = 1, items_max*6 do
            --local r = getInvRow(a, items_max)
            --love.graphics.draw(tilesheet, block[atlas[a][1]], (a-1-r*items_max)*(ts+2)+2, love.graphics.getHeight()-blockbary+2+(r*ts))
            love.graphics.draw(tilesheet, block[editor.blocks[a][1]], editor.blocks[a][2], editor.blocks[a][3])
        end
    elseif editor.blockbarpage == 2 then
        for  a = items_max*6+1, items_max*12 do
            love.graphics.draw(tilesheet, block[editor.blocks[a][1]], editor.blocks[a][2], editor.blocks[a][3])
        end
    elseif editor.blockbarpage == 3 then
        for  a = items_max*12+1, #editor.blocks do
            love.graphics.draw(tilesheet, block[editor.blocks[a][1]], editor.blocks[a][2], editor.blocks[a][3])
        end
    end
    
    
    for k = 1, #editor.buttons do
        love.graphics.setColor(255,255,255,255)
        if k == 1 and editor.saved[1] == false or k == 3 and editor.saved[2] == false or k == 5 and editor.saved[3] == false then
            love.graphics.setColor(255,100,100,255)
        end
        if k == 1 and clayer == 1 or k == 3 and clayer == 2 or k == 5 and clayer == 3 then
            love.graphics.setColor(0,255,0,255)
        end
        if (editor.buttons[k]["t"] == nil) then
            love.graphics.rectangle("line", editor.buttons[k]["x"], editor.buttons[k]["y"], editor.buttons[k]["w"], editor.buttons[k]["h"])
        end
        love.graphics.setColor(255,255,255,255)
        if editor.buttons[k]["text"] ~= nil then
            if editor.buttons[k]["ta"] == nil then
                love.graphics.printf(editor.buttons[k]["text"], editor.buttons[k]["x"], editor.buttons[k]["y"]+editor.buttons[k]["h"]/4, editor.buttons[k]["w"], "center") 
            else
                love.graphics.printf(editor.buttons[k]["text"], editor.buttons[k]["x"]+10, editor.buttons[k]["y"]+10, editor.buttons[k]["w"], "left") 
            end
        end
        if editor.buttons[k]["img"] ~= nil then
            love.graphics.draw(editor.buttons[k]["img"], editor.buttons[k]["x"], editor.buttons[k]["y"]) 
        end
    end
    
end

function checkBoxCol(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function getInvRow(a, items_max, page)
    local r = 0
        if page ~= 2 then
            if a > items_max then
                r = 1
            end
            if a > items_max*2 then
                r = 2
            end
            if a > items_max*3 then
                r = 3
            end
            if a > items_max*4 then
                r = 4
            end
            if a > items_max*5 then
                r = 5
            end
        else
            if a > items_max*6 then
                r = 1
            end
            if a > items_max*7 then
                r = 2
            end
            if a > items_max*8 then
                r = 3
            end
            if a > items_max*9 then
                r = 4
            end
            if a > items_max*10 then
                r = 5
            end 
        end
return r
end

function love.wheelmoved(x, y)
    if y > 0 then
        editor.buttons[8]["action"]()
    elseif y < 0 then
        editor.buttons[7]["action"]()
    end
end