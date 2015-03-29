require "inputmod"
require "battle"
require "movement"
function main()
  GUIDETABLE = 
  {{0, {12, 40}, {{10, -1}, {12,11}}, "OA"}, --area, areas u can go to, matching coords to go to those areas, paradigm
  {40, {0}, {{4,12}}, "OA"}, 
  {38, {37}, {{7,1}}, "OA"}, 
  {37, {0}, {{3,8}}, "OA"}, 
  {12, {1, 0}, {{11, -1}, {11, 36}}, "OA"},
  {13, {1, 50}, {{8, 72}, {3, 43}}, "OA"},
  {42, {1}, {{3, 8}}, "OA"},
  {41, {1}, {{3,8}}, "OA"},
  {50, {13, 51}, {{4,8},{5,0}}, "OA"},
  {51, {50,47}, {{17,48},{0,0}}, "RHR"},
  {47, {51}, {{4,8}}, "OA"},
  {54, {2}, {{1,1}}, "OA"},
  {1, {42, 41, 12, 33, 13}, {{29, 19}, {23,25}, {21,36}, {-1,16}, {17,-1}}, "OA"},
  {2, {14, 58, 54}, {{40,19}, {13,25}, {16,17}}, "OA"},
  {58, {2}, {{3,8}}, "OA"}}
  movement.initialize()
  movement.constants()
  catchnext = false
  getparcel()
  beatbrock()
end
function beatbrock()
  catchnext = true
  movement.moveto(47,5,0)
  route13()
  movement.moveto(58,3,3)
  inputmod.button("A")
  inputmod.button("A")
  inputmod.button("A")
  inputmod.button("A", 100, 11)
  while 1 do
  movement.moveto(2,19,11)
  movement.moveto(2,12,20)
  movement.moveto(54,4,6)
  movement.go("up", 5)
  end
  end
function getparcel()
  movement.start()
  movement.go("right")
  movement.moveto(0, 10, 1)
  donothing(26) 
  pickstarter()
  movement.moveto(42,2,5)
  movement.moveto(40,5,3) -- get parcel
  movement.go("up")
  healpkmn()
  buyitem(2)
end
function donothing(time) 
  -- does nothing but navigate thru menues for time seconds
  for i=1, time do
    movement.menupress()
  end
  end
function wander(place)
  while movement.currlocation() == place do -- get out of start home
    movement.smartmove()
  end
  end
function pickstarter()
  movement.resetarea()
  print("picking starter")
  starter = math.random(3)
  if starter == 1 then
    print("charmander")
    movement.walkto(6,4)
  elseif starter == 2 then
    print("squirtle")
    movement.walkto(7,4)
  elseif starter == 3 then
    print("bulbasaur")
    movement.walkto(8,4)
  end
  print(starter)
    inputmod.button("up", 0 ,4)
    inputmod.button("A")
    inputmod.button("A")
    inputmod.button("A")
    inputmod.button("A")
    inputmod.button("A")
    inputmod.button("A")
    inputmod.button("A")
    inputmod.button("A")
    inputmod.button("A")
    inputmod.button("A")
    inputmod.button("A")
    inputmod.button("A")
    inputmod.button("A")
    inputmod.button("A")
    inputmod.button("A")
    inputmod.button("A")
    inputmod.button("A")
    inputmod.button("A")
    vba.frameadvance()
    inputmod.button("A")
    inputmod.button("A")
    inputmod.button("A")
    inputmod.button("A", 100,10)
    donothing(5)
    end
function grindto(level, catchto)
  catchnext = true
  for i=1,6 do
    while pkmnlevel(i) > 0 and pkmnlevel(i) < level do

      movement.smartmove()
      for i=1, numpkmn() do
          if numpkmn() == catchto then
          catchnext = false end
        if pkmnhealth(i) > .1 then break end
        healpkmn()
        end
    end
  end
end
function buyitem(quantity)
  movement.moveto(42, 2, 5)
  inputmod.button("left", 10, 4)
  inputmod.button("A")
  inputmod.button("A", 100, 3)
  inputmod.button("down", 5)
  inputmod.button("up", 5, quantity)
  inputmod.button("A", 100, 3)
  inputmod.button("B", 50, 5)
  end
function healpkmn()
  movement.moveto(41,3,3)
  movement.go("up")
  inputmod.button("A")
  inputmod.button("A", 50, 11)
end
function numpkmn()
  return memory.readbyte(0xD163)
end
function pkmnhealth(num)
  if num == 1 then
    return memory.readbyte(0xD16D) / memory.readbyte(0xD18E)
  elseif num == 2 then
    return memory.readbyte(0xD199) / memory.readbyte(0xD1BA)
  elseif num == 3 then
    return memory.readbyte(0xD1C5) / memory.readbyte(0xD1E6)
  elseif num == 4 then
    return memory.readbyte(0xD1F1) / memory.readbyte(0xD212)
  elseif num == 5 then
    return memory.readbyte(0xD21D) / memory.readbyte(0xD23E)
  elseif num == 6 then
    return memory.readbyte(0xD249) / memory.readbyte(0xD26A)
  end
  end

function findweakest()
  local lowest = pkmnlevel(1)
  position = 1
  for i=2,6 do
    print(pkmnlevel(i))
    if pkmnlevel(i) < lowest and pkmnlevel(i) ~= 0 then
    lowest = pkmnlevel(i)
    position = i
    end
  end
return position
end
function pkmnlevel(num)
    if num == 1 then
    return memory.readbyte(0xD18C)
  elseif num == 2 then
    return memory.readbyte(0xD1B8)
  elseif num == 3 then
    return memory.readbyte(0xD1E4)
  elseif num == 4 then
    return memory.readbyte(0xD210)
  elseif num == 5 then
    return memory.readbyte(0xD23C)
  elseif num == 6 then
    return memory.readbyte(0xD268)
  end
  end
function route13()
movement.go("up", 2)
movement.go("right", 6)
movement.go("up", 12)
end
function getmoney()
  return memory.readbyte(0xD349) + memory.readbyte(0xD348)*100
end
main()