display.setStatusBar(display.HiddenStatusBar)

_W=display.contentWidth;
_H=display.contentHeight;

gridStrokeWidth=3
gridStrokeColor={0.9,0.7,0.4,1}
local mapSize=5
local cellCenterX=_W/(mapSize*2)
local cellCenterY=_H/(mapSize*2)
local sizeXO = 1.2*cellCenterY

rectangleScale=1.2

for i=1,mapSize-1 do
    local line1=display.newLine(i*_W/mapSize,0,i*_W/mapSize,_H)
    line1:setStrokeColor(unpack(gridStrokeColor))
    line1.strokeWidth=gridStrokeWidth
    local line1=display.newLine(0,i*_H/mapSize,_W,i*_H/mapSize)
    line1:setStrokeColor(unpack(gridStrokeColor))
    line1.strokeWidth=gridStrokeWidth
end

local currentStepSymbol='X'
local myRectangle={}
local cellMarker={}
for i=1,mapSize do
    myRectangle[i]={}
    cellMarker[i]={}
    for j=1,mapSize do
        myRectangle[i][j]=
        display.newRect((i-1)*cellCenterX+i*cellCenterX,(j-1)*cellCenterY+j*cellCenterY,rectangleScale*cellCenterX,rectangleScale*cellCenterY)
        myRectangle[i][j]:setFillColor(0)
        cellMarker[i][j]=i..j
        
        local function listener(event)
            for i=1,mapSize do
                for key,val in pairs(myRectangle[i]) do
                    if val==event.target and cellMarker[key][i]~="X" and cellMarker[key][i]~="O" then
                        local tapSymbol=display.newText(currentStepSymbol,display.contentCenterX,_H/2,native.systemFont,sizeXO)
                        cellMarker[key][i]=tapSymbol.text
                        tapSymbol.x,tapSymbol.y=event.x,event.y --кординаты символа = координаты события
                        if currentStepSymbol=='X' then currentStepSymbol="O"
                        else currentStepSymbol='X'
                        end
                        if(gameWinCheck(cellMarker)~=nil) then
                            drawWinLine(gameWinCheck(cellMarker))
                            local gameEndText=display.newText(cellMarker[key][i].."-s Wins",display.contentCenterX,_H/2,native.systemFont,50)
                            gameEndText:setFillColor(1,0,0)
                        elseif (gameIsEnd(cellMarker)) then
                            local gameEndText=display.newText("Draw",display.contentCenterX,_H/2,native.systemFont,50)
                            gameEndText:setFillColor(1,0,0)
                        end
                    end
                end
            end
        end
        myRectangle[i][j]:addEventListener("tap",listener)
    end
end

function drawWinLine(coords)
    x1=coords[1]
    y1=coords[2]
    x2=coords[3]
    y2=coords[4]
    
    CoordsY={}
    CoordsX={}
    math.randomseed(os.time())
    local numOfLines=math.random(3,7)
    local randomScale=0.7
    for i=1,numOfLines,1 do
        CoordsY[#CoordsY+1]=(2*y1-1)*_W/(2*mapSize)+randomScale*math.random(-cellCenterY,cellCenterY)
        CoordsX[#CoordsX+1]=(2*x1-1)*_H/(2*mapSize)+randomScale*math.random(-cellCenterX,cellCenterX)
        CoordsY[#CoordsY+1]=(2*y2-1)*_W/(2*mapSize)+randomScale*math.random(-cellCenterY,cellCenterY)
        CoordsX[#CoordsX+1]=(2*x2-1)*_H/(2*mapSize)+randomScale*math.random(-cellCenterX,cellCenterX)
    end
    for i=1,numOfLines*2-1,1 do
        local line3=display.newLine(CoordsY[i],CoordsX[i],CoordsY[i+1],CoordsX[i+1])
        line3.strokeWidth=math.random(1,3)
        line3:setStrokeColor(0.5,0.8,0.5,1)
    end
end

function gameIsEnd (Map)
    for i=1,#Map do
        for j=1,#Map do
            if Map[i][j]=="O" or Map[i][j]=="X" then
            else return false
            end
        end
    end
    return true
end

function gameWinCheck(Map)
    local LineSolved=true
    local mapWinLineCoordsXY1XY2={}
    --check rows
    for i=1,#Map do
        LineSolved=true
        for j=2,#Map do
            if Map[i][1]~=Map[i][j] then LineSolved=false break end
        end
        if LineSolved then
            mapWinLineCoordsXY1XY2[1]=i
            mapWinLineCoordsXY1XY2[2]=1
            mapWinLineCoordsXY1XY2[3]=i
            mapWinLineCoordsXY1XY2[4]=#Map
            return mapWinLineCoordsXY1XY2
        end
    end
    --check cols
    for j=1,#Map do
        LineSolved=true
        for i=2,#Map do
            if Map[1][j]~=Map[i][j] then LineSolved=false break end
        end
        if LineSolved then
            mapWinLineCoordsXY1XY2[1]=1
            mapWinLineCoordsXY1XY2[2]=j
            mapWinLineCoordsXY1XY2[3]=#Map
            mapWinLineCoordsXY1XY2[4]=j
            return mapWinLineCoordsXY1XY2
        end
    end
    --check center diagonal (like slash symbol)
    LineSolved=true
    for i=2,#Map do
        if Map[1][1]~=Map[i][i] then LineSolved=false break end
    end
    if LineSolved then
        mapWinLineCoordsXY1XY2[1]=1
        mapWinLineCoordsXY1XY2[2]=1
        mapWinLineCoordsXY1XY2[3]=#Map
        mapWinLineCoordsXY1XY2[4]=#Map
        return mapWinLineCoordsXY1XY2
    end
    --check center diagonal (like back slash symbol)
    LineSolved=true
    for i=2,#Map do
        if Map[#Map][1]~=Map[#Map-i+1][i] then LineSolved=false break end
    end
    if LineSolved then
        mapWinLineCoordsXY1XY2[1]=1
        mapWinLineCoordsXY1XY2[2]=#Map
        mapWinLineCoordsXY1XY2[3]=#Map
        mapWinLineCoordsXY1XY2[4]=1
        return mapWinLineCoordsXY1XY2
    end
end
