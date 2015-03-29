module("movement", package.seeall)
require "inputmod"
require "battle"

function constants()
  OA_MAX_MOVES = 10
  end
function resetcords() -- resets coords to current coords
    x = memory.readbyte(0xD362) 
    y = memory.readbyte(0xD361)
  end
function flip(toflipme)
  --returns the opposit of a given direction
  if toflipme == "up" then
    return "down"
  elseif toflipme == "down" then
    return "up"
  elseif toflipme == "left" then
    return "right"
  else
    return "left"
  end
  end
function skipframes(frames)
  --pauses the program for frames frames
j = vba.framecount();
i = 0;
while i<frames do
  i = vba.framecount()-j;
  vba.frameadvance();
end
  end

function directionfacing() 
-- returns the direction you're facing
if memory.readbyte(0xD52A) == 8 then 
return "up"
elseif memory.readbyte(0xD52A) == 1 then 
return "right"
elseif memory.readbyte(0xD52A) == 4 then
return "down"
elseif memory.readbyte(0xD52A) == 2 then
return "left"
end
end

function tonum(adirection)
--converts a direction to a number
if adirection == "left" then
return 1
elseif adirection == "right" then
  return 2
elseif adirection == "up" then
  return 3
elseif adirection == "down" then
  return 4
  end
end
function menuopen()
--returns a boolean representative of whether a 
--menu is open
  if memory.readbyte(0xCFC4) == 1 then
    return true
  else return false
end
end

function initialize()
  --initializes a bunch of constants
  path = {}
  finishedbattle = false
  savex = 0
  area = memory.readbyte(0xD35E)
  savey = 0
  goalcords = {-2,-2}
  currlocation()
  avoid = false
  free = true
  inputs = {"left", "right", "up", "down", "A", "B", "start"}
  moves_matrix = {}
  for i=-1,80 do
    moves_matrix[i] = {}   
    for j=-1,80 do
      moves_matrix[i][j] = 0
    end
  end
  x = memory.readbyte(0xD362) 
  y = memory.readbyte(0xD361)
  resetcords()
end
function resetarea()
  --reset area
area = currlocation()
end
function currlocation() 
  --return current location from memory
    return memory.readbyte(0xD35E) 
end
function walkto(xcord, ycord, paradigm) 
  --walk to a given xcord and ycord using a movement paradigm
  while not (x == xcord and y == ycord) and not changedareas() do
    print(x, y)
    if paradigm == "RHR" then RHR() else
    local booleans = { x > xcord, x < xcord, y > ycord, y < ycord}
    if booleans[tonum(directionfacing())] then
      go(directionfacing())
    else
      for i=1, 4 ,1 do
        if booleans[i] then
          go(inputs[i])
          break
          end
        end
      end
    if collided then
    print("avoid")
    objectavoid(directionfacing())
  end
  end
end
if changedareas() then
skipframes(100) end
vba.frameadvance()
end
function resetmatrix()
  for i=-1,80 do 
    for j=-1,80 do
      moves_matrix[i][j] = 0
    end
  end
  end
function moveto (anarea, ax, ay)
  while not (anarea == area and ax == x and ay == y) do playto(anarea,ax,ay) 
end
end
function playto(anarea, ax, ay)
  resetarea()
  path = {} 
  if area == anarea then
      resetarea()
        for k,l in pairs(GUIDETABLE) do
        if l[1] == anarea then v = l[4] end
        walkto(ax,ay, v)
        end
        if x == xcord and y == ycord or changedareas() then 
        print("stop") 
        return "stop" 
        end
  else
    for k,l in pairs(GUIDETABLE) do
      if l[1] == area then u = l[2] v = l[3] h = l[4] end
    end
      list = findpath(area,anarea,path)
      for o,p in pairs(u) do  
        if p == list[2] then 
          print(v[o][1], v[o][2], h)
        walkto(v[o][1], v[o][2], h) 
        return 
        end 
    end
    end
end
function findpath(begin, ennd, path)
  --node path algorithm
  table.insert(path, begin)
  print(path)
  if begin == ennd then
  return path
  end
  for i,j in pairs(GUIDETABLE) do
    if begin == j[1] then
      for i=1,table.getn(j[2]),1 do
        if table.contains(path, j[2][i]) == false then
          newpath = findpath(j[2][i], ennd, path)
          if newpath ~= nil then return newpath end
        end
      end
      end
    end
  table.remove(path)
  return nil
end


function objectavoid(adirection)
  local startx = x
  local starty = y
  print(y, starty)
  local booleans = {x >= startx, x <= startx, y >= starty, y <= starty}
  print(booleans)
  local n = 1
  if math.random(2) == 1 then flipper = false else flipper = true end
  while booleans[tonum(adirection)] do --loop while we haven't progressed
      if flipper then 
        for i=1,n do
          if changedareas() then break end
          go(inputmod.rightof(adirection))
          if collided then n = n - 1 break end
        end
      else
        for i=1,n do
          if changedareas() then break end
          go(inputmod.leftof(adirection))
          if collided then n = n - 1 break end
        end
      end
      go(adirection)
      if changedareas() then break end
      flipper = not flipper
      n = n + 1
      booleans = {x >= startx, x <= startx, y >= starty, y <= starty}
  end
end
function smartmove()
  local MINPERCENT = 5
  resetcords()
  if changedareas() then 
    go(directionfacing()) go(directionfacing()) go(directionfacing()) 
    resetmatrix()
  end
  local zerotable = {0,0,0,0}
  input_percent = math.random(100)
  local booltable = {moves_matrix[x-1][y],  moves_matrix[x+1][y], moves_matrix[x][y-1], moves_matrix[x][y+1]}
  local z = {}
  pickmove = {}
  if collided then 
    if directionfacing() == "up" then
      moves_matrix[x][y-1] = moves_matrix[x][y-1] + 5
    elseif directionfacing() == "down" then
      moves_matrix[x][y+1] = moves_matrix[x][y+1] + 5
    elseif directionfacing() == "left" then
      moves_matrix[x-1][y] = moves_matrix[x-1][y] + 5
    else
      moves_matrix[x+1][y] = moves_matrix[x+1][y] + 5
    end
    end
  for i=1,4,1 do
    if booltable[i] == 0 then
      table.insert(z, inputs[i])
  end
end
    if (table.getn(z) > 0) and input_percent >= 3 then
    print("newspace")
    go(z[math.random(table.getn(z))])
    return
    end
  for i=-1, 80 do --create weight matrix
    for j=-1, 80 do
      square = moves_matrix[i][j]
      d = math.sqrt((i-x)^2 + (j-y)^2)
      if (i-x) > 0 then
        zerotable[1] = zerotable[1] + (square / d)
      elseif (i-x) < 0 then
        zerotable[2] = zerotable[2] + (square / d )
      end
      if (j-y) > 0 then
        zerotable[3] = zerotable[3] + (square / d)
      elseif (j-y) < 0 then
        zerotable[4] = zerotable[4] + (square / d)
      end
    end
  end
  sum = zerotable[1] + zerotable[2] + zerotable[3] + zerotable[4]
  if sum ~= 0 then
  for i=1, 4, 1 do
    zerotable[i] = MINPERCENT + zerotable[i]*((100-MINPERCENT*4)/sum)
  end
  else 
    zerotable = {25, 25, 25, 25}
  end
  input_percent = math.random(99)
  for a = 1 , 5, 1 do
    input_percent = input_percent - zerotable[a]
    if input_percent <= 0 then go(inputs[a])
return
end
end
end
function RHR()
  resetcords()
  go("up")
  go("up")
  go("up")
  go("right")
  go("right")
  go("right")
  go("right")
    local n = 0
  local m = 0
  while not (x == xcord and y == ycord) and not changedareas() do
  if free and m < 4 then
    n = 0
    m=m+1
    go(inputmod.rightof(directionfacing()))
    if collided then
    free = false
    end
  elseif n < 4 then
    m = 0
    n=n+1
    go(inputmod.leftof(directionfacing()))
    if not collided then
      free = true
    end
  else
    go(directionfacing())
    go(directionfacing())
    n = 0
  end
  end
end
function changedareas()
  if area == currlocation() then
    return false
  else 
    return true 
  end
end
function go(direction, num) -- go in a given direct ion
  local n
  if num ~= nil then n = num else n = 1 end
  repeat
  resetcords()
  if battle.battling() then -- checks if ur battling
    if directionfacing() ~= direction then key = true end
    battle.battler()
    resetcords()
    if key then   inputmod.button(direction)
  inputmod.button(direction)
  inputmod.button(direction)
  inputmod.button(direction)
  skipframes(14) end
  collided = not hasmoved()
  resetcords() return
  elseif menuopen() then --checks if menu is open
    menupress()
  elseif findweakest() ~= 1 then
    inputmod.switchtofirst(findweakest())
  end
  inputmod.button(direction)
  inputmod.button(direction)
  inputmod.button(direction)
  inputmod.button(direction)
  skipframes(14)
  if not hasmoved() then
    inputmod.button("A")
    inputmod.button("A")
    inputmod.button("A")
    inputmod.button("A")
  end
collided = false
  moves_matrix[x][y] = moves_matrix[x][y] + 1
  collided = not hasmoved()
resetcords()
  n = n-1
  until n == 0
  end
function start() -- navigates the start menu
  print("start menu")
  named = false
  while memory.readbyte(0xCFCB) ~= 1 do
    if memory.readbyte(0x8800) == 0 then
      inputmod.button("A")
      skipframes(200)
      inputmod.button("down")
      skipframes(15)
    elseif memory.readbyte(0xCC30) == 5  then --write "barry"
      if named == false then
      named = true
      inputmod.button("down", 5, 5)
      inputmod.button("A", 5)
      inputmod.button("up", 5, 5)
      inputmod.button("right", 5)
      inputmod.button("A", 5)
      inputmod.button("left", 5)
      inputmod.button("A", 5)
      inputmod.button("left", 5)
      inputmod.button("down", 5)
      inputmod.button("A", 5)
      inputmod.button("A", 5)
      inputmod.button("down", 5)
      inputmod.button("left", 5, 2)
      inputmod.button("A", 5)
      inputmod.button("down", 5, 2)
      inputmod.button("right", 5, 2)
    else  --write "HATER"
      inputmod.button("right", 5, 7)
      inputmod.button("A", 5)
      inputmod.button("right", 5, 2)
      inputmod.button("A", 5)
      inputmod.button("down", 5, 2)
      inputmod.button("right", 5)
      inputmod.button("A", 5)
      inputmod.button("up", 5, 2)
      inputmod.button("right", 5, 3)
      inputmod.button("A", 5)
      inputmod.button("down", 5)
      inputmod.button("right", 5, 4)
      inputmod.button("A", 5)
      inputmod.button("down", 5, 3)
      end
    end
    inputmod.button("A")
  skipframes(50)
end
skipframes(200)
end
function menupress(buttontype) -- navigates through menus
  while menuopen() do
    if buttontype == "A" then
      inputmod.button("A")
    elseif buttontype == "B" then
      inputmod.button("B")
    else
      if math.random(3) == 1 then
        inputmod.button("B")
      else 
        inputmod.button("A")
      end
    end
    skipframes(150)
  end
  skipframes(60)
end
function table.contains(table, element)
  
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end
function hasmoved()
  if (x == memory.readbyte(0xD362) and y == memory.readbyte(0xD361)) then
    return false
  else return true
  end
  end