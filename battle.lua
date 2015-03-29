module("battle", package.seeall)
require "inputmod"
function battletype()
  return memory.readbyte(0xD057) -- 1 is wild 2 is trainer
end
function battling()
  if memory.readbyte(0xD057) > 0 then
  return true
else return false
end
end

function battler()
print("battle")
movement.skipframes(400)
inputmod.button("A", 300)
while(battling()) do
  inputmod.button("A", 150)
if memory.readbyte(0xCC25) == 9 or memory.readbyte(0xCC25) == 15 then -- select action
    print(catchnext, inputmod.checkitem(4), opphealthpercent(), battletype())
  if (battletype() == 1) and (pokehealthpercent() < .1) then
    run()
  elseif (battletype() == 1) and catchnext and (inputmod.checkitem(4) > -1) and (opphealthpercent() < .5) then
    item()
    n = 1
    while memory.readbyte(0xCC26) ~= inputmod.checkitem(4) do
      inputmod.button("down", 5)
      n = n + 1
      if n > 50 then break end
    end
    movement.skipframes(15)
    inputmod.button("A")
    movement.skipframes(1000)
  else
    fight()
    movement.skipframes(5)
  end
elseif memory.readbyte(0xCF94) == 2 then
  inputmod.button("down", 15)
  inputmod.button("A", 100, 2)
  end
  if memory.readbyte(0x9D00) == 121 then -- select move
    local i = -1
    while pp(i) == 0 do 
      i = math.random(4)
    end
    battlemove(i)
    end
end
finishedbattle = true
movement.skipframes(200)
end
function battlemove(choice)
  while memory.readbyte(0xCC2A) ~= choice do
  inputmod.button("down")
  movement.skipframes(10)
end
inputmod.button("A")
movement.skipframes(50)
end
function run()
  inputmod.button("right")
  movement.skipframes(5)
  inputmod.button("down")
  movement.skipframes(5)
  inputmod.button("A")
  movement.skipframes(100)
end
function item()
  inputmod.button("left")
  movement.skipframes(5)
  inputmod.button("down")
  movement.skipframes(5)
  inputmod.button("A")
  movement.skipframes(15)
end

function fight()
  inputmod.button("left", 15)
  inputmod.button("up", 15)
  inputmod.button("A", 15)
end

function pkmn()
end
function pp(movenum)
    if movenum == 1 then
      return memory.readbyte(0xD02D)
    elseif movenum == 2 then
      return memory.readbyte(0xD02E)
    elseif movenum == 3 then
      return memory.readbyte(0xD02F)
    elseif movenum == 4 then
      return memory.readbyte(0xD030)
    else return 0
    end
end
function pokehealthpercent()
  return (memory.readbyte(0xD016) / (memory.readbyte(0xD024)))
end
function opphealthpercent()
  return (memory.readbyte(0xCFE7) / (memory.readbyte(0xCFF5)))
end