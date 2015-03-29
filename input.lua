module("inputmod", package.seeall)
function button(name) -- presses button and prints input
  ta = joypad.get(1)
  ta[name] = true
  joypad.set(1, ta)
  vba.frameadvance()
  print(name)
  vba.message(name)
end

function printhi()
  print("hi")
  end