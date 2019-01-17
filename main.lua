display.setStatusBar( display.HiddenStatusBar )

local a = {{0,0,0}, {0,0,0}, {0,0,0}}

local mapSize = 3
local line1 =display.newLine( display.contentWidth/mapSize, 0, display.contentWidth/mapSize, display.contentHeight )
line1.strokeWidth = 5
local line1 = display.newLine( 2*display.contentWidth/mapSize, 0, 2*display.contentWidth/mapSize, display.contentHeight )
line1.strokeWidth = 5
local line1 = display.newLine( 0, display.contentHeight/mapSize, display.contentWidth, display.contentHeight/mapSize )
line1.strokeWidth = 5
local line1 = display.newLine( 0, 2*display.contentHeight/mapSize, display.contentWidth, 2*display.contentHeight/mapSize )
line1.strokeWidth = 5

local currentStepSymbol = 'X' --первый ход крестиков
local myRectangle = {}
local cellMarker = {}
for i=1,3 do
  myRectangle[i] = {}
  cellMarker[i] = {}
  for j=1,3 do
    myRectangle[i][j] =
    display.newRect( (i-1)*display.contentWidth/6+i*display.contentWidth/6,
    (j-1)*display.contentHeight/6+j*display.contentHeight/6,
    1.2*display.contentWidth/6,
    1.2*display.contentHeight/6 )
    myRectangle[i][j]:setFillColor( 0)
    cellMarker[i][j] = i..j
    -- print(cellMarker[i][j])

    local function listener(event)
        for i=1,3 do
          for key, val in pairs( myRectangle[i] ) do
            if val == event.target and cellMarker[key][i] ~= "X" and cellMarker[key][i] ~= "O" then
              local tapSymbol = display.newText( currentStepSymbol, display.contentCenterX, display.contentHeight/2, native.systemFont, 100 )
              cellMarker[key][i] = tapSymbol.text
              -- print(key,i)
              tapSymbol.x, tapSymbol.y = event.x, event.y  --кординаты символа = координаты события
              if currentStepSymbol == 'X' then currentStepSymbol = "O"
              else currentStepSymbol ='X'
              end
              if(gameWinCheck(cellMarker)~=nil) then
                -- if gameWinCheck(cellMarker)~=nil then
                  local gameEndText = display.newText(cellMarker[key][i].."-s Wins", display.contentCenterX, display.contentHeight/2, native.systemFont, 50 )
                  drawWinLine(gameWinCheck(cellMarker))
                  gameEndText:setFillColor(1,0,0)
                -- end
                elseif (gameIsEnd(cellMarker)) then
                  print("game end")
                  local gameEndText = display.newText("Draw", display.contentCenterX, display.contentHeight/2, native.systemFont, 50 )
                  gameEndText:setFillColor(1,0,0)
                end
              
            end
          end
        end

    end

    myRectangle[i][j]:addEventListener("tap", listener)
  end
end

function drawWinLine(coords)
  x1 = coords[1]
  y1 = coords[2]
  x2 = coords[3]
  y2 = coords[4]

  CoordsY = {}
  CoordsX = {}
  math.randomseed( os.time() )
  local numOfLines = math.random(3, 7)
  local randomScale = 0.7
  for i=1,numOfLines,1  do
    CoordsY[#CoordsY+1] = (2*y1-1)*display.contentWidth/(2*mapSize) + randomScale*math.random(-display.contentHeight/6, display.contentHeight/6)
    CoordsX[#CoordsX+1] = (2*x1-1)*display.contentHeight/(2*mapSize) + randomScale*math.random(-display.contentWidth/6, display.contentWidth/6)
    CoordsY[#CoordsY+1] = (2*y2-1)*display.contentWidth/(2*mapSize) + randomScale*math.random(-display.contentHeight/6, display.contentHeight/6)
    CoordsX[#CoordsX+1] = (2*x2-1)*display.contentHeight/(2*mapSize) + randomScale*math.random(-display.contentWidth/6, display.contentWidth/6)
      end
  for i=1,numOfLines*2-1,1 do
    local line3 = display.newLine(CoordsY[i],CoordsX[i],CoordsY[i+1],CoordsX[i+1])
    line3.strokeWidth = math.random(1, 3)
  end
end 

function gameIsEnd (Map)
  for i=1,#Map do
    for j=1,#Map do
      if Map[i][j] == "O" or Map[i][j] == "X" then
      else return false
      end
    end
  end
  return true
end

function gameWinCheck(Map)
  local LineSolved = true
  local mapWinLineCoordsXY1XY2 = {}
  --check rows
  for i=1,#Map do
    LineSolved = true
    for j=2,#Map do
      if Map[i][1] ~= Map[i][j] then LineSolved = false break end
    end
    if LineSolved then
      mapWinLineCoordsXY1XY2[1] = i
      mapWinLineCoordsXY1XY2[2] = 1
      mapWinLineCoordsXY1XY2[3] = i
      mapWinLineCoordsXY1XY2[4] = #Map
      return mapWinLineCoordsXY1XY2
    end
  end
  --check cols
  for j=1,#Map do
    LineSolved = true
    for i=2,#Map do
      if Map[1][j] ~= Map[i][j] then LineSolved = false break end
    end
    if LineSolved then
      mapWinLineCoordsXY1XY2[1] = 1
      mapWinLineCoordsXY1XY2[2] = j
      mapWinLineCoordsXY1XY2[3] = #Map
      mapWinLineCoordsXY1XY2[4] = j
      return mapWinLineCoordsXY1XY2
     end
  end
  --check center diaganal
  LineSolved = true
  for i=2,#Map do
    if Map[1][1] ~= Map[i][i] then LineSolved = false break end
  end
  if LineSolved then
    mapWinLineCoordsXY1XY2[1] = 1
    mapWinLineCoordsXY1XY2[2] = 1
    mapWinLineCoordsXY1XY2[3] = #Map
    mapWinLineCoordsXY1XY2[4] = #Map
    return mapWinLineCoordsXY1XY2
  end

  LineSolved = true
  for i=2,#Map do
    -- print(i)
    if Map[#Map][1] ~= Map[#Map-i+1][i] then LineSolved = false  break end
  end
  if LineSolved then
    mapWinLineCoordsXY1XY2[1] = 1
    mapWinLineCoordsXY1XY2[2] = #Map
    mapWinLineCoordsXY1XY2[3] = #Map
    mapWinLineCoordsXY1XY2[4] = 1
    return mapWinLineCoordsXY1XY2
  end
end
