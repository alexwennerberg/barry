module("inputmod", package.seeall)

function button(name, spacing, num) -- presses button and prints input
  local n, m
  if num ~= nil then n = num else n = 1 end
  if spacing ~= nil then m = spacing else m = 0 end
  repeat
  ta = {A=false, B=false, select=false, right=false, left=false, R=false, start=false, L=false, down=false, up=false}
  ta[name] = true
  joypad.set(1, ta)
  print(name)
  vba.frameadvance()
  vba.message(name)
  n = n - 1
  movement.skipframes(m)
  until n == 0
end
function rightof(adirection)
  if adirection == "up" then
    return "right"
  elseif adirection == "left" then
    return "up"
  elseif adirection == "down" then
    return "left"
  else
    return "down"
  end
end
function menuitem()
  return memory.readbyte(0xCC26)
end
function leftof(adirection)
  if adirection == "up" then
    return "left"
  elseif adirection == "left" then
    return "down"
  elseif adirection == "down" then
    return "right"
  else
    return "up"
  end
end

function checkitem(itemnum) -- takes an item number and tells u if u have it and where
  local j=-1
  for i=0xD31E,0xD344,2 do    
    j=j+1
    if memory.readbyte(i) == itemnum then
      return j
    end
  end
  return -1
end

function switchtofirst(num)
  openpkmn_start()
  movement.skipframes(50)
  while inputmod.menuitem() ~= (num-1) do
  inputmod.button("down")
  movement.skipframes(15)
end
  inputmod.button("A", 15)
    inputmod.button("down")
  movement.skipframes(15)
    inputmod.button("A")
  movement.skipframes(15)
    inputmod.button("up")
  movement.skipframes(15)
    inputmod.button("A")
  movement.skipframes(15)
    inputmod.button("B", 20, 7)
end
function openpkmn_start()
  inputmod.button("start")
  inputmod.button("start")
  inputmod.button("start")
  movement.skipframes(50)
  while inputmod.menuitem() ~= 1 do 
    inputmod.button("down", 15)
  end
  inputmod.button("A")
end