import std/strutils
import std/sets

const
  width = 40
  height = 6

var
  cycle = 0
  x_register = 1
  image: array[width * height, char]

for i in 0 ..< width * height:
  image[i] = '.'

template tick() =
  let xpos = cycle mod width
  if xpos - 1 == x_register or xpos == x_register or xpos + 1 == x_register:
    image[cycle] = '#'
  inc cycle

for line in lines("input.txt"):
  if line.len() == 0:
    continue

  let 
    parts = line.split()

  case parts[0]
  of "addx":
    tick()
    tick()
    x_register += parts[1].parseInt()
  of "noop":
    tick()
  else:
    assert false


var
  xpos = 0
  ypos = 0
  content = ""
for _ in image:
  content.add(image[ypos * width + xpos])
  if xpos + 1 >= width:
    inc ypos
    xpos = 0
    content.add('\n')
  else:
    inc xpos
echo content
