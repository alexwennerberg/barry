module("battle", package.seeall)
require "inputmod"
function battletype()
  return memory.readbyte(0xD057) -- 1 is wild 2 is trainer
end
function battling()
  --returns a boolean whether you are battling
  if memory.readbyte(0xD057) > 0 then
  return true
else return false
end
end

function battler()
--does a battle
print("battle")
movement.skipframes(400)
inputmod.button("A", 300)
while(battling()) do
  inputmod.button("A", 150)
  --selects action if the cursor is on the action selecting box
if memory.readbyte(0xCC25) == 9 or memory.readbyte(0xCC25) == 15 then 
    print(catchnext, inputmod.checkitem(4), opphealthpercent(), battletype())
  --runs if weak
  if (battletype() == 1) and (pokehealthpercent() < .1) then
    run()
  --catches pokemon if you have pokeballs and the opponent is week.
  --only does basic pokeballs right now
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
  --switches pokemon
elseif memory.readbyte(0xCF94) == 2 then
  inputmod.button("down", 15)
  inputmod.button("A", 100, 2)
  if math.random(10) == 9 then inputmod.button("B") end
end
  --selects move if the move selection screen's open
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
  --selects the move of the given choice
  while memory.readbyte(0xCC2A) ~= choice do
  inputmod.button("down")
  movement.skipframes(10)
end
inputmod.button("A")
movement.skipframes(50)
end
function run()
  --runs
  inputmod.button("right")
  movement.skipframes(5)
  inputmod.button("down")
  movement.skipframes(5)
  inputmod.button("A")
  movement.skipframes(100)
end
function item()
  --opens item screen
  inputmod.button("left")
  movement.skipframes(5)
  inputmod.button("down")
  movement.skipframes(5)
  inputmod.button("A")
  movement.skipframes(15)
end

function fight()
  --fights
  inputmod.button("left", 15)
  inputmod.button("up", 15)
  inputmod.button("A", 15)
end

function pkmn()
  --wip
end
function pp(movenum)
  --returns pp of the given move number
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
  --returns pokemon health percent
  return (memory.readbyte(0xD016) / (memory.readbyte(0xD024)))
end
function opphealthpercent()
  --returns opponent pokemon health percent
  return (memory.readbyte(0xCFE7) / (memory.readbyte(0xCFF5)))
end